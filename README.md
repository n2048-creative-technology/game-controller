# game-controller

An ESP32-S3 BLE HID gamepad with haptic feedback output, plus a custom PCB
(gamepad button/stick layout) and a 3D-printed trackball part.

**Status: needs work.** BLE gamepad input/output is functional; the actual
haptic motor driving code is a stub — see Known limitations.

## Hardware

- ESP32-S3 dev board (`esp32-s3-controller/`, `board = esp32-s3-devkitc-1`
  in `platformio.ini`)
- Custom gamepad PCB — `electronics/gamepad/gamepad.kicad_pro` (KiCad)
- 3D-printed trackball — `3d-models/trackball.scad` / `.stl`
- A haptic motor (ERM/LRA) intended to be driven from the BLE HID output
  report — **not yet wired up in firmware**, see below

No pin list is documented for the gamepad buttons/stick/trackball wiring —
check `electronics/gamepad/gamepad.kicad_sch` for the actual connector
assignments before wiring a board by hand.

## Firmware

`esp32-s3-controller/src/main.cpp` uses the `BleGamepad` library to present
as a BLE HID gamepad:

- Reports button/axis state to the host (via `BleGamepad` calls — the
  current source only exercises a demo button toggle, not real button/stick
  reads yet).
- Accepts a 2-byte HID **output** report (`[left, right]` rumble intensity,
  0–255 each) from the host, intended to drive haptic motors — currently
  just logs the received values (`// Drive your haptic motor(s) here.` is
  still a TODO in `main.cpp`).

### Build & flash

```bash
cd esp32-s3-controller
pio run
pio run -t upload
pio device monitor
```

## Host-side tools

- `scripts/ble_rumble.sh <left 0-255> <right 0-255>` — sends a rumble
  output report to the connected controller from Linux, by finding its
  UHID device under `/sys/devices/virtual/misc/uhid` and writing directly
  to the matching `hidraw` node. Needs `sudo`.
- Check raw controller events with `evtest /dev/input/event256` (device
  number varies — find yours with `evtest` run with no arguments).

## Known limitations

- **Haptic motor output is not implemented** — the firmware receives the
  rumble output report but doesn't drive any GPIO/PWM from it yet.
- **No real button/axis input wired up** — `main.cpp` currently only
  demonstrates toggling `BUTTON_5` on a timer as a connectivity test; actual
  gamepad button/joystick reads from the PCB aren't implemented.
- No documented pin map from the ESP32-S3 to the gamepad PCB's
  buttons/stick/trackball — read the KiCad schematic directly.
