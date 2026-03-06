#include <ESP8266WiFi.h>
#include <WebSocketsServer.h>

// Networking Configuration
const char* WIFI_SSID = "infinix";
const char* WIFI_PASSWORD = "Rohan2233";

// WebSocket Server on Port 81
WebSocketsServer webSocket(81);

// Thumb Flex Sensor on ESP8266's only analog pin
const int THUMB_PIN = A0;

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
  switch (type) {
    case WStype_DISCONNECTED:
      Serial.printf("[%u] Disconnected!\n", num);
      break;
    case WStype_CONNECTED: {
      IPAddress ip = webSocket.remoteIP(num);
      Serial.printf("[%u] Connected from %d.%d.%d.%d url: %s\n", num, ip[0], ip[1], ip[2], ip[3], payload);
      webSocket.sendTXT(num, "Synapse ESP8266 Connected!");
      break;
    }
  }
}

void setup() {
  // Start Serial (Connected to Arduino Uno TX)
  Serial.begin(115200);

  // Connect to WiFi network
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("Connected! IP address: ");
  Serial.println(WiFi.localIP());

  // Start WebSocket Server
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
  Serial.println("WebSocket server started on port 81");
}

void loop() {
  webSocket.loop();

  // Read incoming Serial lines from Arduino Uno
  if (Serial.available()) {
    String dataStr = Serial.readStringUntil('\n');
    dataStr.trim();

    // Check if the data looks like a valid CSV packet from Uno: <Index,Middle,Ring,Pinky,GX,GY>
    if (dataStr.startsWith("<") && dataStr.endsWith(">")) {
      // Read Thumb flex sensor from ESP8266's own A0 pin
      int thumbValue = analogRead(THUMB_PIN);

      // Strip angle brackets to get the raw CSV
      String csvFromUno = dataStr.substring(1, dataStr.length() - 1);

      // Merge: Prepend Thumb (F1) at the beginning
      // Uno sends:   Index,Middle,Ring,Pinky,GX,GY
      // We produce:  Thumb,Index,Middle,Ring,Pinky,GX,GY
      String mergedPacket = "<" + String(thumbValue) + "," + csvFromUno + ">";

      // Broadcast the merged 7D vector to all connected WebSocket clients
      webSocket.broadcastTXT(mergedPacket);
    }
  }
}
