#if 1

#include "ColourSequencer.h"

// Quick hack: do something every second

#define INTERVAL 100

ColourSequencer::ColourSequencer()
  : itsDimmer(NULL),
    itsCounter(0),
    itsState(0)
{ 
  rgbR[0] = rgbR[1]= rgbR[2] = 0;
  rgbL[0] = rgbL[1]= rgbL[2] = 0;
}

void ColourSequencer::setDimmer(DimmerPlug *dimmer)
{
  itsDimmer = dimmer;
}

void ColourSequencer::tenMSecPoll(void) 
{
  itsCounter = (itsCounter + 1) % INTERVAL;

  if (itsCounter == INTERVAL - 1) {
    itsState = (itsState + 1)  % 4;
    switch (itsState) {
      case 0:
        setLEDs(255, 0, 0, 255, 0, 0);
        Serial.println("red");
        break;

      case 2:
        setLEDs(0,0,255, 0, 0, 255);
        Serial.println("blue");
        break;

      case 1:
        setLEDs(0,255, 0, 0, 255, 0);
        Serial.println("green");
        break;  
    
      default:
        setLEDs(0,0, 0, 0, 0, 0);
        Serial.println("off");
        break;  
      
    }
  }
}


void ColourSequencer::setLEDs(HSVColori rColor, HSVColori lColor)
{
  rColor.toRGB(rgbR);
  lColor.toRGB(rgbL);
  setLEDs();
}

void ColourSequencer::setLEDs()
{
  setLEDs(rgbL[0], rgbL[1], rgbL[2],
          rgbR[0], rgbR[1], rgbR[2]);
}

void ColourSequencer::setLEDs(int r1, int g1, int b1,
			      int r2, int g2, int b2
			     ) {
  #ifdef DEBUG
  Serial.println("setLEDs:");
  Serial.print(r1);
  Serial.print(":");
  Serial.print(g1);
  Serial.print(":");
  Serial.println(b1);
  #endif
  
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
