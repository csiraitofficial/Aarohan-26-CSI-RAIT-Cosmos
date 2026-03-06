import asyncio
import websockets
import io
import wave
from faster_whisper import WhisperModel

# Initialize Whisper model
print("Initializing Whisper model...")
# Using tiny.en for speed and low resource usage during testing
model = WhisperModel("tiny.en", device="cpu", compute_type="int8")
print("Whisper model initialized.")

LATEST_TRANSCRIPT = ""

def get_recent_transcript():
    global LATEST_TRANSCRIPT
    return LATEST_TRANSCRIPT if LATEST_TRANSCRIPT else "The teacher is explaining photosynthesis."

async def handle_audio_stream(websocket, path):
    global LATEST_TRANSCRIPT
    print(f"Client connected from {websocket.remote_address}")
    try:
        async for message in websocket:
            # message should be binary audio data (WAV)
            print(f"Received audio chunk: {len(message)} bytes")
            
            # Save the chunk to a temporary file for whisper to read
            # In a production app, we could use io.BytesIO and soundfile/numpy directly,
            # but faster-whisper easily accepts a file path.
            temp_filename = "temp_audio_chunk.wav"
            with open(temp_filename, "wb") as f:
                f.write(message)
                
            # Transcribe the audio chunk
            print("Transcribing...")
            segments, info = model.transcribe(temp_filename, beam_size=5)
            
            transcript = ""
            for segment in segments:
                transcript += segment.text + " "
                
            transcript = transcript.strip()
            if transcript:
                print(f"Transcript: {transcript}")
                LATEST_TRANSCRIPT = transcript
            else:
                print("No speech detected.")
                
            # Optionally send back the transcript
            # await websocket.send(transcript)
            
    except websockets.exceptions.ConnectionClosed:
        print("Client disconnected.")
    except Exception as e:
        print(f"Error handling connection: {e}")

async def main():
    server = await websockets.serve(handle_audio_stream, "0.0.0.0", 8765)
    print("WebSocket Server started on ws://0.0.0.0:8765")
    await server.wait_closed()

if __name__ == "__main__":
    asyncio.run(main())
