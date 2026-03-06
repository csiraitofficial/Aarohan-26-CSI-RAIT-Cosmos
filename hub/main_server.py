import asyncio
import websockets
import time

# Import our custom logic services
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from pc_hub.whisper_service import get_recent_transcript, handle_audio_stream

from services.gesture_engine import match_gesture
from services.intent_service import generate_fluent_speech
from services.app_sync_service import start_app_sync_server, broadcast_telemetry
from services.voice_service import speak_text
# NOTE: Affective Resonance disabled — no pulse sensor in hardware
# from services.affective_resonance import calculate_vocal_params
DEFAULT_SPEED = 1.0  # Fixed TTS speed (no heart rate modulation)

GLOVE_WS_URL = "ws://localhost:81"

# To prevent spamming the LLM and the Telemetry when a gesture is held
last_match_time = 0
MATCH_COOLDOWN = 1.0 # 1 second before matching again

# The get_recent_transcript is now imported directly from pc_hub.whisper_service

async def ingest_glove_data():
    """Connects to the Smart Glove (or Mock Server) and pipes vectors to the intent engine."""
    global last_match_time
    
    while True: # Auto-reconnect loop
        print(f"[PC Hub] Attempting connection to Glove Data Stream at {GLOVE_WS_URL}...")
        try:
             async with websockets.connect(GLOVE_WS_URL) as websocket:
                print(f"[PC Hub] Connected to Glove Data Stream!")
                
                async for message in websocket:
                    # Expecting format: <F1,F2,F3,F4,F5,GX,GY> (7 values, no HR)
                    msg = message.strip()
                    if msg.startswith("<") and msg.endswith(">"):
                        data_str = msg[1:-1]
                        parts = data_str.split(',')
                        
                        if len(parts) == 6:
                            try:
                                # Parse out 6D vector (4 fingers + 2 gyro)
                                vector = [float(p) for p in parts[:6]]
                                
                                current_time = time.time()
                                
                                # Attempt a match if cooldown has passed
                                if current_time - last_match_time > MATCH_COOLDOWN:
                                    intent = match_gesture(vector, threshold=0.92)
                                    
                                    if intent:
                                        last_match_time = current_time
                                        t_pipeline_start = time.perf_counter()
                                        print(f"\n[Glove Match]: Hand state identified as '{intent.upper()}'")
                                        
                                        # 1. Grab Context
                                        context = get_recent_transcript()
                                        t_context = time.perf_counter()
                                        
                                        # 2. Ask Ollama for fluent speech
                                        print(f"[Ollama] Translating intent using context: '{context}'...")
                                        speech = generate_fluent_speech(intent, context)
                                        t_ollama = time.perf_counter()
                                        print(f"[Speech Output]: \"{speech}\"")
                                        
                                        # 3. Speak Out Loud via TTS (fixed speed — no pulse sensor)
                                        speak_text(speech, speed=DEFAULT_SPEED)
                                        t_tts = time.perf_counter()
                                        
                                        # 4. Broadcast to the Flutter UI
                                        await broadcast_telemetry(intent, speech)
                                        t_broadcast = time.perf_counter()
                                        
                                        # --- Latency Probe ---
                                        total_ms = (t_broadcast - t_pipeline_start) * 1000
                                        ollama_ms = (t_ollama - t_context) * 1000
                                        tts_ms = (t_tts - t_ollama) * 1000
                                        broadcast_ms = (t_broadcast - t_tts) * 1000
                                        print(f"[Latency Probe] Total: {total_ms:.1f}ms | Ollama: {ollama_ms:.1f}ms | TTS: {tts_ms:.1f}ms | Broadcast: {broadcast_ms:.1f}ms")
                                        
                            except ValueError as e:
                                print(f"Value Parsing Error: {e} with payload {data_str}")
        
        except (websockets.exceptions.ConnectionClosedError, ConnectionRefusedError):
            print("[PC Hub] Disconnected from Glove. Retrying in 2 seconds...")
            await asyncio.sleep(2)

async def main():
    print("=====================================================")
    print("      THE SYNAPSE HUB IS ONLINE                      ")
    print("=====================================================")
    
    # Start the Whisper Audio Server concurrently (Port 8765)
    whisper_server = await websockets.serve(handle_audio_stream, "0.0.0.0", 8765)
    print("[PC Hub] Whisper Audio Server running on Port 8765.")

    # Start the App Telemetry Server concurrently (Port 82)
    # The server runs in the background while we ingest glove data
    async with await start_app_sync_server(port=82):
        print("[PC Hub] App Telemetry Server running on Port 82.")
        
        # Connect to Glove logic (Port 81)
        await ingest_glove_data()
        
    await whisper_server.wait_closed()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n[PC Hub] Shutting down.")
