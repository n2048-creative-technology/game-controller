
#include <Arduino.h>
#include <BleGamepad.h>

BleGamepad bleGamepad;

void setup()
{
    Serial.begin(115200);
    Serial.println("Starting BLE work!");


  BleGamepadConfiguration cfg;
  cfg.setEnableOutputReport(true);
  cfg.setOutputReportLength(2); // 2 bytes: [left, right] rumble

  bleGamepad = BleGamepad("BLE Gamepad", "n2048", 100);

    bleGamepad.begin();
     
    // The default bleGamepad.begin() above enables 16 buttons, all axes, one hat, and no simulation controls or special buttons
}

void loop()
{
    if (bleGamepad.isConnected())
    {
        if (bleGamepad.isOutputReceived()) {
      uint8_t *out = bleGamepad.getOutputBuffer();
      if (out) {
        uint8_t rumbleLeft  = out[0];
        uint8_t rumbleRight = out[1];
        // Drive your haptic motor(s) here.
      }
    }
    
        bleGamepad.press(BUTTON_5);
        delay(500);
        bleGamepad.release(BUTTON_5);
        delay(500);

//        bleGamepad.pressStart();
//        bleGamepad.releaseStart();
 
        bleGamepad.setHat1(HAT_DOWN_RIGHT);        
        delay(500);
        bleGamepad.setHat1(HAT_CENTERED);
        delay(500);

//        bleGamepad.setAxes(0, 0, 0, 0, 0, 0, 0, 0);           //(X, Y, Z, RX, RY, RZ)
        //bleGamepad.setHIDAxes(0, 0, 0, 0, 0, 0, 0, 0);      //(X, Y, Z, RZ, RX, RY)
//        delay(500);
    }
}
