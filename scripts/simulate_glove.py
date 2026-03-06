"""
simulate_glove.py — SYNAPSE Smart Glove Simulator
===================================================
Pipe named gesture shortcuts directly into the Hub's WebSocket (port 81)
without any physical hardware connected.

Usage:
  python scripts/simulate_glove.py

Commands:
  question   → Sign for asking a question
  help       → Sign for needing help
  yes        → Sign for yes/agreement
  no         → Sign for no/disagreement
  repeat     → Sign for "please repeat that"
  hr <num>   → Set heart rate for next packet (default: 75)
  quit / q   → Exit
"""

import asyncio
import websockets

HUB_WS_URL = "ws://localhost:81"

# Named gesture → 7D vector [Thumb, Index, Middle, Ring, Pinky, GyroX, GyroY]
GESTURE_LIBRARY = {
    "question":  [0.9, 0.1, 0.1, 0.1, 0.9, 0.1, -0.3],
    "help":      [0.9, 0.9, 0.9, 0.9, 0.9, 0.0, 0.0],
    "yes":       [0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2],
    "no":        [0.0, 0.9, 0.9, 0.0, 0.0, -0.1, 0.0],
    "repeat":    [0.5, 0.9, 0.9, 0.9, 0.0, 0.0, 0.5],
}

heart_rate = 75  # Default BPM


def format_packet(vector: list, hr: int) -> str:
    vals = ",".join(f"{v:.2f}" for v in vector)
    return f"<{vals},{hr}>"


async def run():
    global heart_rate
    print("=" * 52)
    print("   SYNAPSE GLOVE SIMULATOR — Dev Tool")
    print("=" * 52)
    print("Gestures: question | help | yes | no | repeat")
    print("Heart Rate: hr <num>  (default: 75)")
    print("Quit: q")
    print()

    async with websockets.connect(HUB_WS_URL) as ws:
        print(f"[Simulator] Connected to Hub at {HUB_WS_URL}\n")

        while True:
            cmd = input(">>> ").strip().lower()

            if cmd in ("q", "quit", "exit"):
                print("[Simulator] Exiting.")
                break

            elif cmd.startswith("hr "):
                try:
                    heart_rate = int(cmd.split()[1])
                    print(f"[Simulator] Heart rate set to {heart_rate} BPM")
                except (IndexError, ValueError):
                    print("[Simulator] Usage: hr <number>")

            elif cmd in GESTURE_LIBRARY:
                vector = GESTURE_LIBRARY[cmd]
                packet = format_packet(vector, heart_rate)
                await ws.send(packet)
                print(f"[Simulator] Sent: {packet}")

            elif cmd == "":
                pass  # ignore empty input

            else:
                print(f"[Simulator] Unknown gesture '{cmd}'. Try: {', '.join(GESTURE_LIBRARY.keys())}")


if __name__ == "__main__":
    asyncio.run(run())
