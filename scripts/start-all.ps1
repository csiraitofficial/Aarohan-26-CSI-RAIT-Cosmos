# SYNAPSE Unified Startup Script

$GEMINI_KEY = $env:GEMINI_API_KEY
$BACKEND_URL = $env:BACKEND_URL
$REPO_ROOT = "$PSScriptRoot\.."

if (-not $GEMINI_KEY) {
    Write-Host "WARNING: GEMINI_API_KEY not set. Using fallback (may fail)." -ForegroundColor Yellow
}

Write-Host "Starting SYNAPSE Services..." -ForegroundColor Cyan

# 1. Start Node.js Backend
Write-Host "Starting Backend..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd $REPO_ROOT\backend; npm start"

# 2. Start PC Hub (Python)
Write-Host "Starting PC Hub..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd $REPO_ROOT\hub; python main_server.py"

# 3. Start Flutter App
Write-Host "Starting Flutter App (Windows Desktop)..." -ForegroundColor Green
$flutterArgs = "--dart-define=GEMINI_API_KEY=$GEMINI_KEY"
if ($BACKEND_URL) {
    $flutterArgs += " --dart-define=BACKEND_URL=$BACKEND_URL"
}

cd $REPO_ROOT\healthguard_app
flutter run -d windows $flutterArgs
