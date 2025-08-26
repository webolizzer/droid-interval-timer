#!/bin/bash

#================================================#
#                 CONFIGURATION                  #
#================================================#
# Set your active time window here.
START_HOUR=11  # The hour the signals should start (e.g., 11 for 11:00)
END_HOUR=4     # The hour the signals should end   (e.g., 4 for 04:59)
#================================================#

# --- Wake Lock and Cleanup ---
# This function is called when the script is stopped (e.g., with Ctrl+C)
cleanup() {
    echo -e "\nReleasing wake lock and exiting."
    termux-wake-unlock
    exit 0
}

# 'trap' ensures the cleanup function runs when the script exits or is interrupted.
# This prevents the wake lock from draining your battery after you stop the script.
trap cleanup SIGINT EXIT

# Acquire a wake lock to allow the script to run with the screen off.
echo "Acquiring wake lock to run in the background..."
termux-wake-lock
# --- End of Wake Lock ---


# A function to play the 5-beep sequence.
play_beeps() {
  for i in {1..5}
  do
    play -q -n synth 0.12 sine 1000 vol 0.6
    sleep 0.1
  done
}

# Infinite loop to keep the script running.
while true
do
  # Synchronization Logic
  CURRENT_MINUTE=$(date +%-M)
  CURRENT_SECOND=$(date +%-S)
  SECONDS_PAST_MARK=$(( (CURRENT_MINUTE % 15) * 60 + CURRENT_SECOND ))
  SECONDS_TO_WAIT=$(( 900 - SECONDS_PAST_MARK ))
  echo "Waiting $SECONDS_TO_WAIT seconds to sync to the next quarter hour..."
  sleep $SECONDS_TO_WAIT

  # Time Window Check
  CURRENT_HOUR=$(date +%H)
  IS_ACTIVE=false
  if [ $START_HOUR -gt $END_HOUR ]; then
    if [ "$CURRENT_HOUR" -ge $START_HOUR ] || [ "$CURRENT_HOUR" -le $END_HOUR ]; then
      IS_ACTIVE=true
    fi
  else
    if [ "$CURRENT_HOUR" -ge $START_HOUR ] && [ "$CURRENT_HOUR" -le $END_HOUR ]; then
      IS_ACTIVE=true
    fi
  fi

  if [ "$IS_ACTIVE" = true ]; then
    MINUTE_NOW=$(date +%M)
    echo "It's $(date +%H:%M). Running signal for minute $MINUTE_NOW."

    case "$MINUTE_NOW" in
      "00")
        play_beeps
        termux-tts-speak "round 1"
        ;;
      "15")
        play_beeps
        termux-tts-speak "round 2"
        ;;
      "30")
        play_beeps
        termux-tts-speak "round 3"
        ;;
      "45")
        play_beeps
        termux-tts-speak "Take a break"
        ;;
    esac
  else
    echo "It's $(date +%H:%M), a quarter hour, but outside the active window. Skipping."
  fi
done
