@echo off
REM Backend Server Startup Script for Windows
REM Make sure whisper is installed and in PATH first!

echo.
echo ============================================
echo HealthGuard Backend Server Startup
echo ============================================
echo.

REM Check if whisper is installed
whisper --version >nul 2>&1
if errorlevel 1 (
    echo WARNING: Whisper not found in PATH!
    echo Install whisper.cpp first:
    echo https://github.com/ggerganov/whisper.cpp/releases
    echo.
    echo Or edit .env and set:
    echo USE_LOCAL_WHISPER=false
    echo OPENAI_API_KEY=your-key
    echo.
)

REM Check if .env exists
if not exist .env (
    echo Creating .env from .env.example...
    copy .env.example .env
    echo Created .env - review configuration if needed
    echo.
)

REM Show configuration
echo Current Configuration:
echo ========================
type .env | findstr /v "^$" | findstr /v "^#"
echo.

REM Start the server
echo Starting Node.js backend...
echo Server will run on: http://localhost:3000
echo.
echo Press Ctrl+C to stop the server
echo.

node --watch api.js

pause
