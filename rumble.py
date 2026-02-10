# rumble.py
import time
from evdev import InputDevice, ecodes, ff

dev = InputDevice('/dev/input/event16')  # change this
effect = ff.Effect(
    ecodes.FF_RUMBLE, -1, 0,
    ff.Trigger(0, 0),
    ff.Replay(2000, 0),
    ff.Rumble(strong_magnitude=0x8000, weak_magnitude=0x4000)
)
eid = dev.upload_effect(effect)
dev.write(ecodes.EV_FF, eid, 1)
time.sleep(2.2)
dev.erase_effect(eid)

