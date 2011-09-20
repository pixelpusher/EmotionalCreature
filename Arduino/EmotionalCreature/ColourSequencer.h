// -*- mode: c++;-*-

// LED sequencing module.
// NICK, 2011-09-13.
// $Id$

#ifndef ColourSequencer_h
#define ColourSequencer_h

#include <Ports.h>		/* For DimmerPlug. */

class ColourSequencer {
 public:
  ColourSequencer();
  void tenMSecPoll(void);
  void setDimmer(DimmerPlug *dimmer);

 private:
  DimmerPlug *itsDimmer;
  int itsCounter;
  int itsState;

  void setLEDs(int r1, int g1, int b1,
	       int r2, int g2, int b2
	      );
};


#endif
