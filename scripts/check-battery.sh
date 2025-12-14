#!/bin/sh
#
# Sends a notification when the battery is low.
#

STATE_FILE="/tmp/battery-notification-state"
: ${WARNING_LEVEL=10}
: ${CRITICAL_LEVEL=5}

# Send a notification with a specified urgency.
# Usage: notify <urgency> <level> <message> <icon>
notify() {
  urgency=$1
  level=$2
  message=$3
  icon=$4
  echo "Sending notification: $message"
  notify-send --urgency="$urgency" --icon="$icon" "Battery" "$message"
  echo "$level" > "$STATE_FILE"
}

main() {
  last_notified_level=101
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
      if [ "$capacity" -le $CRITICAL_LEVEL ] && [ "$last_notified_level" -gt $CRITICAL_LEVEL ]; then
        notify "critical" $CRITICAL_LEVEL "Battery level is critically low at $capacity%!" "battery-empty"
      elif [ "$capacity" -le $WARNING_LEVEL ] && [ "$last_notified_level" -gt $WARNING_LEVEL ]; then
        notify "normal" $WARNING_LEVEL "Battery level is low at $capacity%." "battery-low"
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
