#!/bin/sh
#
# Sends a notification when the battery is low.
#
set -x

STATE_FILE="/tmp/battery-notification-state"
: ${WARNING_THRESHOLD=10}
: ${CRITICAL_THRESHOLD=5}

# Send a notification with a specified urgency if conditions are met.
# Usage: notify <urgency> <charge> <last_notified_level>
notify() {
  urgency=$1
  charge=$2
  last_notified_level=$3

  if [ "$urgency" = "critical" ]; then
    threshold=$CRITICAL_THRESHOLD
    message="Battery level is critically low at $charge%!"
    icon="battery-empty"
  elif [ "$urgency" = "normal" ]; then
    threshold=$WARNING_THRESHOLD
    message="Battery level is low at $charge%."
    icon="battery-low"
  else
    # Should not happen
    return 1
  fi

  if [ "$charge" -le "$threshold" ] && [ "$last_notified_level" -gt "$threshold" ]; then
    echo "Sending notification: $message"
    notify-send --urgency="$urgency" --icon="$icon" "Battery" "$message"
    echo "$threshold" > "$STATE_FILE"
    return 0
  fi

  return 1
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

    charge=$(cat "$battery/capacity")
    status=$(cat "$battery/status")

    if [ "$status" = "Discharging" ]; then
      if ! notify "critical" "$charge" "$last_notified_level"; then
        notify "normal" "$charge" "$last_notified_level"
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
