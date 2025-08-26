#!/bin/bash
# This script keeps timer.sh running from the interval-timer directory.

while true; do
  echo "[Watcher] Starting timer.sh..."
  # The path is updated to look inside the same folder.
  ~/droid-interval-timer/timer.sh
  echo "[Watcher] timer.sh has stopped. Restarting in 5 seconds..."
  sleep 5
done
