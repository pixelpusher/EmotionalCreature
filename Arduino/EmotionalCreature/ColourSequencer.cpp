#if 1

#include "ColourSequencer.h"

// Quick hack: do something every second

#define INTERVAL 100

ColourSequencer::ColourSequencer()
  : itsDimmer(NULL),
    itsCounter(0),
    itsState(0)
{ }

void ColourSequencer::setDimmer(DimmerPlug *dimmer)
{
  itsDimmer = dimmer;
}

void ColourSequencer::tenMSecPoll(void) 
{
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
  Serial.println("setLEDs:");
  Serial.print(r1);
  Serial.print(":");
  Serial.print(g1);
  Serial.print(":");
  Serial.println(b1);
  if (itsDimmer != NULL)
  {
  itsDimmer->setMulti(DimmerPlug::PWM0,
		     r1, g1, b1,
		     r2, g2, b2,
		     0, 0,
		     0, 0, 0, 0,
		     0, 0, 0, 0, -1
		    );
  }
}

#endif
