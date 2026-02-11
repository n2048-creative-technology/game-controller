# game-controller


# Tools

Send values [0-255] to the feedback haptics:

```
./ble_rumble.sh <left 0-255> <right 0-255>
```


check if controller events are being received: 

```
evtest /dev/input/event256
```
