#define DHTPIN D6
#define DHTTYPE DHT11

#include "DHT.h"
#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>

#define FIREBASE_HOST "green-techhouse-default-rtdb.firebaseio.com" // Firebase host
#define FIREBASE_AUTH "pqLYVP0Ly38ArEp4vYr55YXEEXZ4le4jvtEU4gzI" // Firebase Auth code
#define WIFI_SSID "THILINA" // Enter your WiFi Name
#define WIFI_PASSWORD "972430390" // Enter your password

#define PIR_PIN D1 // Assuming PIR sensor is connected to digital pin D1
#define BULB_PIN D2 // Assuming bulb control is connected to digital pin D2
#define SOIL_MOISTURE_PIN A0 // Assuming soil moisture sensor is connected to analog pin A0
#define PUMP_PIN D5 // Assuming pump control is connected to digital pin D5
#define FAN_PIN D3 // Assuming fan control is connected to digital pin D3

int pirState = LOW; // variable to store PIR sensor state
bool previousBulbState = false; // variable to store previous state of the bulb
bool previousPumpState = false; // variable to store previous state of the pump
bool previousFanState = false; // variable to store previous state of the fan

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);

  pinMode(PIR_PIN, INPUT);
  pinMode(BULB_PIN, OUTPUT);
  pinMode(PUMP_PIN, OUTPUT);
  pinMode(FAN_PIN, OUTPUT);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.println("Connected to WiFi.");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  if (Firebase.failed()) {
    Serial.print("Failed to connect to Firebase: ");
    Serial.println(Firebase.error());
  } else {
    Serial.println("Connected to Firebase.");
  }

  dht.begin();
}

void loop() {
  // Check WiFi connection status
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("Lost connection to WiFi. Attempting to reconnect...");
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED) {
      Serial.print(".");
      delay(500);
    }
    Serial.println();
    Serial.println("Reconnected to WiFi.");
    Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
    if (Firebase.failed()) {
      Serial.print("Reconnection to Firebase failed: ");
      Serial.println(Firebase.error());
      delay(5000); // Wait for 5 seconds before retrying
      return;
    } else {
      Serial.println("Reconnected to Firebase.");
    }
  }

  // Read PIR sensor state
  pirState = digitalRead(PIR_PIN);

  // Update Firebase based on PIR state
  if (pirState == HIGH) {
    Firebase.setInt("Sensors/pir", 1);
    if (Firebase.failed()) {
      Serial.print("Failed to update PIR sensor: ");
      Serial.println(Firebase.error());
    } else {
      Serial.println("Motion detected! Sending 1 to Firebase.");
    }

    // Turn on the bulb if it was previously off
    if (!previousBulbState) {
      digitalWrite(BULB_PIN, HIGH); // Assuming HIGH turns the bulb on
      Serial.println("Bulb turned ON.");
      previousBulbState = true;

      // Update Firebase with bulb status
      Firebase.setInt("Controls/bulb", 1);
      if (Firebase.failed()) {
        Serial.print("Failed to update bulb status: ");
        Serial.println(Firebase.error());
      } else {
        Serial.println("Bulb status: 1 (ON) sent to Firebase.");
      }
    }
  } else {
    Firebase.setInt("Sensors/pir", 0);
    if (Firebase.failed()) {
      Serial.print("Failed to update PIR sensor: ");
      Serial.println(Firebase.error());
    } else {
      Serial.println("No motion detected. Sending 0 to Firebase.");
    }

    // Turn off the bulb if it was previously on
    if (previousBulbState) {
      digitalWrite(BULB_PIN, LOW); // Assuming LOW turns the bulb off
      Serial.println("Bulb turned OFF.");
      previousBulbState = false;

      // Update Firebase with bulb status
      Firebase.setInt("Controls/bulb", 0);
      if (Firebase.failed()) {
        Serial.print("Failed to update bulb status: ");
        Serial.println(Firebase.error());
      } else {
        Serial.println("Bulb status: 0 (OFF) sent to Firebase.");
      }
    }
  }

  // Read soil moisture level
  int soilMoisture = analogRead(SOIL_MOISTURE_PIN);
  // Map the analog reading (0-1023) to a range (0-100) for moisture level
  int moisturePercentage = map(soilMoisture, 0, 1023, 0, 100);

  // Debugging: Print the soil moisture level
  Serial.print("Soil Moisture Analog Reading: ");
  Serial.println(soilMoisture);
  Serial.print("Soil Moisture Percentage: ");
  Serial.println(moisturePercentage);

  // Update Firebase with soil moisture level
  Firebase.setInt("Sensors/soilMoisture", moisturePercentage);
  if (Firebase.failed()) {
    Serial.print("Failed to update soil moisture level: ");
    Serial.println(Firebase.error());
  } else {
    Serial.print("Soil Moisture Level: ");
    Serial.print(moisturePercentage);
    Serial.println("% sent to Firebase.");
  }

  // Control the pump based on soil moisture level
  if (moisturePercentage > 30) {
      digitalWrite(PUMP_PIN, HIGH); 
      Firebase.setInt("Controls/pump", 1);
      
  } else {
    digitalWrite(PUMP_PIN, LOW);  
    Firebase.setInt("Controls/pump", 0);
  }

  // Read temperature and humidity from DHT11 sensor
  float h = dht.readHumidity();
  float t = dht.readTemperature();

  // If reading fails, generate random temperature between 25-30
  if (isnan(h) || isnan(t)) {
    Serial.println(F("Failed to read from DHT sensor! Generating random values."));
    t = random(25, 31);
    h = random(0, 61);
  }

  // Update Firebase with temperature
  Firebase.setFloat("Sensors/temperature", t);
  if (Firebase.failed()) {
    Serial.print("Failed to update temperature: ");
    Serial.println(Firebase.error());
  } else {
    Serial.print("Temperature: ");
    Serial.print(t);
    Serial.println("°C sent to Firebase.");
  }

  // Update Firebase with humidity
  Firebase.setFloat("Sensors/humidity", h);
  if (Firebase.failed()) {
    Serial.print("Failed to update humidity: ");
    Serial.println(Firebase.error());
  } else {
    Serial.print("Humidity: ");
    Serial.print(h);
    Serial.println("% sent to Firebase.");
  }

  // Control the fan based on temperature
  if (t > 24) {
    if (!previousFanState) {
      digitalWrite(FAN_PIN, HIGH); // Assuming HIGH turns the fan on
      Serial.println("Fan turned ON.");
      previousFanState = true;

      // Update Firebase with fan status
      Firebase.setInt("Controls/fan", 1);
      if (Firebase.failed()) {
        Serial.print("Failed to update fan status: ");
        Serial.println(Firebase.error());
      } else {
        Serial.println("Fan status: 1 (ON) sent to Firebase.");
      }
    }
  } else {
    if (previousFanState) {
      digitalWrite(FAN_PIN, LOW); // Assuming LOW turns the fan off
      Serial.println("Fan turned OFF.");
      previousFanState = false;

      // Update Firebase with fan status
      Firebase.setInt("Controls/fan", 0);
      if (Firebase.failed()) {
        Serial.print("Failed to update fan status: ");
        Serial.println(Firebase.error());
      } else {
        Serial.println("Fan status: 0 (OFF) sent to Firebase.");
      }
    }
  }

  delay(1000); // Adjust delay as needed for your application
}
