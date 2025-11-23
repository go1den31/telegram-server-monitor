# 📡 Telegram Server Monitor (Bash + systemd)

This repository contains a lightweight Bash-based monitoring script that sends server health reports and service status notifications directly to Telegram.

The system consists of:
- `monitor.sh` – main monitoring script  
- `security-monitor.service` – systemd service  
- `security-monitor.timer` – scheduler (runs every minute)  

Designed for my homelab server running Debian.

---

## 🔧 Features

- Checks if services are UP or DOWN  
- Detects failures (Nextcloud, Immich, Nginx, etc.)  
- Sends alerts to Telegram  
- Sends a full daily health report at **07:00**  
- Logs service state to avoid spam  
- Lightweight and runs via systemd timers  

---

## 🚀 Installation

### 1️⃣ Clone the repository
```bash
git clone https://github.com/go1den31/telegram-server-monitor
cd telegram-server-monitor
```

---

### 2️⃣ Make script executable
```bash
chmod +x monitor.sh
```

---

### 3️⃣ Install systemd files
Copy both service and timer:

```bash
sudo cp security-monitor.service /etc/systemd/system/
sudo cp security-monitor.timer   /etc/systemd/system/
```

Reload systemd:

```bash
sudo systemctl daemon-reload
```

Enable the timer:

```bash
sudo systemctl enable --now security-monitor.timer
```

Check status:

```bash
systemctl status security-monitor.timer
```

---

## 🧪 Test manual run
```bash
./monitor.sh
```

---

## 📬 Notes

This is part of my homelab environment and integrated with Cloudflare + Nginx reverse proxy.  
Works perfectly for monitoring self-hosted services.

