#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

// Flex Sensor Pins (Arduino Uno: A0-A3 available, A4/A5 used by I2C)
const int FLEX_INDEX_PIN  = A0; // Index
const int FLEX_MIDDLE_PIN = A1; // Middle
const int FLEX_RING_PIN   = A2; // Ring
const int FLEX_PINKY_PIN  = A3; // Pinky

// Timing logic for 50Hz transmission rate
unsigned long lastTime = 0;
const int UPDATE_INTERVAL = 20; // 50Hz = 1000ms / 50

void setup() {
  Serial.begin(115200);

  // Initialize I2C and MPU6050
  Wire.begin();
  mpu.initialize();

  // Give sensors time to stabilize
  delay(100);
}

void loop() {
  unsigned long currentTime = millis();

  // Send data at 50Hz
  if (currentTime - lastTime >= UPDATE_INTERVAL) {
    lastTime = currentTime;

    // Read Flex Sensors (4 fingers)
    int fIndex  = analogRead(FLEX_INDEX_PIN);
    int fMiddle = analogRead(FLEX_MIDDLE_PIN);
    int fRing   = analogRead(FLEX_RING_PIN);
    int fPinky  = analogRead(FLEX_PINKY_PIN);

    // Read MPU6050
    int16_t ax, ay, az, gx, gy, gz;
    mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

    // Convert raw gyro values to deg/s (assuming default 250 deg/s range -> 131 LSB/deg/s)
    float gyroX = gx / 131.0;
    float gyroY = gy / 131.0;

    // Format output as CSV: <Index,Middle,Ring,Pinky,GX,GY>
    Serial.print("<");
    Serial.print(fIndex);  Serial.print(",");
    Serial.print(fMiddle); Serial.print(",");
    Serial.print(fRing);   Serial.print(",");
    Serial.print(fPinky);  Serial.print(",");
    Serial.print(gyroX, 2); Serial.print(",");
    Serial.print(gyroY, 2);
    Serial.println(">");
  }
}
