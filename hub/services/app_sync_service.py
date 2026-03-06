import asyncio
import json
import websockets

# Keep track of connected UI clients
connected_clients = set()

async def register(websocket):
    """Register a new UI client connection."""
    connected_clients.add(websocket)
    print(f"[App Sync] New UI Client connected. Total: {len(connected_clients)}")

async def unregister(websocket):
    """Remove a UI client upon disconnect."""
    connected_clients.remove(websocket)
    print(f"[App Sync] UI Client disconnected. Total: {len(connected_clients)}")

async def telemetry_handler(websocket, path):
    """Handle the WebSocket lifecycle for the Flutter App Telemetry."""
    await register(websocket)
    try:
        # We just need to keep the connection open to push data
        async for message in websocket:
            # We don't expect much incoming data on port 82, it's mostly outbound
            print(f"[App Sync] Received message from UI: {message}")
    finally:
        await unregister(websocket)

async def broadcast_telemetry(intent, final_sentence):
    """
    Broadcasts the matched intent and the LLM sentence to all connected Flutter Apps.
    """
    if connected_clients:
        payload = {
            "type": "telemetry",
            "intent": intent,
            "speech": final_sentence
        }
        
        message = json.dumps(payload)
        
        # Send to all connected clients concurrently
        await asyncio.gather(
            *[client.send(message) for client in connected_clients],
            return_exceptions=True
        )
        print(f"[App Sync] Broadcasted Telemetry to {len(connected_clients)} clients.")

async def start_app_sync_server(port=82):
    """Starts the WebSocket server for the App UI."""
    print(f"[App Sync] Starting Telemetry Server on ws://0.0.0.0:{port}...")
    # Bind to 0.0.0.0 so the Flutter app can connect over WiFi (not just localhost)
    return await websockets.serve(telemetry_handler, "0.0.0.0", port)
