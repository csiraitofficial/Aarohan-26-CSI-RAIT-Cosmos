import pyttsx3

# Initialize the global TTS engine once
engine = pyttsx3.init()

# We can pre-configure the base rate/volume here if desired
# engine.setProperty('rate', 150)    # Speed percent (can go over 100)
# engine.setProperty('volume', 0.9)  # Volume 0-1

def speak_text(text, speed=1.0):
    """
    Renders text to local audio synchronously off the PC Hub.
    speed is a multiplier (e.g. 1.2 is 20% faster than baseline).
    """
    try:
        # Re-initialize or get current property to allow dynamic scaling
        base_rate = 150 # Standard readable English pace
        target_rate = int(base_rate * speed)
        
        # Apply affective resonance speed
        engine.setProperty('rate', target_rate)
        
        print(f"[TTS] Speaking at {target_rate} wpm: '{text}'")
        
        engine.say(text)
        
        # Blocks the thread while speaking (acting as the physical climax of the loop)
        engine.runAndWait()
        
    except Exception as e:
        print(f"[TTS Error] Could not synthesize audio: {e}")

# If run directly just to test audio
if __name__ == "__main__":
    speak_text("Testing the bio digital larynx voice output at normal speed.", speed=1.0)
    speak_text("Testing the bio digital larynx voice output at excited speed.", speed=1.3)
