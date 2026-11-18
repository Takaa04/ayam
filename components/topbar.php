<?php
$username = $_SESSION['username'] ?? 'admin';
if (isset($koneksi) && $koneksi instanceof mysqli) {
    $uStmt = mysqli_prepare($koneksi, "SELECT username, role FROM users WHERE username = ? LIMIT 1");
    if ($uStmt) {
        mysqli_stmt_bind_param($uStmt, "s", $username);
        mysqli_stmt_execute($uStmt);
        $uRes = mysqli_stmt_get_result($uStmt);
        if ($uRow = mysqli_fetch_assoc($uRes)) {
            if (!empty($uRow['username'])) {
                $username = $uRow['username'];
                $_SESSION['username'] = $username;
            }
            if (!empty($uRow['role'])) {
                $_SESSION['role'] = $uRow['role'];
            }
        }
    }
}
$userRole = ucfirst($_SESSION['role'] ?? 'Admin');

// Query notifikasi hingga 30 data agar riwayat di dropdown scrollable lengkap
if (!isset($notifs) || !is_array($notifs)) {
    $notifs = [];
    if (isset($koneksi) && $koneksi instanceof mysqli) {
        $notifQuery = mysqli_query($koneksi, "SELECT * FROM notifikasi ORDER BY id DESC LIMIT 30");
        if ($notifQuery) {
            while ($row = mysqli_fetch_assoc($notifQuery)) {
                $notifs[] = $row;
            }
        }
    }
    if (empty($notifs)) {
        $notifs = [
            ['id' => 1, 'pesan' => 'Pakan diberikan otomatis', 'tipe' => 'success', 'waktu_label' => '16:00 - 10 Okt 2026', 'is_read' => 0],
            ['id' => 2, 'pesan' => 'Level air mulai rendah (72%)', 'tipe' => 'warning', 'waktu_label' => '14:32 - 10 Okt 2026', 'is_read' => 0],
            ['id' => 3, 'pesan' => 'Suhu kembali normal', 'tipe' => 'success', 'waktu_label' => '12:15 - 10 Okt 2026', 'is_read' => 1],
            ['id' => 4, 'pesan' => 'ESP32 terhubung', 'tipe' => 'success', 'waktu_label' => '08:07 - 10 Okt 2026', 'is_read' => 1],
        ];
    }
}

if (!isset($unreadCount)) {
    if (isset($koneksi) && $koneksi instanceof mysqli) {
        $unreadQuery = mysqli_query($koneksi, "SELECT COUNT(*) AS unread FROM notifikasi WHERE is_read = 0");
        $unreadRow = $unreadQuery ? mysqli_fetch_assoc($unreadQuery) : null;
        $unreadCount = (int) ($unreadRow['unread'] ?? 0);
    } else {
        $unreadCount = 0;
        foreach ($notifs as $n) {
            if (empty($n['is_read'])) $unreadCount++;
        }
    }
}
$unreadCount = (int) $unreadCount;

$topbarTitle    = $topbarTitle    ?? ('Selamat Datang, ' . $username . '!');
$topbarSubtitle = $topbarSubtitle ?? 'Pantau kondisi kandang ayam Anda secara real-time melalui dashboard IoT.';
?>
<header class="topbar-modern topbar">
  <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">

    <!-- Left: Greeting -->
    <div class="topbar-greeting">
      <h1 class="topbar-title"><?= htmlspecialchars($topbarTitle, ENT_QUOTES, 'UTF-8') ?></h1>
      <p class="topbar-subtitle"><?= htmlspecialchars($topbarSubtitle, ENT_QUOTES, 'UTF-8') ?></p>
    </div>

    <!-- Right: Widgets + Actions -->
    <div class="topbar-right-cluster d-flex align-items-center gap-2 gap-md-3 ms-lg-auto">

      <!-- Date & Clock -->
      <div class="topbar-widget-card d-flex align-items-center gap-2">
        <div class="widget-icon text-muted">
          <i class="bi bi-calendar3"></i>
        </div>
        <div class="widget-meta">
          <div class="widget-primary" id="topbarDate">17 November 2026</div>
          <div class="widget-secondary" id="topbarClock">16:45:00</div>
        </div>
      </div>

      <!-- Weather -->
      <div class="topbar-widget-card d-flex align-items-center gap-2">
        <div class="widget-icon weather-cloud" id="weatherIcon">
          <i class="bi bi-cloud"></i>
        </div>
        <div class="widget-meta">
          <div class="widget-primary" id="weatherLabel">Berawan</div>
          <div class="widget-secondary" id="weatherTemp">28&deg;C</div>
        </div>
      </div>

      <!-- Notification Bell -->
      <div class="topbar-notif-wrapper">
        <button
          type="button"
          class="topbar-action-btn js-toggle-notifications"
          id="topbarNotifBtn"
          title="Notifikasi"
          aria-label="Notifikasi"
          aria-expanded="false"
        >
          <i class="bi bi-bell"></i>
          <span class="notif-badge" id="topbarNotifDot" <?= $unreadCount > 0 ? '' : 'style="display:none;"' ?>>
            <?= $unreadCount > 99 ? '99+' : $unreadCount ?>
          </span>
        </button>
      </div>

      <!-- User Profile -->
      <div class="user-profile-badge d-flex align-items-center gap-2">
        <div class="user-avatar-circle">
          <i class="bi bi-person-fill"></i>
        </div>
        <div class="user-details">
          <div class="user-name"><?= htmlspecialchars($username, ENT_QUOTES, 'UTF-8') ?></div>
        </div>
      </div>

    </div>
  </div>
</header>

<!-- ================================================================
     Popover Notifikasi — di luar header, di-append ke body via JS
     ================================================================ -->
<div class="notif-popover" id="notifDropdown" style="display:none;" role="dialog" aria-label="Panel Notifikasi">

  <!-- Header -->
  <div class="notif-popover-header">
    <div class="notif-header-left">
      <i class="bi bi-bell-fill" style="color:#f59e0b; font-size:0.95rem;"></i>
      <span class="notif-header-title">Notifikasi</span>
      <span class="notif-count-badge" id="notifUnreadBadge"><?= $unreadCount ?> Baru</span>
    </div>
    <button type="button" class="btn-mark-all" id="btnMarkAllRead">
      <i class="bi bi-check2-all"></i> Tandai Dibaca
    </button>
  </div>

  <!-- Body Scrollable -->
  <div class="notif-popover-body" id="modalNotifList">
    <?php if (empty($notifs)): ?>
      <div class="notif-empty-state">
        <i class="bi bi-bell-slash"></i>
        <span>Belum ada notifikasi</span>
      </div>
    <?php else: ?>
      <?php foreach ($notifs as $nt): ?>
        <?php
          $dotColor   = ($nt['tipe'] ?? '') === 'warning' ? 'bg-warning'
                      : (($nt['tipe'] ?? '') === 'danger'  ? 'bg-danger' : 'bg-success');
          $isUnread   = empty($nt['is_read']);
        ?>
        <div
          class="notif-popover-item <?= $isUnread ? 'unread' : '' ?>"
          data-id="<?= (int)($nt['id'] ?? 0) ?>"
        >
          <span class="notif-dot <?= $dotColor ?> <?= $isUnread ? '' : 'bg-opacity-50' ?>"></span>
          <div class="notif-item-body">
            <div class="notif-item-title <?= $isUnread ? 'fw-semibold text-dark' : 'fw-normal text-secondary' ?>">
              <?= htmlspecialchars($nt['pesan'] ?? '', ENT_QUOTES, 'UTF-8') ?>
            </div>
            <div class="notif-item-time">
              <?= htmlspecialchars($nt['waktu_label'] ?? '', ENT_QUOTES, 'UTF-8') ?>
            </div>
          </div>
          <?php if ($isUnread): ?>
            <span class="notif-new-badge">Baru</span>
          <?php endif; ?>
        </div>
      <?php endforeach; ?>
    <?php endif; ?>
  </div>

  <!-- Footer -->
  <div class="notif-popover-footer">
    <button type="button" class="btn-close-notif" id="btnCloseNotifDropdown">
      <i class="bi bi-x-lg me-1"></i>Tutup
    </button>
  </div>
</div>

<!-- Floating Toast Container -->
<div class="notif-toast-container" id="notifToastContainer"></div>

<script>
  (() => {
    /* ---- Clock ---- */
    function updateClock() {
      const now    = new Date();
      const months = ['Januari','Februari','Maret','April','Mei','Juni',
                      'Juli','Agustus','September','Oktober','November','Desember'];
      const hh = String(now.getHours()).padStart(2,'0');
      const mm = String(now.getMinutes()).padStart(2,'0');
      const ss = String(now.getSeconds()).padStart(2,'0');
      const dateEl = document.getElementById('topbarDate');
      const clockEl = document.getElementById('topbarClock');
      const cctvEl  = document.getElementById('cctvLiveTime');
      if (dateEl)  dateEl.textContent  = `${now.getDate()} ${months[now.getMonth()]} ${now.getFullYear()}`;
      if (clockEl) clockEl.textContent = `${hh}:${mm}:${ss}`;
      if (cctvEl)  cctvEl.textContent  = `${hh}:${mm}:${ss}`;
    }
    updateClock();
    setInterval(updateClock, 1000);

    /* ---- Popover Notifikasi ---- */
    function initNotifications() {
      const dropdown = document.getElementById('notifDropdown');
      const notifBtn = document.getElementById('topbarNotifBtn');

      if (!dropdown || !notifBtn) return;

      /* Pindahkan popover ke <body> agar tidak dipotong parent sticky */
      if (dropdown.parentElement !== document.body) {
        document.body.appendChild(dropdown);
      }

      /* Hitung posisi tombol bel dan tempatkan dropdown persis di bawahnya */
      function repositionPopover() {
        const rect   = notifBtn.getBoundingClientRect();
        const margin = 10; // jarak dari tombol ke popover (px)

        dropdown.style.top  = (rect.bottom + margin) + 'px';

        /* Pastikan popover tidak keluar layar sebelah kanan */
        const popW  = 360;
        const spaceRight = window.innerWidth - rect.right;
        if (spaceRight >= popW) {
          dropdown.style.left  = rect.left + 'px';
          dropdown.style.right = 'auto';
        } else {
          dropdown.style.right = (window.innerWidth - rect.right) + 'px';
          dropdown.style.left  = 'auto';
        }
      }

      function openDropdown() {
        repositionPopover();
        dropdown.style.display = 'flex';
        notifBtn.setAttribute('aria-expanded', 'true');
      }

      function closeDropdown() {
        dropdown.style.display = 'none';
        notifBtn.setAttribute('aria-expanded', 'false');
      }

      function isOpen() {
        return dropdown.style.display !== 'none';
      }

      /* Toggle saat klik tombol bel */
      document.querySelectorAll('.js-toggle-notifications').forEach(btn => {
        if (btn.dataset.topbarBound) return;
        btn.dataset.topbarBound = '1';
        btn.addEventListener('click', (e) => {
          e.preventDefault();
          e.stopPropagation();
          isOpen() ? closeDropdown() : openDropdown();
        });
      });

      /* Tombol Tutup di dalam popover */
      const closeBtn = document.getElementById('btnCloseNotifDropdown');
      if (closeBtn && !closeBtn.dataset.bound) {
        closeBtn.dataset.bound = '1';
        closeBtn.addEventListener('click', closeDropdown);
      }

      /* Click outside → tutup */
      document.addEventListener('click', (e) => {
        if (!isOpen()) return;
        if (!dropdown.contains(e.target) && !e.target.closest('.js-toggle-notifications')) {
          closeDropdown();
        }
      });

      /* Escape → tutup */
      document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && isOpen()) closeDropdown();
      });

      /* Scroll/resize → reposisi jika sedang terbuka */
      window.addEventListener('resize', () => { if (isOpen()) repositionPopover(); }, { passive: true });
      document.addEventListener('scroll', () => { if (isOpen()) repositionPopover(); }, { passive: true, capture: true });

      /* Cegah klik dalam popover menutup sendiri */
      dropdown.addEventListener('click', (e) => e.stopPropagation());

      /* ---- Tandai Semua Dibaca ---- */
      const btnMarkAll = document.getElementById('btnMarkAllRead');
      if (btnMarkAll && !btnMarkAll.dataset.bound) {
        btnMarkAll.dataset.bound = '1';
        btnMarkAll.addEventListener('click', async () => {
          try {
            const res  = await fetch('../proses/notifikasi_tandai.php', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ semua: true })
            });
            const data = await res.json();
            if (data?.success) {
              /* Update badge */
              const dot = document.getElementById('topbarNotifDot');
              if (dot) dot.style.display = 'none';
              const badge = document.getElementById('notifUnreadBadge');
              if (badge) badge.textContent = '0 Baru';

              /* Update tampilan item */
              document.querySelectorAll('#modalNotifList .notif-popover-item.unread').forEach(item => {
                item.classList.remove('unread');
                const title = item.querySelector('.notif-item-title');
                if (title) title.className = 'notif-item-title fw-normal text-secondary';
                const dot  = item.querySelector('.notif-dot');
                if (dot) dot.classList.add('bg-opacity-50');
                const newBadge = item.querySelector('.notif-new-badge');
                if (newBadge) newBadge.remove();
              });
              document.querySelectorAll('#notifListContainer .notif-title').forEach(t => {
                t.style.fontWeight = '500';
                t.style.color = '#64748b';
              });

              if (typeof setUnread === 'function') setUnread(0);
              if (typeof showToast === 'function') showToast('Semua notifikasi ditandai dibaca.', 'success');
            }
          } catch (err) {
            console.error('Gagal menandai notifikasi:', err);
          }
        });
      }

      /* ---- Klik per item (tandai satu) ---- */
      const listEl = document.getElementById('modalNotifList');
      if (listEl && !listEl.dataset.bound) {
        listEl.dataset.bound = '1';
        listEl.addEventListener('click', async (e) => {
          const item = e.target.closest('.notif-popover-item.unread');
          if (!item) return;
          const id = Number(item.getAttribute('data-id'));
          if (!id) return;
          try {
            const res  = await fetch('../proses/notifikasi_tandai.php', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ id })
            });
            const data = await res.json();
            if (data?.success) {
              item.classList.remove('unread');
              const badge    = item.querySelector('.notif-new-badge');
              if (badge)  badge.remove();
              const dot      = item.querySelector('.notif-dot');
              if (dot)    dot.classList.add('bg-opacity-50');
              const title    = item.querySelector('.notif-item-title');
              if (title)  title.className = 'notif-item-title fw-normal text-secondary';

              if (typeof setUnread === 'function') {
                setUnread(data.unread_count ?? 0);
              } else {
                const badgeEl = document.getElementById('topbarNotifDot');
                const count   = data.unread_count ?? 0;
                if (badgeEl) {
                  badgeEl.style.display = count > 0 ? 'inline-flex' : 'none';
                  badgeEl.textContent   = count > 99 ? '99+' : count;
                }
                const countBadge = document.getElementById('notifUnreadBadge');
                if (countBadge) countBadge.textContent = `${count} Baru`;
              }
            }
          } catch (err) {
            console.error('Gagal menandai notifikasi:', err);
          }
        });
      }
    }

    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', initNotifications);
    } else {
      initNotifications();
    }
  })();
</script>
