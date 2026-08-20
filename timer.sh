#!/bin/bash

START_HOUR=8
END_HOUR=23

termux-tts-speak "Interval timer started successfully!"

cleanup() {
  echo -e "\nReleasing wake lock and exiting."
  termux-wake-unlock
  exit 0
}

trap cleanup SIGINT EXIT

echo "Acquiring wake lock to run in the background..."
termux-wake-lock

play_beeps_and_speak() {
  local text="$1"
  local cur_vol max_vol target_vol

  cur_vol=$(termux-volume | grep -A 2 '"stream": "music"' | grep '"volume"' | grep -o '[0-9]\+')
  max_vol=$(termux-volume | grep -A 3 '"stream": "music"' | grep '"max_volume"' | grep -o '[0-9]\+')
  target_vol=$(( max_vol * 20 / 100 ))
  [ "$target_vol" -eq 0 ] && target_vol=1

  termux-volume music "$target_vol"
  play -q -n synth 0.12 sine 1000 fade 0.005 0.12 0.02 vol -6dB pad 0 0.15 repeat 1
  termux-tts-speak "$text"
  termux-volume music "$cur_vol"
}

while true
do
  CURRENT_HOUR=$(date +%H)
  CURRENT_MINUTE=$(date +%-M)
  CURRENT_SECOND=$(date +%-S)
  SECONDS_PAST_MARK=$(( (CURRENT_MINUTE % 15) * 60 + CURRENT_SECOND ))
  SECONDS_TO_WAIT=$(( 900 - SECONDS_PAST_MARK ))

  sleep "$SECONDS_TO_WAIT"

  IS_ACTIVE=false
  if [ "$START_HOUR" -gt "$END_HOUR" ]; then
    if [ "$CURRENT_HOUR" -ge "$START_HOUR" ] || [ "$CURRENT_HOUR" -le "$END_HOUR" ]; then
      IS_ACTIVE=true
    fi
  else
    if [ "$CURRENT_HOUR" -ge "$START_HOUR" ] && [ "$CURRENT_HOUR" -le "$END_HOUR" ]; then
      IS_ACTIVE=true
    fi
  fi

  if [ "$IS_ACTIVE" = true ]; then
    MINUTE_NOW=$(date +%M)

    case "$MINUTE_NOW" in
      "00")
        play_beeps_and_speak "Round 1"
        ;;
      "15")
        play_beeps_and_speak "Round 2"
        ;;
      "30")
        play_beeps_and_speak "Round 3"
        ;;
      "45")
        play_beeps_and_speak "Take a break!"
        ;;
    esac
  fi
done
