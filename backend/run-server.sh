#!/bin/bash

# Backend Server Startup Script for macOS/Linux
# Make sure whisper is installed and in PATH first!

echo ""
echo "============================================"
echo "HealthGuard Backend Server Startup"
echo "============================================"
echo ""

# Check if whisper is installed
if ! command -v whisper &> /dev/null; then
    echo "WARNING: Whisper not found in PATH!"
    echo "Install whisper.cpp first:"
    echo "https://github.com/ggerganov/whisper.cpp"
    echo ""
    echo "Or edit .env and set:"
    echo "USE_LOCAL_WHISPER=false"
    echo "OPENAI_API_KEY=your-key"
    echo ""
fi

# Check if .env exists
if [ ! -f .env ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo "Created .env - review configuration if needed"
    echo ""
fi

# Show configuration
echo "Current Configuration:"
echo "========================"
grep -v '^$' .env | grep -v '^#'
echo ""

# Start the server
echo "Starting Node.js backend..."
echo "Server will run on: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

node --watch api.js
