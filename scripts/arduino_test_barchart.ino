/*
  Arduino Flex Sensor Debugger (Visual Bar Chart)
  Use this to verify your 4-finger glove connection.
  Opens Serial at 115200 baud.
*/

const int SENSORS = 4;
const int PINS[] = {A1, A2, A3, A6}; // Pins defined in synapse_wifi.ino for Index, Middle, Ring, Pinky
const char* NAMES[] = {"INDEX ", "MIDDLE", "RING  ", "PINKY "};

void setup() {
  Serial.begin(115200);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB
  }
  Serial.println("\n--- SYNAPSE GLOVE DEBUG ---");
  Serial.println("Adjust baud to 115200 to see the chart.");
}

void loop() {
  // 1. Visual Bar Chart for Human Debugging
  Serial.println("--------------------------------------------------");
  for (int i = 0; i < SENSORS; i++) {
    int val = analogRead(PINS[i]);
    
    // Map value (0-1023) to a bar length (0-40)
    int barLen = map(val, 0, 1023, 0, 40);
    
    Serial.print(NAMES[i]);
    Serial.print(" [");
    Serial.print(val);
    if (val < 1000) Serial.print(" ");
    if (val < 100) Serial.print(" ");
    if (val < 10) Serial.print(" ");
    Serial.print("]: ");
    
    for (int j = 0; j < barLen; j++) {
      Serial.print("#");
    }
    Serial.println();
  }

  // 2. Hub-Compatible Format (Optional, uncomment if checking PC bridge)
  // Serial.print("<");
  // for (int i = 0; i < SENSORS; i++) {
  //   Serial.print(analogRead(PINS[i]));
  //   Serial.print(",");
  // }
  // Serial.println("0,0>"); // Placeholder for Gyro
  
  delay(100);
}
