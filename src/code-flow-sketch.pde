/*                                             -*- mode:C++ -*-
 *
 * Sketch description: Demonstrate detecting 'code flow' activities
 * 
 * Sketch author: Dave
 *
 */

void codeFlowEventHook(u8 face, CodeFlowStatus status) {
  u8 faceLED = pinInFace(FACE_LED_PIN,face);
  switch (status) {
  case CODE_FLOW_INIT: logNormal("Code flow init on %c\n", FACE_CODE(face)); break;
  case CODE_FLOW_IDLE: logNormal("Code flow idle on %c\n", FACE_CODE(face)); break;
  case CODE_FLOW_ACTIVE:        // Do a blink for activity
    QLED.on(faceLED,16);
    QLED.off(faceLED,16);
    break;
  case CODE_FLOW_SUCCEEDED:     // And a big display for success
    QLED.forget(faceLED);
    for (u32 i = 0; i < 19; ++i) { // End on an even number to shut off the blue
      if (i&1) {
        QLED.on(BODY_RGB_BLUE_PIN, 100);
        QLED.on(pinInFace(FACE_LED_PIN,OPPOSITE_FACE(face)), 100);
        QLED.off(faceLED, 100);
      } else {
        QLED.off(BODY_RGB_BLUE_PIN, 100);
        QLED.off(pinInFace(FACE_LED_PIN,OPPOSITE_FACE(face)), 100);
        QLED.on(faceLED, 100);
      }
    }
  }
}

u16 qbuf[255];
void setup() {
  setCodeFlowStatusCallback(codeFlowEventHook); // Install our hook
  QLED.begin(qbuf,255);         // Start the QLEDs with a max buffer
}

void loop() {
  ledOn(BODY_RGB_RED_PIN);
  delay(2000);
  ledOff(BODY_RGB_RED_PIN);
  delay(3000);
}
