#!/data/data/com.termux/files/usr/bin/bash
set -u

DIR="$HOME/droid-interval-timer"
LOG="$DIR/timer.log"
cd "$DIR"

while true; do
  echo "[$(date '+%F %T')] [Watcher] Starting timer.sh..." >> "$LOG"
  bash "$DIR/timer.sh" >> "$LOG" 2>&1
  code=$?
  echo "[$(date '+%F %T')] [Watcher] timer.sh exited with $code. Restarting in 5s..." >> "$LOG"
  sleep 5
done
