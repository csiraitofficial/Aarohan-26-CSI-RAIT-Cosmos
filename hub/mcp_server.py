from mcp.server.fastmcp import FastMCP
import json
import random
import time
import ollama

# Create an MCP server
mcp = FastMCP("SYNAPSE Hub Services")

@mcp.tool()
def list_ollama_models() -> str:
    """
    Lists all models currently available in the local Ollama instance.
    """
    try:
        models = ollama.list()
        return json.dumps(models, indent=2)
    except Exception as e:
        return f"Error connecting to Ollama: {e}"

@mcp.tool()
def pull_ollama_model(model_name: str) -> str:
    """
    Pulls a new model from the Ollama library.
    """
    try:
        ollama.pull(model_name)
        return f"Successfully pulled {model_name}"
    except Exception as e:
        return f"Error pulling model: {e}"

@mcp.tool()
def simulate_glove_data() -> str:
    """
    Generates a mock 7D vector packet from the Smart Glove.
    Format: <Thumb, Index, Middle, Ring, Pinky, GyroX, GyroY, HeartRate>
    """
    fingers = [random.randint(0, 100) for _ in range(5)]
    gyro = [random.uniform(-1.0, 1.0) for _ in range(2)]
    hr = random.randint(60, 120)
    
    packet = f"<{','.join(map(str, fingers))},{gyro[0]:.2f},{gyro[1]:.2f},{hr}>"
    return f"Generated Glove Packet: {packet}"

@mcp.tool()
def intent_playground(shorthand: str, context: str = "") -> str:
    """
    Tests the expansion of shorthand sign language phrases using the local Ollama LLM.
    """
    prompt = f"Convert this sign language shorthand: '{shorthand}' into a full, polite sentence. "
    if context:
        prompt += f"Context from the classroom: '{context}'"
    
    try:
        # Using Llama3 as the default internal model for intent expansion
        response = ollama.chat(model='llama3', messages=[
            {'role': 'user', 'content': prompt},
        ])
        return response['message']['content']
    except Exception as e:
        return f"Simulated Intent Prompt (Ollama Down/Missing llama3): {prompt}\nError: {e}"

@mcp.tool()
def latency_probe() -> str:
    """
    Measures simulated end-to-end latency (Glove -> PC -> App).
    """
    # Hardware/Serial (~20ms) + Whisper Processing (~100ms) + Ollama (~300ms) + Network (~10ms)
    total_latency = 430 + random.randint(-50, 50)
    return json.dumps({
        "status": "online",
        "total_latency_ms": total_latency,
        "components": {
            "serial": 20,
            "whisper": 100,
            "ollama": 300,
            "websocket": 10
        }
    }, indent=2)

if __name__ == "__main__":
    mcp.run()
