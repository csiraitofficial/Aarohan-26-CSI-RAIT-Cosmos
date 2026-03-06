# Dockerfile for SYNAPSE PC Hub (Neural-Intent Engine)
FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
# - python3-pyaudio / portaudio19-dev: For microphone/audio access if needed
# - espeak-ng / alsa-utils: Critical for pyttsx3 offline TTS on Linux
# - git: For any git-based dependencies
RUN apt-get update && apt-get install -y \
    espeak-ng \
    alsa-utils \
    portaudio19-dev \
    python3-pyaudio \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy python dependencies
COPY pc_hub/requirements.txt ./pc_hub_reqs.txt
RUN pip install --no-cache-dir -r pc_hub_reqs.txt

# Also install the Phase 3 / Phase 4 dependencies manually if they aren't in requirements.txt yet
RUN pip install --no-cache-dir pyttsx3 requests websockets pydantic

# Copy the hub and pc_hub source code
COPY hub/ ./hub/
COPY pc_hub/ ./pc_hub/

# Expose ports
# 81: Glove WebSocket Data
# 82: App Telemetry WebSocket
# 8765: Whisper Audio WebSocket
EXPOSE 81 82 8765

# Command to run the unified engine
CMD ["python", "hub/main_server.py"]
