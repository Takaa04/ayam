<?php
/**
 * Seeder data dummy untuk database ChickGuard
 * Menghasilkan data sensor 48 jam terakhir, log harian 14 hari, log pakan, dan notifikasi terkini.
 */
require_once __DIR__ . '/../config/koneksi.php';
require_once __DIR__ . '/../proses/init_tables.php';

chickguard_init_tables($koneksi);

mysqli_query($koneksi, "SET FOREIGN_KEY_CHECKS = 0;");

// Pastikan user admin ada
$uRes = mysqli_query($koneksi, "SELECT id FROM users WHERE username = 'admin' LIMIT 1");
if (mysqli_num_rows($uRes) === 0) {
    $hash = password_hash('admin123', PASSWORD_BCRYPT);
    mysqli_query($koneksi, "INSERT INTO users (username, nama_lengkap, email, password, role) VALUES ('admin', 'Bima Apriliansyah', 'admin@chickguard.local', '$hash', 'admin')");
    $adminId = mysqli_insert_id($koneksi);
} else {
    $adminId = (int) mysqli_fetch_assoc($uRes)['id'];
}

// 1. Pengaturan Kandang
mysqli_query($koneksi, "
    INSERT INTO pengaturan_kandang (id, nama_kandang, tanggal_masuk_ayam, suhu_min, suhu_maks, kelembaban_min, kelembaban_maks, cahaya_min, level_air_min)
    VALUES (1, 'Kandang Broiler Utama', DATE_SUB(CURDATE(), INTERVAL 18 DAY), 24.00, 33.00, 55.00, 75.00, 500.00, 50.00)
    ON DUPLICATE KEY UPDATE 
        nama_kandang = VALUES(nama_kandang),
        tanggal_masuk_ayam = VALUES(tanggal_masuk_ayam),
        suhu_min = VALUES(suhu_min),
        suhu_maks = VALUES(suhu_maks),
        kelembaban_min = VALUES(kelembaban_min),
        kelembaban_maks = VALUES(kelembaban_maks)
");

// 2. Actuator Status
mysqli_query($koneksi, "
    INSERT INTO actuator_status (id, kipas, heater, lampu, motor_pakan)
    VALUES (1, 1, 0, 1, 1)
    ON DUPLICATE KEY UPDATE kipas = 1, heater = 0, lampu = 1, motor_pakan = 1
");

// 3. Jadwal Pakan
mysqli_query($koneksi, "TRUNCATE TABLE jadwal_pakan");
$jadwalPakan = [
    ['06:30:00', 3.50, 'Semua Hari', 'Pakan Pagi (Broiler Grower)', 1],
    ['12:00:00', 2.50, 'Semua Hari', 'Pakan Siang Tambahan', 1],
    ['17:00:00', 4.00, 'Semua Hari', 'Pakan Sore & Nutrisi', 1],
    ['22:00:00', 1.50, 'Senin, Rabu, Jumat', 'Pakan Malam Kondisional', 0],
];
$stmtJadwal = mysqli_prepare($koneksi, "INSERT INTO jadwal_pakan (waktu, jumlah, hari, catatan, is_active) VALUES (?, ?, ?, ?, ?)");
foreach ($jadwalPakan as $jp) {
    mysqli_stmt_bind_param($stmtJadwal, "sdssi", $jp[0], $jp[1], $jp[2], $jp[3], $jp[4]);
    mysqli_stmt_execute($stmtJadwal);
}

// Ambil id jadwal yang aktif untuk referensi FK
$jadwalIds = [];
$jRes = mysqli_query($koneksi, "SELECT id FROM jadwal_pakan ORDER BY id ASC");
while ($row = mysqli_fetch_assoc($jRes)) {
    $jadwalIds[] = (int) $row['id'];
}

// 4. Jadwal Pencahayaan
mysqli_query($koneksi, "TRUNCATE TABLE jadwal_pencahayaan");
$jadwalCahaya = [
    ['Lampu Penerangan Utama', '05:30:00', 12.50, 'Semua Hari', 'Penerangan siang hari', 1],
    ['Lampu Pemanas (Brooding)', '18:30:00', 10.00, 'Semua Hari', 'Penghangat & pencahayaan malam', 1],
    ['Lampu Inspeksi Malam', '00:00:00', 1.00, 'Semua Hari', 'Cek kondisi kandang tengah malam', 0],
];
$stmtCahaya = mysqli_prepare($koneksi, "INSERT INTO jadwal_pencahayaan (jenis, waktu, durasi, hari, catatan, is_active) VALUES (?, ?, ?, ?, ?, ?)");
foreach ($jadwalCahaya as $jc) {
    mysqli_stmt_bind_param($stmtCahaya, "ssdssi", $jc[0], $jc[1], $jc[2], $jc[3], $jc[4], $jc[5]);
    mysqli_stmt_execute($stmtCahaya);
}

// 5. Data Sensor (48 Jam Terakhir, per 15 Menit = 192 baris)
// Menjamin grafik 24 jam di dashboard penuh dan dinamis
mysqli_query($koneksi, "DELETE FROM data_sensor WHERE recorded_at >= DATE_SUB(NOW(), INTERVAL 3 DAY)");

$nowTs = time();
$intervalSec = 15 * 60; // 15 menit
$totalPoints = 192; // 48 jam
$baseStart = $nowTs - ($totalPoints * $intervalSec);

$stmtSensor = mysqli_prepare($koneksi, "INSERT INTO data_sensor (suhu, kelembaban, cahaya, level_air, recorded_at) VALUES (?, ?, ?, ?, ?)");

for ($i = 0; $i <= $totalPoints; $i++) {
    $t = $baseStart + ($i * $intervalSec);
    $jam = (float) date('G', $t) + ((float) date('i', $t) / 60.0);

    // Variasi diurnal realistis:
    // Suhu puncak jam 13:00 (~31 - 32.5 C), terendah jam 04:00 (~26 - 27 C)
    $suhuBase = 26.5 + (5.5 * sin(deg2rad(($jam - 7) / 24 * 360)));
    $suhu = round($suhuBase + (mt_rand(-40, 40) / 100), 2);

    // Kelembaban berkebalikan dari suhu: malam tinggi (70-80%), siang lebih kering (58-68%)
    $lembapBase = 76.0 - (16.0 * sin(deg2rad(($jam - 7) / 24 * 360)));
    $lembap = round($lembapBase + (mt_rand(-80, 80) / 100), 2);

    // Cahaya: siang 6-18 tinggi (500 - 1500 lux), malam 0 - 20 lux
    if ($jam >= 6.0 && $jam <= 18.0) {
        $cahaya = round(max(300.0, 1450.0 * sin(deg2rad(($jam - 6) / 12 * 180))) + mt_rand(-60, 60), 2);
    } else {
        $cahaya = (float) mt_rand(0, 15);
    }

    // Level air: 65 - 90%, berosilasi perlahan
    $air = round(75.0 + (12.0 * sin(deg2rad($i * 4))) + (mt_rand(-30, 30) / 10), 2);
    $air = max(20.0, min(95.0, $air));

    $recordedAt = date('Y-m-d H:i:s', $t);

    mysqli_stmt_bind_param($stmtSensor, "dddds", $suhu, $lembap, $cahaya, $air, $recordedAt);
    mysqli_stmt_execute($stmtSensor);
}

// Update file data_sensor_live.json agar sinkron
$latestSensorQ = mysqli_query($koneksi, "SELECT * FROM data_sensor ORDER BY id DESC LIMIT 1");
if ($latest = mysqli_fetch_assoc($latestSensorQ)) {
    $livePayload = [
        'suhu' => (float) $latest['suhu'],
        'kelembaban' => (float) $latest['kelembaban'],
        'cahaya' => (float) $latest['cahaya'],
        'level_air' => (float) $latest['level_air'],
        'kipas' => 1,
        'lampu' => 1,
        'updated_at' => $latest['recorded_at'],
    ];
    @file_put_contents(__DIR__ . '/../data_sensor_live.json', json_encode($livePayload, JSON_PRETTY_PRINT));
}

// 6. Log Harian (14 Hari Terakhir, 3-4 log per hari)
mysqli_query($koneksi, "TRUNCATE TABLE log_harian");
$stmtLogHarian = mysqli_prepare($koneksi, "INSERT INTO log_harian (waktu, suhu, kelembaban, cahaya, level_air, pakan, minum, lampu, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

$jamLog = ['06:00:00', '12:00:00', '17:00:00', '21:00:00'];
for ($d = 13; $d >= 0; $d--) {
    $tglStr = date('Y-m-d', strtotime("-$d days"));
    foreach ($jamLog as $waktuStr) {
        $jamInt = (int) substr($waktuStr, 0, 2);

        if ($jamInt === 6) {
            $suhu = round(26.2 + (mt_rand(-3, 8) / 10), 2);
            $lembap = round(74.0 + (mt_rand(-20, 20) / 10), 2);
            $cahaya = 350.0 + mt_rand(20, 80);
            $air = 88.0 + mt_rand(-2, 4);
            $pakan = 3.50;
            $minum = 8.20;
            $lampu = 'Hidup';
        } elseif ($jamInt === 12) {
            $suhu = round(31.8 + (mt_rand(-5, 9) / 10), 2);
            $lembap = round(61.5 + (mt_rand(-30, 20) / 10), 2);
            $cahaya = 1380.0 + mt_rand(-100, 150);
            $air = 76.0 + mt_rand(-4, 3);
            $pakan = 2.50;
            $minum = 12.50;
            $lampu = 'Hidup';
        } elseif ($jamInt === 17) {
            $suhu = round(29.4 + (mt_rand(-4, 6) / 10), 2);
            $lembap = round(67.0 + (mt_rand(-20, 20) / 10), 2);
            $cahaya = 720.0 + mt_rand(-50, 60);
            $air = 82.0 + mt_rand(-3, 5);
            $pakan = 4.00;
            $minum = 9.80;
            $lampu = 'Hidup';
        } else {
            $suhu = round(27.0 + (mt_rand(-5, 5) / 10), 2);
            $lembap = round(72.5 + (mt_rand(-20, 20) / 10), 2);
            $cahaya = (float) mt_rand(0, 10);
            $air = 80.0 + mt_rand(-4, 4);
            $pakan = 0.00;
            $minum = 5.10;
            $lampu = 'Mati';
        }

        $createdAt = "$tglStr $waktuStr";
        mysqli_stmt_bind_param($stmtLogHarian, "sddddddss", $waktuStr, $suhu, $lembap, $cahaya, $air, $pakan, $minum, $lampu, $createdAt);
        mysqli_stmt_execute($stmtLogHarian);
    }
}

// 7. Log Pemberian Pakan (7 Hari Terakhir)
mysqli_query($koneksi, "TRUNCATE TABLE log_pemberian_pakan");
$stmtLogPakan = mysqli_prepare($koneksi, "INSERT INTO log_pemberian_pakan (jadwal_id, user_id, waktu, metode, status, keterangan, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)");

$pakanPagiId = $jadwalIds[0] ?? null;
$pakanSiangId = $jadwalIds[1] ?? null;
$pakanSoreId = $jadwalIds[2] ?? null;

for ($d = 6; $d >= 0; $d--) {
    $tglStr = date('Y-m-d', strtotime("-$d days"));

    // Pagi (Otomatis)
    $w1 = "$tglStr 06:30:12";
    $metode1 = 'Otomatis';
    $status1 = 'Berhasil';
    $ket1 = 'Pemberian pakan pagi 3.5 kg selesai';
    mysqli_stmt_bind_param($stmtLogPakan, "iisssss", $pakanPagiId, $adminId, $w1, $metode1, $status1, $ket1, $w1);
    mysqli_stmt_execute($stmtLogPakan);

    // Siang (Otomatis)
    $w2 = "$tglStr 12:00:08";
    $metode2 = 'Otomatis';
    $status2 = 'Berhasil';
    $ket2 = 'Pemberian pakan siang 2.5 kg selesai';
    mysqli_stmt_bind_param($stmtLogPakan, "iisssss", $pakanSiangId, $adminId, $w2, $metode2, $status2, $ket2, $w2);
    mysqli_stmt_execute($stmtLogPakan);

    // Sore (Otomatis)
    $w3 = "$tglStr 17:00:15";
    $metode3 = 'Otomatis';
    $status3 = 'Berhasil';
    $ket3 = 'Pemberian pakan sore 4.0 kg selesai';
    mysqli_stmt_bind_param($stmtLogPakan, "iisssss", $pakanSoreId, $adminId, $w3, $metode3, $status3, $ket3, $w3);
    mysqli_stmt_execute($stmtLogPakan);

    // Kadang ada pakan manual tambahan
    if ($d === 1 || $d === 3) {
        $w4 = "$tglStr 15:20:00";
        $metode4 = 'Manual';
        $status4 = 'Berhasil';
        $ket4 = 'Pemberian vitamin & pakan manual via dispenser';
        $nullJadwal = null;
        mysqli_stmt_bind_param($stmtLogPakan, "iisssss", $nullJadwal, $adminId, $w4, $metode4, $status4, $ket4, $w4);
        mysqli_stmt_execute($stmtLogPakan);
    }
}

// 8. Notifikasi
mysqli_query($koneksi, "TRUNCATE TABLE notifikasi");
$stmtNotif = mysqli_prepare($koneksi, "INSERT INTO notifikasi (user_id, pesan, tipe, waktu_label, is_read, created_at) VALUES (?, ?, ?, ?, ?, ?)");

$notifList = [
    ['Suhu kandang optimal 28.5°C', 'success', date('H:i - d M Y', strtotime('-25 minutes')), 0, date('Y-m-d H:i:s', strtotime('-25 minutes'))],
    ['Pakan sore 4.0 kg berhasil dikeluarkan sesuai jadwal', 'success', date('H:i - d M Y', strtotime('-3 hours')), 0, date('Y-m-d H:i:s', strtotime('-3 hours'))],
    ['Level air minum mencapai 70% (kondisi aman)', 'info', date('H:i - d M Y', strtotime('-5 hours')), 1, date('Y-m-d H:i:s', strtotime('-5 hours'))],
    ['Kipas ventilasi menyala otomatis karena suhu > 31.0°C', 'info', date('H:i - d M Y', strtotime('-7 hours')), 1, date('Y-m-d H:i:s', strtotime('-7 hours'))],
    ['Pakan siang 2.5 kg berhasil dikeluarkan', 'success', date('H:i - d M Y', strtotime('-9 hours')), 1, date('Y-m-d H:i:s', strtotime('-9 hours'))],
    ['Lampu utama aktif sesuai jadwal pencahayaan', 'info', date('H:i - d M Y', strtotime('-12 hours')), 1, date('Y-m-d H:i:s', strtotime('-12 hours'))],
    ['Pakan pagi 3.5 kg berhasil didistribusikan', 'success', date('H:i - d M Y', strtotime('-15 hours')), 1, date('Y-m-d H:i:s', strtotime('-15 hours'))],
    ['Level air sempat mendekati batas minimal (52%)', 'warning', date('H:i - d M Y', strtotime('-1 day')), 1, date('Y-m-d H:i:s', strtotime('-1 day'))],
    ['Sistem sensor ESP32 terhubung dan sinkronisasi MQTT normal', 'success', date('H:i - d M Y', strtotime('-1 day -2 hours')), 1, date('Y-m-d H:i:s', strtotime('-1 day -2 hours'))],
    ['Pengaturan kandang diperbarui oleh administrator', 'info', date('H:i - d M Y', strtotime('-2 days')), 1, date('Y-m-d H:i:s', strtotime('-2 days'))],
];

foreach ($notifList as $nt) {
    mysqli_stmt_bind_param($stmtNotif, "isssis", $adminId, $nt[0], $nt[1], $nt[2], $nt[3], $nt[4]);
    mysqli_stmt_execute($stmtNotif);
}

mysqli_query($koneksi, "SET FOREIGN_KEY_CHECKS = 1;");

echo "SUCCESS: Seeder data dummy berhasil dijalankan.\n";
