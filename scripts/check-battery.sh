#!/bin/sh
#
# Sends a notification when the battery is low.
#

STATE_FILE="/tmp/battery-notification-state"

# Send a notification with a specified urgency.
# Usage: notify <urgency> <level> <message>
notify() {
  urgency=$1
  level=$2
  message=$3
  echo "Sending notification: $message"
  notify-send --urgency="$urgency" "Battery" "$message"
  echo "$level" > "$STATE_FILE"
}

main() {
  last_notified_level=0
  if [ -f "$STATE_FILE" ]; then
    last_notified_level=$(cat "$STATE_FILE")
  fi

  for battery in /sys/class/power_supply/BAT*; do
    if [ ! -d "$battery" ]; then
      continue
    fi

    capacity=$(cat "$battery/capacity")
    status=$(cat "$battery/status")

    if [ "$status" = "Discharging" ]; then
      if [ "$capacity" -le 5 ] && [ "$last_notified_level" -gt 5 ]; then
        notify "critical" 5 "Battery level is critically low at $capacity%!"
      elif [ "$capacity" -le 10 ] && [ "$last_notified_level" -gt 10 ]; then
        notify "normal" 10 "Battery level is low at $capacity%."
      fi
    elif [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
      # Reset state if charging or full
      if [ -f "$STATE_FILE" ]; then
        rm "$STATE_FILE"
      fi
    fi
  done
}

main "$@"
