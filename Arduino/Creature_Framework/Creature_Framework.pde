//
// RGOL Creature framework code
//

//#include <Ports.h>
//#include <RF12.h> // needed to avoid a linker error :(


//PortI2C myBus (2);
//DimmerPlug dimmer (myBus, 0x41);

// the pin on which the speaker is attached 
int soundPin=3; // I on port 4

#include "Math.h"
#include "SoundInternal.h"
#include "Sounds.h"

void setup()
{
 // dimmer.begin();
  
  // set up for totem pole - make it white, must be attached to power
  //dimmer.setReg(dimmer.MODE2, 0x14);
  
}

void loop()
{
  setToneSimple();
  playDemoSounds();
  
  setToneWave(300, 100);
  playDemoSounds();
  setToneWave(500, 20);
  playDemoSounds();
  
  setToneChord(300, 2, 100);
  playDemoSounds();
  setToneChord(200, 4, 50);
  playDemoSounds();
  setToneChord(200, 3, 10);
  playDemoSounds();
  
  setToneRandom(200, 1);
  playDemoSounds();
  setToneRandom(200, 10);
  playDemoSounds();
  setToneRandom(200, 50);
  playDemoSounds();
}

// Plays all demo sounds with set tone
void playDemoSounds()
{
  playSoundNote(300, 1000);
  wait(1000);
  playSoundRamp(100, 500, 1000);
  wait(1000);
  playSoundRamp(800, 50, 1000);
  wait(1000);
  playSoundWave(300, 200, 500 ,2000);
  
  wait(2500);
}

void wait(int ms)
{
  long endTicks = millis() + ms;
  while(millis() < endTicks)
  {
    updateSound();
    delay(1); 
  }
}


