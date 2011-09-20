/*
 * This is main code of the creature - it brings together all of the test sketches
 * to create a creature that uses an emotional map and a number of functions
 * that determine emotional state coupled with some LED drivers, infrared communication,
 * and also wireless communication. 
 *
 **********************************
 *  Copyright (C) 2011 Evan Raskob and the team at Openlab Workshops' Life Project:
 * <info@openlabworkshops.org> 
 * http://lifeproject.spacestudios.org.uk
 * http://openlabworkshops.org
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ***********************************
 
  
 /                 JeeNode / JeeNode USB / JeeSMD 
 -------|-----------------------|----|-----------------------|----       
 |       |D3  A1 [Port2]  D5     |    |D3  A0 [port1]  D4     |    |
 |-------|IRQ AIO +3V GND DIO PWR|    |IRQ AIO +3V GND DIO PWR|    |
 | D1|TXD|                                           ---- ----     |
 | A5|SCL|                                       D12|MISO|+3v |    |
 | A4|SDA|   Atmel Atmega 328                    D13|SCK |MOSI|D11 |
 |   |PWR|   JeeNode / JeeNode USB / JeeSMD         |RST |GND |    |
 |   |GND|                                       D8 |BO  |B1  |D9  |
 | D0|RXD|                                           ---- ----     |
 |-------|PWR DIO GND +3V AIO IRQ|    |PWR DIO GND +3V AIO IRQ|    |
 |       |    D6 [Port3]  A2  D3 |    |    D7 [Port4]  A3  D3 |    |
 -------|-----------------------|----|-----------------------|----
 /
 
 
 */
 
 

#include <Ports.h>
#include <RF12.h> // needed to avoid a linker error :(
#include "EmotionalVars.h"
#include "ExternalEmotions.h"
#include "InternalEmotions.h"
#include "ColourSequencer.h"
#include <avr/pgmspace.h>
#include <NewSoftSerial.h>
#include "HSVColor.h";

// IRQ on Port A0 on the JeeNode is send (inverted)
NewSoftSerial irSerialSender(-1, A0, true); // this device uses inverted signaling

// DIO on Port 1 on the JeeNode is receive
NewSoftSerial irSerialReceiver(4, -1); // this device uses regular signaling

EmotionState myEmoState = HAPPY;

MilliTimer timer;
MilliTimer colourSequencerTimer;

// ms between internal updates
const int INTERNAL_UPDATE_INTERVAL = 2000;

// msec interval for colour sequencing.
const int COLOUR_SEQ_INTERVAL = 10;

// change this for other creatures - make it unique
const char CREATURE_ID = '3';
// times we've sent this emotion...
char seqNum = '0';

HSVColori leftColori, rightColori;
int rgbL[3], rgbR[3];

//
// SOUND STUFF
//

PortI2C myBus (2);
DimmerPlug dimmer (myBus, 0x41);

// DimmerPlug should be internalised to ColourSequencer in due course.

// the pin on which the speaker is attached - 
const int soundPin=6;

// the time (in ms) when the current sound sequence started
long startTime = 0;

// this is a pointer the current sound generating function - 
// when this points to an actual function, it will run (see below)
void (*expressionFunc)(DimmerPlug&, int, int);


// this is an array of all the possible sound generating functions - they are individually
// defined below and each on takes in an "int" variable which represents the current time 
// difference in ms
void (*expressionFuncs[])(DimmerPlug&, int, int) = { 
  &happy, &sad, &angry, &bored, &disgusted, &antisocial, &disappointed, &horny, &dying
};

ColourSequencer theColourSequencer;


void setup()
{
  irSerialReceiver.begin(2400);
  irSerialSender.begin(2400);

  Serial.begin(38400);

  dimmer.begin();

  // set up for totem pole - make it white, must be attached to power
  dimmer.setReg(DimmerPlug::MODE2, 0x14);
  
  // Evan: the reference to the dimmer needs to be set AFTER it is initialized, for some reason
  theColourSequencer.setDimmer(&dimmer);
  
  for (int i=0; i<3; i++)
  {
    // off by default
    rgbR[i] = rgbL[i] = 255;
  }
  
  Serial.print("TESTING...");
  Serial.print("Internal Happy/Happy: ");
  Serial.println(InternalStateMap[HAPPY][HAPPY]);

  Serial.print("Internal Happy/Angry: ");
  Serial.println(InternalStateMap[HAPPY][ANGRY]);

  EmotionState emoState = updateInternalEmotionalState(myEmoState);
  Serial.print("New state:");
  Serial.println(emoState);

  Serial.print("External Happy/angry/angry: ");
  unsigned int index = EmotionStateTo3DIndex(HAPPY,ANGRY,ANGRY);
  Serial.print(index);
  Serial.print(":");
  unsigned char myChar =  pgm_read_byte_near(ExternalStateMap + index);
  Serial.println(int(myChar));


  Serial.println("TESTING COLORS");
  leftColori.set(255,255,255); // full red
 
  rightColori.set(0,0,0); // black
  
  HSVColori tmpColor;
  
  HSVColori::lerp(leftColori, rightColori, tmpColor, 127);
  Serial.print("test: static lerp from red to black halfway:");
  Serial.print(tmpColor.h);
  Serial.print(",");
  Serial.print(tmpColor.s);
  Serial.print(",");
  Serial.println(tmpColor.v);


  leftColori.lerp(rightColori, tmpColor, 127);
  Serial.print("test: self lerp from red to black halfway:");
  Serial.print(leftColori.h);
  Serial.print(",");
  Serial.print(leftColori.s);
  Serial.print(",");
  Serial.println(leftColori.v);

 
  Serial.println("DONE TESTING");
  
  // set the current sound function
  expressionFunc = expressionFuncs[myEmoState];
  
  // update output color arrays
  updateRGBArrays();
  
  // write LED colors to dimmer plug
  //  updateLEDs();

  dimmer.setMulti(DimmerPlug::PWM0,
		     255, 0, 255,
		     255, 255, 0,
		     255, 255,
		     255, 255, 255, 255,
		     255, 255, 255, 255, -1
		    );
  
}

void loop()
{

  // update internal emotional state and send it
  if (timer.poll(INTERNAL_UPDATE_INTERVAL))
  {
    // first update internal state
    EmotionState emoState = updateInternalEmotionalState(myEmoState);
    if ( myEmoState !=  emoState && emoState != EMOTIONS_END)
    {
      myEmoState = emoState;
      seqNum = '0';
      Serial.print("New (internal) state:");
      Serial.println(myEmoState);

      irSerialSender.print(CREATURE_ID);
      irSerialSender.print(seqNum);
      irSerialSender.print(myEmoState,BYTE);
      
      // reset start time
    startTime = millis();
      
    }
    else
    {
      irSerialSender.print(CREATURE_ID);
      irSerialSender.print(seqNum++);
      irSerialSender.print(myEmoState,BYTE);
      
      if (seqNum > '9') seqNum = '0';
    }
  }
  // done updating/sending internal state


  // receive an external state and react to it
  if (irSerialReceiver.available() >= 3)
  {
    char c = irSerialReceiver.read();
    Serial.println(c);
    int creatureId = c-'0';

    c = irSerialReceiver.read();
    Serial.println(c);
    int seqNum     = c-'0';

    c = irSerialReceiver.read();
    Serial.println(c);

    EmotionState emotionState  = (EmotionState)c;
    Serial.print("(");
    Serial.print(seqNum);
    Serial.print(")");
    Serial.print("Received emotion:");
    Serial.print(emotionState);
    Serial.print(" from creature:");
    Serial.println(creatureId);


    if ( myEmoState != emotionState && emotionState != EMOTIONS_END)
    {
      myEmoState = emotionState;

      Serial.print("New (external) state:");
      Serial.println(myEmoState);
      
      // reset start time
    startTime = millis();
    }
  }

  int timeDiff = millis() - startTime;
    
  // set the current sound function
  expressionFunc = expressionFuncs[myEmoState];

// now we actually run the current sound routine
  // by calling the function this points to
  (*expressionFunc)(dimmer, soundPin, timeDiff);

  // Colour sequencing:

  if (colourSequencerTimer.poll(COLOUR_SEQ_INTERVAL)) {
    theColourSequencer.tenMSecPoll();
  }

}


//
//
// Sound Functions
//
//
//

//
// HAPPY sound - argument is time elapsed in ms (from 0 to timeOut)
//
void happy(DimmerPlug& dimmer, int soundPin,  int tdiff)
{
  const int duration = 1000;

  tdiff  = tdiff % duration;
  float t = float(tdiff)/duration;
  float freq = 200.0f+1800.0f*t;
  tone(soundPin, freq);
  
  byte y = 255-byte(t*255);

#if 0  
  dimmer.setMulti(dimmer.PWM0, 
  y/*R*/, y/*G*/, 255/*B*/, 
  255-y/*R*/, 255-y/*G*/, 255/*B*/, 
  0, 0,
  0, 0, 0, 0,
  0, 0, 0, 0, -1); 
#endif
}

//
// SAD sound - argument is time elapsed in ms (from 0 to timeOut)
//

void sad(DimmerPlug& dimmer, int soundPin, int tdiff)
{
  const int duration = 2500;

  tdiff  = tdiff % duration;

  float freq = 200.0f;
  float steps = 18.0f*float(tdiff)/duration;
  freq +=  sin(steps)+2*steps;
  tone(soundPin, freq);

  byte y = byte(map(freq, 200.0f, 236.0f, 255, 100));
  
#if 0
  dimmer.setMulti(dimmer.PWM0, 
  y/*R*/, 255/*G*/, y/*B*/, 
  255-y/*R*/, 255/*G*/, 255-y/*B*/, 
  0, 0,
  0, 0, 0, 0,
  0, 0, 0, 0, -1); 
#endif

  /* old:
   float freq = random(200, 300);
   
   for(float steps=0; steps<18; steps+=0.01)
   {
   tone(soundPin, freq + sin(steps) * 10 - steps*2);
   delay(1);
   }
   noTone(soundPin);
   */
}

void angry(DimmerPlug& dimmer, int soundPin, int tdiff)
{
  float freqLower = random(200, 300);
  float freqUpper = random(3000, 4000);
  int freq = 0;
  
  const int duration = 1500;
  const int halfDuration = 750;

  int newDiff =  tdiff % duration;
  tdiff = tdiff % halfDuration;
  
  float steps = 5.0f*float(tdiff)/halfDuration;
  
  if (newDiff > halfDuration)
  {
    freq =  freqLower + steps;
  }
  else
  {
   
    freq =  freqUpper - steps;
    tone(soundPin, freq);
  }  
  tone(soundPin, freq);
  byte y = byte(map(freq, freqLower, freqUpper, 0, 200));
  
#if 0
  dimmer.setMulti(dimmer.PWM0, 
  y/*R*/, 255/*G*/, 255/*B*/, 
  200-y/*R*/, 255/*G*/, 255/*B*/, 
  0, 0,
  0, 0, 0, 0,
  0, 0, 0, 0, -1); 
#endif

/* old:
  for(float steps=0; steps<5; steps+=1)
  {
    soundRampUp(lower, upper, 10);
    soundRampDown(upper, lower, 10);
  }
  noTone(soundPin);
  */
}


void bored(DimmerPlug& dimmer, int soundPin, int tdiff)
{

}

void disgusted(DimmerPlug& dimmer, int soundPin, int tdiff)
{

}

void horny(DimmerPlug& dimmer, int soundPin, int tdiff)
{

}

void disappointed(DimmerPlug& dimmer, int soundPin, int tdiff)
{

}

void antisocial(DimmerPlug& dimmer, int soundPin, int tdiff)
{

}

void dying(DimmerPlug& dimmer, int soundPin, int tdiff)
{

}



//
// Tell the dimmer plug to set the LEDs to the values stored in our color objects
//

inline void updateLEDs()
{
  dimmer.setMulti(dimmer.PWM0, 
  rgbL[0], rgbL[1], rgbL[2], 
  rgbR[0], rgbR[1], rgbR[2],
  255, 255,
  255, 255, 255, 255,
  255, 255, 255, 255, -1); 
}

inline void updateRGBArrays()
{
  rightColori.toRGB(rgbR);
  leftColori.toRGB(rgbL);
}

