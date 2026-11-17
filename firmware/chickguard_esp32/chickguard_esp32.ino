/*
 * ============================================================================
 * ChickGuard - Firmware ESP32 Final (MQTT Telemetri & Kontrol Aktuator)
 * ============================================================================
 * Library yang dibutuhkan (Arduino IDE -> Tools -> Manage Libraries):
 *  - "PubSubClient" by Nick O'Leary
 *  - "DHT sensor library" by Adafruit + "Adafruit Unified Sensor"
 *  - "ESP32Servo" by Kevin Harrington
 *  - "Adafruit SSD1306" + "Adafruit GFX Library" (Opsional, untuk OLED 0.96")
 * ============================================================================
 */

#include <WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>
#include <ESP32Servo.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// ===== 1. KONFIGURASI WIFI (Ganti dengan WiFi Anda) =====
const char* WIFI_SSID     = "repan";
const char* WIFI_PASSWORD = "11111111";

// ===== 2. KONFIGURASI MQTT BROKER =====
const char* MQTT_BROKER       = "broker.emqx.io";
const int   MQTT_PORT         = 1883;
const char* MQTT_TOPIC_SENSOR = "chickguard/sensor"; // Kirim data sensor ke sini
const char* MQTT_TOPIC_CMD    = "chickguard/cmd";    // Terima perintah sakelar/servo dari web

// ===== 3. PIN MAPPING HARDWARE =====
#define PIN_DHT           4    // DHT22 DATA (GPIO4)
#define PIN_LDR           34   // LDR Divider OUT (GPIO34 / ADC1)
#define PIN_AIR           35   // Water Level Sensor OUT (GPIO35 / ADC1)
#define PIN_RELAY_KIPAS   26   // Relay 1 Kipas (GPIO26, Active-LOW)
#define PIN_RELAY_LAMPU   27   // Relay 2 Lampu (GPIO27, Active-LOW)
#define PIN_SERVO         18   // Servo MG996R Dispenser (GPIO18)
#define PIN_SDA           21   // OLED SDA
#define PIN_SCL           22   // OLED SCL

#define DHT_TYPE          DHT22
#define OLED_ADDR         0x3C

// ===== 4. KALIBRASI SENSOR =====
#define ADC_AIR_KERING    0
#define ADC_AIR_PENUH     2000 // Sesuaikan nilai ADC saat terendam penuh air
#define LDR_ADC_GELAP     4095
#define LDR_ADC_TERANG    500

// Ambang Batas Otomasi Mandiri (bila web tidak mengatur manual)
#define BATAS_SUHU_PANAS  30.0 // Suhu >= 30.0 C -> Kipas ON
#define BATAS_CAHAYA_GELAP 300 // Cahaya < 300 lx -> Lampu ON

// ===== OBJEK & VARIABEL GLOBAL =====
DHT dht(PIN_DHT, DHT_TYPE);
Servo servoPakan;
WiFiClient espClient;
PubSubClient mqttClient(espClient);
Adafruit_SSD1306 oled(128, 64, &Wire, -1);

bool oledAktif = false;
bool kipasAktif = false;
bool lampuAktif = false;
bool overrideManual = false; // true jika user mengubah sakelar langsung dari web

float suhuTerakhir = 0.0, lembabTerakhir = 0.0;
float luxTerakhir = 0.0, airTerakhir = 0.0;
unsigned long terakhirKirimSensor = 0;
const unsigned long INTERVAL_KIRIM_MS = 2500; // Kirim tiap 2.5 detik

// Helper Relay Active-LOW (LOW = ON, HIGH = OFF)
void setRelay(uint8_t pin, bool aktif) {
  digitalWrite(pin, aktif ? LOW : HIGH);
}

void jalankanSiklusServoPakan() {
  Serial.println("[SERVO] Dispenser pakan dibuka (siklus pakan)...");
  servoPakan.write(90);
  delay(1200);
  servoPakan.write(0);
  Serial.println("[SERVO] Dispenser pakan ditutup.");
}

// Callback pesan masuk dari Web via MQTT
void mqttCallback(char* topic, byte* payload, unsigned int length) {
  String pesan = "";
  for (unsigned int i = 0; i < length; i++) {
    pesan += (char)payload[i];
  }
  Serial.printf("[MQTT CMD] Topik '%s' -> %s\n", topic, pesan.c_str());

  // Perintah Kipas
  if (pesan.indexOf("\"actuator\":\"kipas\"") >= 0 || pesan.indexOf("\"kipas\"") >= 0) {
    overrideManual = true;
    if (pesan.indexOf("\"value\":1") >= 0 || pesan.indexOf("\"kipas\":1") >= 0) {
      kipasAktif = true;
      setRelay(PIN_RELAY_KIPAS, true);
    } else if (pesan.indexOf("\"value\":0") >= 0 || pesan.indexOf("\"kipas\":0") >= 0) {
      kipasAktif = false;
      setRelay(PIN_RELAY_KIPAS, false);
    }
  }

  // Perintah Lampu
  if (pesan.indexOf("\"actuator\":\"lampu\"") >= 0 || pesan.indexOf("\"lampu\"") >= 0) {
    overrideManual = true;
    if (pesan.indexOf("\"value\":1") >= 0 || pesan.indexOf("\"lampu\":1") >= 0) {
      lampuAktif = true;
      setRelay(PIN_RELAY_LAMPU, true);
    } else if (pesan.indexOf("\"value\":0") >= 0 || pesan.indexOf("\"lampu\":0") >= 0) {
      lampuAktif = false;
      setRelay(PIN_RELAY_LAMPU, false);
    }
  }

  // Perintah Motor Pakan
  if (pesan.indexOf("pakan") >= 0 || pesan.indexOf("\"actuator\":\"motor_pakan\"") >= 0) {
    jalankanSiklusServoPakan();
  }

  // Perintah Semua Aktuator
  if (pesan.indexOf("\"actuator\":\"all\"") >= 0) {
    overrideManual = true;
    bool nyalakan = (pesan.indexOf("\"value\":1") >= 0);
    kipasAktif = nyalakan;
    lampuAktif = nyalakan;
    setRelay(PIN_RELAY_KIPAS, nyalakan);
    setRelay(PIN_RELAY_LAMPU, nyalakan);
    if (nyalakan) {
      jalankanSiklusServoPakan();
    }
  }

  // Kembalikan ke mode otomasi
  if (pesan.indexOf("\"actuator\":\"auto\"") >= 0) {
    overrideManual = false;
    Serial.println("[MODE] Kembali ke otomasi mandiri sensor.");
  }
}

void hubungkanWifi() {
  Serial.println();
  Serial.print("[WiFi] Menghubungkan ke: ");
  Serial.println(WIFI_SSID);

  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println();
  Serial.print("[WiFi] Terhubung! IP: ");
  Serial.println(WiFi.localIP());
}

void hubungkanMqtt() {
  static unsigned long terakhirCoba = 0;
  if (millis() - terakhirCoba < 3000) return;
  terakhirCoba = millis();

  Serial.print("[MQTT] Menghubungkan ke broker " + String(MQTT_BROKER) + "...");
  String clientId = "ChickGuard_" + String((uint32_t)ESP.getEfuseMac(), HEX);

  if (mqttClient.connect(clientId.c_str())) {
    Serial.println(" Sukses!");
    mqttClient.subscribe(MQTT_TOPIC_CMD);
    Serial.printf("[MQTT] Subscribe perintah di topic: '%s'\n", MQTT_TOPIC_CMD);
  } else {
    Serial.printf(" Gagal (rc=%d), coba lagi...\n", mqttClient.state());
  }
}

void updateOled() {
  if (!oledAktif) return;
  oled.clearDisplay();
  oled.setCursor(0, 0);
  oled.setTextSize(1);
  oled.setTextColor(SSD1306_WHITE);

  oled.printf("ChickGuard Live\n");
  oled.drawLine(0, 10, 128, 10, SSD1306_WHITE);

  oled.setCursor(0, 14);
  oled.printf("Suhu : %4.1f C\n", suhuTerakhir);
  oled.printf("Lemb : %4.1f %%\n", lembabTerakhir);
  oled.printf("Lux  : %4.0f lx\n", luxTerakhir);
  oled.printf("Air  : %3.0f %%\n", airTerakhir);

  oled.setCursor(0, 52);
  oled.printf("K:%s L:%s", kipasAktif ? "ON " : "OFF", lampuAktif ? "ON " : "OFF");
  oled.display();
}

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("\n=== ChickGuard ESP32 MQTT System ===");

  // Inisialisasi Relay (Active-LOW: HIGH saat startup agar tidak menyala sesaat)
  digitalWrite(PIN_RELAY_KIPAS, HIGH);
  digitalWrite(PIN_RELAY_LAMPU, HIGH);
  pinMode(PIN_RELAY_KIPAS, OUTPUT);
  pinMode(PIN_RELAY_LAMPU, OUTPUT);

  pinMode(PIN_AIR, INPUT);
  pinMode(PIN_LDR, INPUT);

  dht.begin();
  servoPakan.attach(PIN_SERVO);
  servoPakan.write(0);

  // Inisialisasi OLED (opsional)
  Wire.begin(PIN_SDA, PIN_SCL);
  if (oled.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR)) {
    oledAktif = true;
    oled.clearDisplay();
    oled.setTextSize(1);
    oled.setTextColor(SSD1306_WHITE);
    oled.setCursor(10, 25);
    oled.print("ChickGuard Booting...");
    oled.display();
  }

  hubungkanWifi();
  mqttClient.setServer(MQTT_BROKER, MQTT_PORT);
  mqttClient.setCallback(mqttCallback);
}

void loop() {
  if (WiFi.status() != WL_CONNECTED) {
    hubungkanWifi();
  }

  if (!mqttClient.connected()) {
    hubungkanMqtt();
  } else {
    mqttClient.loop();
  }

  unsigned long sekarang = millis();
  if (sekarang - terakhirKirimSensor >= INTERVAL_KIRIM_MS) {
    terakhirKirimSensor = sekarang;

    // 1. Baca DHT22
    float t = dht.readTemperature();
    float h = dht.readHumidity();
    if (!isnan(t) && !isnan(h)) {
      suhuTerakhir = t;
      lembabTerakhir = h;
    }

    // 2. Baca Water Sensor
    int adcAir = analogRead(PIN_AIR);
    int persenAir = map(constrain(adcAir, ADC_AIR_KERING, ADC_AIR_PENUH), ADC_AIR_KERING, ADC_AIR_PENUH, 0, 100);
    airTerakhir = constrain(persenAir, 0, 100);

    // 3. Baca LDR
    int adcLdr = analogRead(PIN_LDR);
    float lux = map(constrain(adcLdr, LDR_ADC_TERANG, LDR_ADC_GELAP), LDR_ADC_GELAP, LDR_ADC_TERANG, 0, 2000);
    luxTerakhir = constrain(lux, 0.0, 2000.0);

    // Otomasi Mandiri jika tidak dalam override manual
    if (!overrideManual) {
      if (suhuTerakhir >= BATAS_SUHU_PANAS) {
        kipasAktif = true;
      } else {
        kipasAktif = false;
      }
      setRelay(PIN_RELAY_KIPAS, kipasAktif);

      if (luxTerakhir < BATAS_CAHAYA_GELAP) {
        lampuAktif = true;
      } else {
        lampuAktif = false;
      }
      setRelay(PIN_RELAY_LAMPU, lampuAktif);
    }

    // Format JSON Telemetri
    char payload[180];
    snprintf(payload, sizeof(payload),
             "{\"suhu\":%.1f,\"kelembaban\":%.1f,\"cahaya\":%.0f,\"level_air\":%.0f,\"kipas\":%d,\"lampu\":%d}",
             suhuTerakhir, lembabTerakhir, luxTerakhir, airTerakhir,
             kipasAktif ? 1 : 0, lampuAktif ? 1 : 0);

    if (mqttClient.connected()) {
      mqttClient.publish(MQTT_TOPIC_SENSOR, payload);
      Serial.printf("[MQTT TELEMETRI] %s\n", payload);
    }

    updateOled();
  }
}
