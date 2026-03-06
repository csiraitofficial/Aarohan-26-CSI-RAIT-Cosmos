def calculate_vocal_params(heart_rate):
    """
    Translates the raw biological heart rate (BPM) into a TTS speed multiplier
    to emulate the student's inner emotional state.
    """
    try:
        hr = int(heart_rate)
    except (ValueError, TypeError):
        # Default fallback to normal resting rate if data is corrupted
        hr = 75

    if hr < 65:
        return 0.85 # Calm / Lethargic
    elif 65 <= hr <= 85:
        return 1.00 # Normal / Resting
    elif 86 <= hr <= 100:
        return 1.15 # Engaged / Elevated
    else:
        return 1.30 # Excited / Anxious (> 100)

if __name__ == "__main__":
    # Test cases
    print(f"BPM 50  -> Speed {calculate_vocal_params(50)}")
    print(f"BPM 75  -> Speed {calculate_vocal_params(75)}")
    print(f"BPM 90  -> Speed {calculate_vocal_params(90)}")
    print(f"BPM 120 -> Speed {calculate_vocal_params(120)}")
