// ===================================
// SYNAPSE — Full Uno Sensor Test
// ===================================
// All 4 flex sensors + MPU6050 together.
// This is what the Uno will send to ESP8266.

#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

const int INDEX_PIN  = A0;
const int MIDDLE_PIN = A1;
const int RING_PIN   = A2;
const int PINKY_PIN  = A3;

void setup() {
  Serial.begin(115200);
  Wire.begin();
  mpu.initialize();
  mpu.setSleepEnabled(false);

  Serial.println("=== Full Uno Sensor Test ===");
  Serial.println("All 4 flex + Gyro working together");
  delay(500);
}

void loop() {
  int fIdx = analogRead(INDEX_PIN);
  int fMid = analogRead(MIDDLE_PIN);
  int fRng = analogRead(RING_PIN);
  int fPnk = analogRead(PINKY_PIN);

  int16_t ax, ay, az, gx, gy, gz;
  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
  float gyroX = gx / 131.0;
  float gyroY = gy / 131.0;

  // Print like the actual firmware format
  Serial.print("Idx:");  Serial.print(fIdx);
  Serial.print(" Mid:");  Serial.print(fMid);
  Serial.print(" Rng:");  Serial.print(fRng);
  Serial.print(" Pnk:");  Serial.print(fPnk);
  Serial.print(" GX:");   Serial.print(gyroX, 2);
  Serial.print(" GY:");   Serial.println(gyroY, 2);

  delay(200);
}
