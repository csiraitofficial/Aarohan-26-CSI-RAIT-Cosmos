import asyncio
import websockets
import sys
import os

async def send_audio(uri, file_path):
    if not os.path.exists(file_path):
        print(f"Error: File '{file_path}' not found.")
        return

    try:
        async with websockets.connect(uri) as websocket:
            print(f"Connected to {uri}")
            
            with open(file_path, "rb") as f:
                audio_data = f.read()
                
            print(f"Sending {len(audio_data)} bytes...")
            await websocket.send(audio_data)
            print("Audio data sent.")
            
            # Keep connection open briefly to see if server responses
            await asyncio.sleep(2)
            
    except ConnectionRefusedError:
        print(f"Error: Connection refused. Is the server running at {uri}?")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python test_audio.py <path_to_wav_file>")
        sys.exit(1)
        
    audio_file = sys.argv[1]
    ws_uri = "ws://localhost:8765"
    
    asyncio.run(send_audio(ws_uri, audio_file))
