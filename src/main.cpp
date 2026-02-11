
#include <Arduino.h>
#include <BleGamepad.h>

BleGamepad bleGamepad;

bool connectionReported = false;

bool b5Pressed = false;
uint32_t b5NextMs = 0;
const uint32_t b5IntervalMs = 500;


// activate and deactivate BTN_WEST at 1 Hz
void updateButton5()
{
  uint32_t now = millis();
  if (now < b5NextMs) return;

  b5NextMs = now + b5IntervalMs;

  if (!b5Pressed) {
    bleGamepad.press(BUTTON_5);
    b5Pressed = true;
  } else {
    bleGamepad.release(BUTTON_5);
    b5Pressed = false;
  }
}


void setup()
{
    Serial.begin(115200);
    Serial.println("Starting BLE work!");


    BleGamepadConfiguration cfg;
    cfg.setEnableOutputReport(true);
    cfg.setOutputReportLength(2);  // 2 bytes: left, right

    bleGamepad = BleGamepad("BLE Gamepad", "n2048", 100);
    bleGamepad.begin(&cfg);

     
    // The default bleGamepad.begin() above enables 16 buttons, all axes, one hat, and no simulation controls or special buttons
}

void loop()
{

  if (!bleGamepad.isConnected()) {
    delay(200);
    Serial.println("Waiting for client to connect...");
    connectionReported = false;
    return;
  }
else if (!connectionReported) {
    Serial.println("Client connected!");
    connectionReported = true;
  }

  if (bleGamepad.isOutputReceived()) {
    uint8_t *out = bleGamepad.getOutputBuffer();
    
    if (out) {
      uint8_t rumbleLeft  = out[0];
      uint8_t rumbleRight = out[1];
      
      Serial.printf("Output report: %u %u\n", rumbleLeft, rumbleRight);
      // Drive your haptic motor(s) here.
    }
  }

  // Run the press/release "in parallel" without blocking
  updateButton5();

  delay(1);
  


//        bleGamepad.pressStart();
//        bleGamepad.releaseStart();

  // bleGamepad.setHat1(HAT_DOWN_RIGHT);        
  // delay(500);
  // bleGamepad.setHat1(HAT_CENTERED);
  // delay(500);

//        bleGamepad.setAxes(0, 0, 0, 0, 0, 0, 0, 0);           //(X, Y, Z, RX, RY, RZ)
      //bleGamepad.setHIDAxes(0, 0, 0, 0, 0, 0, 0, 0);      //(X, Y, Z, RZ, RX, RY)
//        delay(500);
  
}
