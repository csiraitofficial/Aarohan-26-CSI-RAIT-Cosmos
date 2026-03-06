# Synapse Flashing Script (All-in-One)
# Run this in PowerShell to set up your boards!

$CLI = "C:\Program Files\Arduino CLI\arduino-cli.exe"

Write-Host "--- 1. Installing Cores ---" -ForegroundColor Cyan
& $CLI core update-index
& $CLI core install arduino:avr
& $CLI config set board_manager.additional_urls http://arduino.esp8266.com/stable/package_esp8266com_index.json
& $CLI core update-index
& $CLI core install esp8266:esp8266

Write-Host "--- 2. Installing Libraries ---" -ForegroundColor Cyan
& $CLI lib install "MPU6050 by Electronic Cats"
& $CLI lib install "WebSockets"

Write-Host "--- 3. Compiling Code ---" -ForegroundColor Cyan
& $CLI compile --fqbn arduino:avr:uno "$PSScriptRoot\synapse_sensor"
& $CLI compile --fqbn esp8266:esp8266:nodemcuv2 "$PSScriptRoot\synapse_wifi"

Write-Host "`n--- READY TO FLASH ---" -ForegroundColor Green
Write-Host "Detected Boards:" -ForegroundColor Yellow
& $CLI board list

Write-Host "`nTo flash the UNO, run:" -ForegroundColor Gray
Write-Host "& '$CLI' upload -p COM_UNO --fqbn arduino:avr:uno '$PSScriptRoot\synapse_sensor'" -ForegroundColor Green

Write-Host "`nTo flash the ESP8266, run:" -ForegroundColor Gray
Write-Host "& '$CLI' upload -p COM_ESP --fqbn esp8266:esp8266:nodemcuv2 '$PSScriptRoot\synapse_wifi'" -ForegroundColor Green

Write-Host "`n(Replace COM_UNO and COM_ESP with your actual ports)" -ForegroundColor Yellow
