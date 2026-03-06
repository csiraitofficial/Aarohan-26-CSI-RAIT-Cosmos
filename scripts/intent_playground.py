"""
intent_playground.py — SYNAPSE Intent Playground
==================================================
Test the Ollama intent generation pipeline directly without spinning up the
full Hub server. Useful for prompt engineering and quick iteration.

Usage:
  python scripts/intent_playground.py
"""

import sys
import os

# Ensure the hub package is in path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from hub.services.intent_service import generate_fluent_speech

DEFAULT_CONTEXT = "The teacher is explaining photosynthesis and the process of how plants convert sunlight into energy."


def main():
    print("=" * 55)
    print("   SYNAPSE INTENT PLAYGROUND — Prompt Tester")
    print("=" * 55)
    print("Type a gesture shorthand and optional context.")
    print("Quit: q\n")

    while True:
        shorthand = input("Gesture (e.g. 'question'): ").strip()
        if shorthand.lower() in ("q", "quit", "exit"):
            print("Exiting playground.")
            break
        if not shorthand:
            continue

        context_input = input(f"Context (Enter for default): ").strip()
        context = context_input if context_input else DEFAULT_CONTEXT

        print("\n[Ollama] Generating...")
        result = generate_fluent_speech(shorthand, context)
        print(f"\n✅ Translation: \"{result}\"\n")
        print("-" * 55)


if __name__ == "__main__":
    main()
