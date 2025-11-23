#!/bin/bash

BOT_TOKEN="YOUR_TELEGRAM_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"

send_msg() {
  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="$1" >/dev/null
}

check() {
  NAME=$1
  URL=$2

  STATUS=$(curl -4 -Is --max-time 5 "$URL" | head -n 1 | grep 200)

  if [ -z "$STATUS" ]; then
    if [ ! -f "/tmp/${NAME}_down" ]; then
      send_msg "❌ $NAME is DOWN ($URL)"
      touch "/tmp/${NAME}_down"
    fi
  else
    if [ -f "/tmp/${NAME}_down" ]; then
      send_msg "🟢 $NAME is back ONLINE"
      rm "/tmp/${NAME}_down"
    fi
  fi
}

# Checks
check "Nextcloud" "https://golden-hub.org"
check "Immich" "https://photos.golden-hub.org"

# Daily report at 07:00
HOUR=$(date +%H)
if [ "$HOUR" = "07" ]; then
  UPTIME=$(uptime -p)
  CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d"." -f1)
  RAM=$(free | awk '/Mem/ {printf("%d"), $3/$2 * 100}')
  DISK=$(df -h / | awk 'NR==2 {print $5}')

  send_msg "📊 DAILY SERVER REPORT\n🔧 Uptime: $UPTIME\nCPU: $CPU%\nRAM: $RAM%\nDisk: $DISK"
fi
