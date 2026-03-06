import requests
import json
import os

OLLAMA_HOST = os.environ.get("OLLAMA_HOST", "http://localhost:11434")
OLLAMA_URL = f"{OLLAMA_HOST}/api/generate"
# Assuming 'llama3' or 'phi3' is running locally
MODEL_NAME = "deepseek-r1:8b"

def generate_fluent_speech(gesture_intent, recent_transcript):
    """
    Translates raw gesture intent + classroom audio into a fluent spoken sentence.
    """
    
    prompt = f"""
    You are the voice of a student in a classroom. 
    They just signed: '{gesture_intent}'. 
    The teacher recently said: '{recent_transcript}'. 
    Generate a single, natural sentence the student would say out loud to participate. 
    Make it sound like a human speaking.
    Do not add quotes, explanations, or 'Here is a sentence:'.
    """
    
    payload = {
        "model": MODEL_NAME,
        "prompt": prompt,
        "stream": False
    }
    
    try:
        response = requests.post(OLLAMA_URL, json=payload, timeout=5.0)
        response.raise_for_status()
        
        result = response.json()
        return result.get('response', '').strip()
        
    except requests.exceptions.RequestException as e:
        print(f"[Ollama Error] Could not connect or generate: {e}")
        # Fallback to the raw intent if the LLM is down
        return gesture_intent
