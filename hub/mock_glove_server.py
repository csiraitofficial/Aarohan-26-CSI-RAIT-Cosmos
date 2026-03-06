import asyncio
import websockets
import sys

PORT = 81
clients = set()

async def handler(websocket):
    print(f"[Mock Glove Server] New client connected: {websocket.remote_address}")
    clients.add(websocket)
    try:
        async for message in websocket:
            print(f"[Mock Glove Server] Received: {message}")
            if clients:
                other_clients = {c for c in clients if c != websocket}
                if other_clients:
                    websockets.broadcast(other_clients, message)
    except websockets.exceptions.ConnectionClosed:
        pass
    finally:
        print(f"[Mock Glove Server] Client disconnected: {websocket.remote_address}")
        clients.remove(websocket)

async def main():
    try:
        async with websockets.serve(handler, "0.0.0.0", PORT):
            print(f"Mock Glove Server running on ws://0.0.0.0:{PORT}")
            while True:
                await asyncio.sleep(3600)
    except Exception as e:
        print(f"[Mock Glove Server] FATAL ERROR: {e}")
        sys.exit(1)

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n[Mock Glove Server] Shutting down.")
