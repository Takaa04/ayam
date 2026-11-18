<?php
/**
 * helpers.php
 * Kumpulan fungsi bersama yang dipakai halaman dashboard dan endpoint AJAX.
 */

/**
 * Format waktu notifikasi gaya Indonesia: "14:32 - 10 Okt 2026".
 */
function waktu_notifikasi(?int $timestamp = null): string
{
    $bulan = [
        1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr', 5 => 'Mei', 6 => 'Jun',
        7 => 'Jul', 8 => 'Agu', 9 => 'Sep', 10 => 'Okt', 11 => 'Nov', 12 => 'Des',
    ];

    $ts = $timestamp ?? time();

    return date('H:i', $ts) . ' - ' . date('j', $ts) . ' ' . $bulan[(int) date('n', $ts)] . ' ' . date('Y', $ts);
}

/**
 * Status satu metrik terhadap batas bawah / atas.
 * $label field: ['bawah' => 'Dingin', 'atas' => 'Panas']
 */
function cg_status_metrik(float $nilai, $batasBawah, $batasAtas, array $label, string $labelNormal = 'Normal'): array
{
    $batasBawah = (float) $batasBawah;
    $batasAtas = (float) $batasAtas;

    if ($nilai < $batasBawah) {
        return ['label' => $label['bawah'], 'class' => 'status-warning'];
    }

    if ($nilai > $batasAtas) {
        return ['label' => $label['atas'], 'class' => 'status-danger'];
    }

    return ['label' => $labelNormal, 'class' => 'status-normal'];
}

/**
 * Hitung kondisi kandang (pesan + kelas warna) dan tips dinamis
 * berdasarkan pembacaan sensor terakhir dan batas dari pengaturan_kandang.
 */
function cg_status_kandang(array $sensor, array $settings): array
{
    $suhu = (float) ($sensor['suhu'] ?? 32.4);
    $lembap = (float) ($sensor['kelembaban'] ?? 68.2);
    $cahaya = (float) ($sensor['cahaya'] ?? 1240);
    $air = (float) ($sensor['level_air'] ?? 72);

    $suhuMin = (float) ($settings['suhu_min'] ?? 24.0);
    $suhuMaks = (float) ($settings['suhu_maks'] ?? 34.0);
    $lembapMin = (float) ($settings['kelembaban_min'] ?? 55.0);
    $lembapMaks = (float) ($settings['kelembaban_maks'] ?? 75.0);
    $cahayaMin = (float) ($settings['cahaya_min'] ?? 500.0);
    $cahayaMaks = (float) ($settings['cahaya_maks'] ?? 2000.0);
    $airMin = (float) ($settings['level_air_min'] ?? 50.0);
    $airMaks = (float) ($settings['level_air_maks'] ?? 95.0);

    $masalah = [];

    if ($suhu > $suhuMaks) {
        $masalah[] = 'Suhu melebihi batas atas (' . number_format($suhu, 1, '.', ',') . '&deg;C)';
    } elseif ($suhu < $suhuMin) {
        $masalah[] = 'Suhu di bawah batas normal (' . number_format($suhu, 1, '.', ',') . '&deg;C)';
    }

    if ($lembap > $lembapMaks) {
        $masalah[] = 'Kelembaban melebihi batas atas (' . number_format($lembap, 1, '.', ',') . '%)';
    } elseif ($lembap < $lembapMin) {
        $masalah[] = 'Kelembaban di bawah batas normal (' . number_format($lembap, 1, '.', ',') . '%)';
    }

    if ($cahaya > $cahayaMaks) {
        $masalah[] = 'Pencahayaan berlebih/silau (' . number_format($cahaya, 0, '.', ',') . ' lux)';
    } elseif ($cahaya < $cahayaMin) {
        $masalah[] = 'Pencahayaan kurang (' . number_format($cahaya, 0, '.', ',') . ' lux)';
    }

    if ($air > $airMaks) {
        $masalah[] = 'Level air tangki meluap (' . number_format($air, 0, '.', ',') . '%)';
    } elseif ($air < $airMin) {
        $masalah[] = 'Level air rendah (' . number_format($air, 0, '.', ',') . '%)';
    }

    if (empty($masalah)) {
        $kondisi = [
            'class' => 'success',
            'text' => 'Kondisi lingkungan dalam batas normal.',
        ];
    } else {
        $kondisi = [
            'class' => count($masalah) > 1 ? 'danger' : 'warning',
            'text' => implode(' &bull; ', $masalah),
        ];
    }

    // Tips dinamis berdasarkan masalah terbesar
    $tips = 'Pastikan ketersediaan pakan dan air selalu cukup, terutama saat cuaca panas.';

    if ($suhu > $suhuMaks) {
        $tips = 'Suhu tinggi terdeteksi. Aktifkan kipas atau tingkatkan ventilation agar ayam tidak stress.';
    } elseif ($suhu < $suhuMin) {
        $tips = 'Suhu rendah terdeteksi. Aktifkan heater atau lampu pemanas untuk menjaga suhu kandang.';
    } elseif ($air < $airMin) {
        $tips = 'Level air rendah. Segera lakukan pengisian minum agar ayam tetap terhidrasi.';
    } elseif ($air > $airMaks) {
        $tips = 'Level air melebihi batas aman (potensi meluap). Segera periksa pelampung atau matikan pompa pengisi air.';
    } elseif ($lembap > $lembapMaks) {
        $tips = 'Kelembaban tinggi. Perbanyak sirkulasi udara agar lantai kandang tidak lembap.';
    } elseif ($lembap < $lembapMin) {
        $tips = 'Kelembaban rendah. Tambahkan air minum atau semprotkan air halus untuk menstabilkan.';
    } elseif ($cahaya < $cahayaMin) {
        $tips = 'Cahaya kurang. Nyalakan lampu kandang agar ayam tetap aktif makan.';
    } elseif ($cahaya > $cahayaMaks) {
        $tips = 'Cahaya terlalu terik. Tutup tirai atau redupkan lampu kandang untuk mencegah stres/kanibalisme pada ayam.';
    }

    return [
        'kondisi' => $kondisi,
        'tips' => $tips,
    ];
}

if (!function_exists('e')) {
    function e($value): string
    {
        return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
    }
}

if (!function_exists('checkbox_id')) {
    function checkbox_id($prefix, $value): string
    {
        $normalized = strtolower(trim((string) $value));
        $normalized = preg_replace('/[^a-z0-9]+/', '_', $normalized);
        return $prefix . '_' . trim($normalized, '_');
    }
}

if (!function_exists('cg_model')) {
    /**
     * Model lingkungan harian (meniru pola: dingin malam, panas siang).
     * Menghasilkan [suhu, kelembaban, cahaya, level_air]
     */
    function cg_model(float $t): array
    {
        $anchorAir = [0 => 92.0, 5 => 80.0, 6 => 85.0, 12 => 75.0, 16 => 78.0, 20 => 74.0, 22 => 71.0, 24 => 70.0];
        $air = 82.0;
        $prevH = 0;
        foreach ($anchorAir as $h => $v) {
            if ($t <= $h) {
                $span = max(1, $h - $prevH);
                $air = $anchorAir[$prevH] + (($v - $anchorAir[$prevH]) / $span) * ($t - $prevH);
                break;
            }
            $prevH = $h;
        }

        $suhu = 24.8 + 8.0 * exp(-pow($t - 13.5, 2) / 22);
        $suhu = max(24.0, min(34.5, $suhu + (mt_rand(-10, 10) / 20)));
        $lembab = max(50.0, min(85.0, 80 - ($suhu - 24.8) * 1.6) + (mt_rand(-8, 8) / 10));

        if ($t < 4.8 || $t > 20.2) {
            $cahaya = mt_rand(0, 12);
        } else {
            $cahaya = 120 + 1720 * exp(-pow($t - 12.5, 2) / 14) + mt_rand(-30, 30);
            $cahaya = max(10, min(2000, $cahaya));
        }

        return [
            round($suhu, 2),
            round($lembab, 2),
            round($cahaya, 2),
            round(max(0, min(100, $air)), 2),
        ];
    }
}
