import asyncio
import websockets
import serial
import serial.tools.list_ports
import threading

# Configuration
PORT = 81
SERIAL_BAUD = 115200

# Try to find the Arduino COM port
arduino_port = "COM9"
ports = serial.tools.list_ports.comports()
for p in ports:
    if "Arduino" in p.description or "CH340" in p.description or "Serial Device" in p.description:
        arduino_port = p.device
        break

print(f"Assigning {arduino_port} for Arduino Serial Connection.")

try:
    ser = serial.Serial(arduino_port, SERIAL_BAUD, timeout=1)
except Exception as e:
    print(f"Could not open serial port {arduino_port}: {e}")
    ser = None

clients = set()

async def handler(websocket):
    clients.add(websocket)
    try:
        await websocket.wait_closed()
    finally:
        clients.remove(websocket)

async def broadcast_messages():
    while True:
        if ser and ser.in_waiting > 0:
            try:
                line = ser.readline().decode('utf-8').strip()
                if line.startswith("<") and line.endswith(">"):
                    if clients:
                        # Broadcast the raw 6D vector (Index, Middle, Ring, Pinky, GX, GY)
                        websockets.broadcast(clients, line)
            except Exception as e:
                print(f"Serial read error: {e}")
        await asyncio.sleep(0.01)

async def main():
    async with websockets.serve(handler, "localhost", PORT):
        print(f"Serial to WebSocket bridge running on ws://localhost:{PORT}")
        await broadcast_messages()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
    finally:
        if ser:
            ser.close()
