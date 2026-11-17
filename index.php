<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (isset($_SESSION['login'])) {
    header("Location: pages/dashboard.php");
} else {
    header("Location: login.php");
}
exit;