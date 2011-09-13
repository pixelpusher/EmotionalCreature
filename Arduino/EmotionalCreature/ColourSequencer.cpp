#include <WProgram.h>
#include "ColourSequencer.h"

// Quick hack: do something every second

#define INTERVAL 100

ColourSequencer::ColourSequencer(DimmerPlug &dimmer)
  : itsDimmer(dimmer),
    itsCounter(0),
    itsState(0)
{ }

void ColourSequencer::tenMSecPoll(void) {
  itsCounter = (itsCounter + 1) % INTERVAL;

  if (itsCounter == INTERVAL - 1) {
    itsState = 1 - itsState;
    if (itsState) {
      setLEDs(255, 255, 255, 255, 255, 255);
    } else {
      setLEDs(0, 0, 0, 0, 0, 0);
    }
  }
}

void ColourSequencer::setLEDs(int r1, int g1, int b1,
			      int r2, int g2, int b2
			     ) {
  Serial.println("setLEDs");

  itsDimmer.setMulti(DimmerPlug::PWM0,
		     r1, g1, b1,
		     r2, g2, b2,
		     0, 0,
		     0, 0, 0, 0,
		     0, 0, 0, 0, -1
		    );
}
