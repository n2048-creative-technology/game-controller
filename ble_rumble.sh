#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./ble_rumble.sh <left 0-255> <right 0-255>
# Sends HID Output report: [ReportID=0x03, left, right] to the matching UHID BLE gamepad.

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <left 0-255> <right 0-255>"
  exit 1
fi

LEFT="$1"
RIGHT="$2"

# Validate integers 0..255
if ! [[ "$LEFT" =~ ^[0-9]+$ ]] || ! [[ "$RIGHT" =~ ^[0-9]+$ ]]; then
  echo "Error: left/right must be integers (0-255)"
  exit 1
fi
if [ "$LEFT" -gt 255 ] || [ "$RIGHT" -gt 255 ]; then
  echo "Error: left/right must be in range 0-255"
  exit 1
fi

LEFT_HEX="$(printf '%02x' "$LEFT")"
RIGHT_HEX="$(printf '%02x' "$RIGHT")"

UHID_BASE="/sys/devices/virtual/misc/uhid"

# Find candidate UHID device dirs that have:
# - report_descriptor
# - hidraw/
# - descriptor contains 0x85 0x03 (Report ID 3)
# - descriptor contains 0x91 (Output item)
FOUND_DEV=""

shopt -s nullglob
for DEV in "$UHID_BASE"/0005:*; do
  RD="$DEV/report_descriptor"
  HRD="$DEV/hidraw"

  [ -e "$RD" ] || continue
  [ -d "$HRD" ] || continue

  # Read descriptor as hex bytes (no spaces/newlines)
  # Use hexdump which reads from sysfs fine.
  HEX="$(hexdump -v -e '1/1 "%02x"' "$RD" 2>/dev/null || true)"
  [ -n "$HEX" ] || continue

  # Must contain Report ID 03 (85 03) and an Output item (91)
  if [[ "$HEX" == *"8503"* && "$HEX" == *"91"* ]]; then
    FOUND_DEV="$DEV"
    break
  fi
done
shopt -u nullglob

if [ -z "$FOUND_DEV" ]; then
  echo "Error: no matching UHID device found (need ReportID=3 and an Output item in the descriptor)."
  echo "Tip: ensure the controller is connected and re-paired after firmware changes."
  exit 1
fi

HIDRAW_NODE="$(ls -1 "$FOUND_DEV/hidraw" 2>/dev/null | head -n 1 || true)"
if [ -z "$HIDRAW_NODE" ]; then
  echo "Error: matched device has no hidraw node under $FOUND_DEV/hidraw"
  exit 1
fi

DEVICE="/dev/$HIDRAW_NODE"
if [ ! -e "$DEVICE" ]; then
  echo "Error: $DEVICE does not exist"
  exit 1
fi

echo "Using UHID: $FOUND_DEV"
echo "Using device: $DEVICE"
echo "Sending: report_id=3 left=$LEFT right=$RIGHT"

# Send [0x03, left, right]
sudo bash -c "printf '\x03\x$LEFT_HEX\x$RIGHT_HEX' > '$DEVICE'"
echo "OK"
