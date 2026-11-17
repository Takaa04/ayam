<?php
/**
 * System Check Suite for ChickGuard
 */
error_reporting(E_ALL);

require_once __DIR__ . '/../config/koneksi.php';
require_once __DIR__ . '/../proses/init_tables.php';
require_once __DIR__ . '/../proses/helpers.php';

// 1. DB connection & schema
chickguard_init_tables($koneksi);
echo "[OK] Tables and relations initialized\n";

// 2. Relations check
$res = mysqli_query($koneksi, "
    SELECT CONSTRAINT_NAME 
    FROM information_schema.KEY_COLUMN_USAGE 
    WHERE TABLE_SCHEMA = 'chickguard' AND REFERENCED_TABLE_NAME IS NOT NULL
");
$names = [];
while ($r = mysqli_fetch_assoc($res)) {
    $names[] = $r['CONSTRAINT_NAME'];
}
$req = ['fk_password_resets_user', 'fk_log_pakan_jadwal', 'fk_log_pakan_user', 'fk_notifikasi_user'];
foreach ($req as $fk) {
    assert(in_array($fk, $names, true), "FK $fk missing");
}
echo "[OK] Foreign keys verified\n";

// 3. Render critical pages without crashes
$_SESSION = ['login' => true, 'user_id' => 1, 'username' => 'admin', 'role' => 'admin'];
$pages = [
    'pages/dashboard.php',
    'pages/aktuator.php',
    'pages/pakan.php',
    'pages/pencahayaan.php',
    'pages/log_harian.php',
    'pages/pengaturan.php',
    'login.php',
    'reset_password.php',
];

$root = dirname(__DIR__);
foreach ($pages as $p) {
    chdir($root . '/' . dirname($p));
    ob_start();
    include $root . '/' . $p;
    $out = ob_get_clean();
    assert(strlen($out) > 50, "Failed to render $p");
    echo "[OK] Render $p (" . strlen($out) . " bytes)\n";
}
chdir($root);

// 4. Test CRUD & Cascade logic
$stmt = mysqli_prepare($koneksi, "INSERT INTO jadwal_pakan (waktu, jumlah, hari, catatan, is_active) VALUES ('04:30:00', 2.0, 'Semua Hari', 'Test System Check', 1)");
mysqli_stmt_execute($stmt);
$jid = mysqli_insert_id($koneksi);

$stmtL = mysqli_prepare($koneksi, "INSERT INTO log_pemberian_pakan (jadwal_id, user_id, waktu, metode, status, keterangan) VALUES (?, 1, NOW(), 'Otomatis', 'Berhasil', 'Test log')");
mysqli_stmt_bind_param($stmtL, "i", $jid);
mysqli_stmt_execute($stmtL);
$lid = mysqli_insert_id($koneksi);

// Delete parent schedule -> child should retain record with NULL foreign key
mysqli_query($koneksi, "DELETE FROM jadwal_pakan WHERE id = $jid");
$chk = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT jadwal_id, user_id FROM log_pemberian_pakan WHERE id = $lid"));
assert($chk['jadwal_id'] === null, "Jadwal id should be null after parent delete");
assert((int)$chk['user_id'] === 1, "User id should remain intact");
mysqli_query($koneksi, "DELETE FROM log_pemberian_pakan WHERE id = $lid");
echo "[OK] Cascade & FK behavior verified\n";

// 5. Test Jadwal Pencahayaan table
$chkLight = mysqli_query($koneksi, "SELECT COUNT(*) AS total FROM jadwal_pencahayaan");
assert($chkLight !== false, "Table jadwal_pencahayaan not accessible");
echo "[OK] Jadwal pencahayaan table verified\n";

echo "ChickGuard System Check: ALL TESTS PASSED.\n";
