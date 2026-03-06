import json
import math
import os

# Load library immediately
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIB_PATH = os.path.join(BASE_DIR, 'utils', 'gesture_library.json')

with open(LIB_PATH, 'r') as f:
    GESTURE_LIBRARY = json.load(f)

def cosine_similarity(v1, v2):
    """Calculate the cosine similarity between two vectors."""
    if len(v1) != len(v2):
        return 0.0

    dot_product = sum(a * b for a, b in zip(v1, v2))
    norm_v1 = math.sqrt(sum(a * a for a in v1))
    norm_v2 = math.sqrt(sum(b * b for b in v2))

    if norm_v1 == 0 or norm_v2 == 0:
        return 0.0

    return dot_product / (norm_v1 * norm_v2)

def match_gesture(incoming_vector, threshold=0.95):
    """
    Compares the incoming 7D vector against the library.
    Returns the string intent if similarity > threshold, else None.
    """
    best_match = None
    highest_score = 0.0

    for intent, library_vector in GESTURE_LIBRARY.items():
        score = cosine_similarity(incoming_vector, library_vector)
        if score > highest_score:
            highest_score = score
            best_match = intent

    if highest_score >= threshold:
        return best_match
    
    return None
