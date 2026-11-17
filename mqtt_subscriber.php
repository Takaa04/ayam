<?php
/**
 * ChickGuard - Background MQTT Subscriber Worker
 * Menerima data telemetri dari ESP32 & menyimpannya ke MySQL & file cache.
 *
 * Jalankan via CLI:
 *   php mqtt_subscriber.php
 */

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/config/mqtt.php';

use PhpMqtt\Client\MqttClient;
use PhpMqtt\Client\ConnectionSettings;

echo "\n========================================================\n";
echo "   CHICKGUARD - MQTT BACKGROUND SUBSCRIBER SERVICE     \n";
echo "========================================================\n";

// Helper koneksi database MySQL dengan reconnect otomatis
function get_db_connection(): ?mysqli
{
    static $koneksi = null;

    if ($koneksi instanceof mysqli) {
        if (@mysqli_ping($koneksi)) {
            return $koneksi;
        }
        @mysqli_close($koneksi);
        $koneksi = null;
    }

    try {
        mysqli_report(MYSQLI_REPORT_OFF);
        $conn = @mysqli_connect("localhost", "root", "", "chickguard");
        if ($conn && !mysqli_connect_errno()) {
            $koneksi = $conn;
            return $koneksi;
        }
    } catch (\Throwable $e) {
        // DB belum start atau error koneksi
    }

    return null;
}

$cacheFile = __DIR__ . '/data_sensor_live.json';
$topics = [
    MQTT_TOPIC_SENSOR => 0,
    'test_mqtt/water'  => 0, // Fallback untuk testing sketch sebelumnya
];

$clientId = 'cg_subscriber_' . bin2hex(random_bytes(3));
$mqtt = new MqttClient(MQTT_BROKER_HOST, MQTT_BROKER_PORT, $clientId);

$settings = (new ConnectionSettings())
    ->setKeepAliveInterval(60)
    ->setConnectTimeout(5)
    ->setSocketTimeout(5);

try {
    echo "[MQTT] Menghubungkan ke Broker " . MQTT_BROKER_HOST . ":" . MQTT_BROKER_PORT . "...\n";
    $mqtt->connect($settings, true);
    echo "[MQTT] Berhasil Terhubung!\n";

    foreach ($topics as $t => $qos) {
        echo "[MQTT] Subscribe topic: '{$t}'\n";
        $mqtt->subscribe($t, function (string $topic, string $message) use ($cacheFile) {
            $waktu = date('Y-m-d H:i:s');
            $jamMenit = date('H:i:s');

            $data = json_decode($message, true);
            if (!is_array($data)) {
                echo "[{$jamMenit}] [WARN] Payload non-JSON: {$message}\n";
                return;
            }

            // Normalisasi field sensor
            $suhu      = isset($data['suhu']) ? (float)$data['suhu'] : 0.0;
            $lembap    = isset($data['kelembaban']) ? (float)$data['kelembaban'] : 0.0;
            $cahaya    = isset($data['cahaya']) ? (float)$data['cahaya'] : 0.0;
            $levelAir  = isset($data['level_air']) ? (float)$data['level_air'] : (isset($data['persen']) ? (float)$data['persen'] : 0.0);

            // Simpan cache cepat JSON
            $payloadCache = [
                'suhu'       => $suhu,
                'kelembaban' => $lembap,
                'cahaya'     => $cahaya,
                'level_air'  => $levelAir,
                'kipas'      => isset($data['kipas']) ? (int)$data['kipas'] : null,
                'lampu'      => isset($data['lampu']) ? (int)$data['lampu'] : null,
                'updated_at' => $waktu,
            ];
            file_put_contents($cacheFile, json_encode($payloadCache, JSON_PRETTY_PRINT), LOCK_EX);

            // Simpan ke MySQL jika database aktif
            $db = get_db_connection();
            $dbStatus = 'DB Offline';

            if ($db) {
                // 1. Simpan ke data_sensor
                $stmt = mysqli_prepare(
                    $db,
                    "INSERT INTO data_sensor (suhu, kelembaban, cahaya, level_air, recorded_at) VALUES (?, ?, ?, ?, ?)"
                );
                if ($stmt) {
                    mysqli_stmt_bind_param($stmt, "dddds", $suhu, $lembap, $cahaya, $levelAir, $waktu);
                    if (mysqli_stmt_execute($stmt)) {
                        $dbStatus = 'DB Tersimpan';
                    }
                    mysqli_stmt_close($stmt);
                }

        // 2. Sinkronkan status aktuator jika dikirimkan oleh firmware
        // Catatan: Tidak menimpa kolom `motor_pakan` (one-shot dispensing diatur oleh server/web)
        if (isset($data['kipas']) || isset($data['lampu'])) {
            $kipasVal = isset($data['kipas']) ? (int)$data['kipas'] : 0;
            $lampuVal = isset($data['lampu']) ? (int)$data['lampu'] : 0;
            $actStmt = mysqli_prepare($db, "UPDATE actuator_status SET kipas = ?, lampu = ? WHERE id = 1");
            if ($actStmt) {
                mysqli_stmt_bind_param($actStmt, "ii", $kipasVal, $lampuVal);
                mysqli_stmt_execute($actStmt);
                mysqli_stmt_close($actStmt);
            }
        }

                // 3. Peringatan otomatis jika level air kritis (<= 20%)
                static $lastNotifAir = 0;
                if ($levelAir > 0 && $levelAir <= 20 && (time() - $lastNotifAir > 300)) {
                    $lastNotifAir = time();
                    $pesan = "PERINGATAN: Level air tandon kritis (" . round($levelAir) . "%). Segera isi ulang!";
                    $labelWaktu = "Baru saja";
                    $notifStmt = mysqli_prepare($db, "INSERT INTO notifikasi (pesan, tipe, waktu_label) VALUES (?, 'danger', ?)");
                    if ($notifStmt) {
                        mysqli_stmt_bind_param($notifStmt, "ss", $pesan, $labelWaktu);
                        mysqli_stmt_execute($notifStmt);
                        mysqli_stmt_close($notifStmt);
                    }
                }
            }

            printf(
                "[%s] Suhu: %4.1f°C | Lembab: %4.1f%% | Cahaya: %4.0flx | Air: %3.0f%% -> [%s]\n",
                $jamMenit,
                $suhu,
                $lembap,
                $cahaya,
                $levelAir,
                $dbStatus
            );
        }, $qos);
    }

    echo "[MQTT] Siap menerima data sensor ESP32...\n";
    echo "[INFO] Tekan Ctrl + C untuk menghentikan service.\n\n";

    $mqtt->loop(true);
} catch (\Throwable $e) {
    echo "[ERROR FATAL] " . $e->getMessage() . "\n";
    exit(1);
}
