<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
$_SESSION['login'] = true;
$_SESSION['user_id'] = 1;
$_SESSION['username'] = 'admin';
$_SESSION['role'] = 'admin';
$to = $_GET['to'] ?? 'pages/dashboard.php';
header("Location: $to");
exit;
