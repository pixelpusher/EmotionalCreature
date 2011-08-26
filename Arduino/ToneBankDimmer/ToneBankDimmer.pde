/*
 * This sketch generates sounds for the creature's emotional states.
 *
 *  Copyright (C) 2011 Evan Raskob and the team at Openlab Workshops' Life Project:
 * <info@openlabworkshops.org> 
 * http://lifeproject.spacestudios.org.uk
 * http://openlabworkshops.org
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * *******************
 * NOTE: we can't use delay() in any functions, because the creature is doing many other
 *   things simultanouely and delay() would prevent it from doing them. 
 ********************
 */
// Test for the Dimmer plug

#include <Ports.h>
#include <RF12.h> // needed to avoid a linker error :(

PortI2C myBus (2);
DimmerPlug dimmer (myBus, 0x41);



// the pin on which the speaker is attached - 
int soundpin=3;

// the length of each sound sequence
int timeOut = 4500;

// the time (in ms) when the current sound sequence started
long startTime = 0;

// this is a pointer the current sound generating function - 
// when this points to an actual function, it will run (see below)
void (*soundFunc)(int);


// this is an array of all the possible sound generating functions - they are individually
// defined below and each on takes in an "int" variable which represents the current time 
// difference in ms
void (*soundFuncs[])(int) = { 
  &happy, &sad, &angry, &bored, &disgusted, &antisocial, &disappointed, &horny, &dying
};

// index in the soundFuncs array (e.g. the current sound function)  
unsigned char index = 0;

// this is the number of emotions in the array that we want to play -
// in this case, only the 1st 2
unsigned char numEmotions = 9; 


// 
// Set things up
//
void setup()
{
  // set the current sound function
  soundFunc = &happy;
  //Serial.begin(9600);
  
    dimmer.begin();
  
// set up for totem pole - make it white, must be attached to power
  dimmer.setReg(dimmer.MODE2, 0x14);
}


//
// Runs as fast as possible...
//

void loop()
{
  // chck if we need to switch sound functions (e.g. if too much time has elapsed)
  int timeDiff = millis() - startTime;
  if (timeDiff >= timeOut)
  {
    timeDiff = 0;

    // turn off sound
    noTone(soundpin);
    // wait a bit - this is optional
    delay(1500);

    // reset start time
    startTime = millis();
    //    Serial.print(startTime);
    //    Serial.print(":");

    // go to next sound routine:
    index = (index + 1) % numEmotions;

    //    Serial.println(int(index));
    soundFunc = soundFuncs[index];
  }

  // now we actually run the current sound routine
  // by calling the function this points to
  (*soundFunc)(timeDiff);

}

//
// ramp "up" a pitch - not to be used anymore (convert to a methof like in "happy" below)
//
void soundRampUp(float lower, float upper, float steps)
{
  for(float freq = lower; freq < upper; freq += steps)
  {
    tone(soundpin, freq);
    delay(1); 
  }
  noTone(soundpin);
}


//
// ramp "down" a pitch - not to be used anymore (convert to a methof like in "happy" below)
//
void soundRampDown(float upper, float lower, float steps)
{
  for(float freq = upper; freq > lower; freq -= steps)
  {
    tone(soundpin, freq);
    delay(1); 
  }
  noTone(soundpin);
}

//
// HAPPY sound - argument is time elapsed in ms (from 0 to timeOut)
//
void happy(int tdiff)
{
  const int duration = 1000;

  tdiff  = tdiff % duration;
  float t = float(tdiff)/duration;
  float freq = 200.0f+1800.0f*t;
  tone(soundpin, freq);
  
  byte y = 255-byte(t*255);
  
  dimmer.setMulti(dimmer.PWM0, 
  y/*R*/, y/*G*/, 255/*B*/, 
  255-y/*R*/, 255-y/*G*/, 255/*B*/, 
  0, 0,
  0, 0, 0, 0,
  0, 0, 0, 0, -1); 
}

//
// SAD sound - argument is time elapsed in ms (from 0 to timeOut)
//

void sad(int tdiff)
{
  const int duration = 2500;

  tdiff  = tdiff % duration;

  float freq = 200.0f;
  float steps = 18.0f*float(tdiff)/duration;
  freq +=  sin(steps)+2*steps;
  tone(soundpin, freq);

  byte y = byte(map(freq, 200.0f, 236.0f, 255, 100));
  
  dimmer.setMulti(dimmer.PWM0, 
  y/*R*/, 255/*G*/, y/*B*/, 
  255-y/*R*/, 255/*G*/, 255-y/*B*/, 
  0, 0,
  0, 0, 0, 0,
  0, 0, 0, 0, -1); 

  /* old:
   float freq = random(200, 300);
   
   for(float steps=0; steps<18; steps+=0.01)
   {
   tone(soundpin, freq + sin(steps) * 10 - steps*2);
   delay(1);
   }
   noTone(soundpin);
   */
}

void angry(int tdiff)
{
  int lower = random(200, 300);
  int upper = random(3000, 4000);

  for(float steps=0; steps<5; steps+=1)
  {
    soundRampUp(lower, upper, 10);
    soundRampDown(upper, lower, 10);
  }
  noTone(soundpin);
}

void bored(int tdiff)
{
  float freq = random(200, 300);

  for(float steps=0; steps<18; steps+=0.01)
  {
    tone(soundpin, freq);
    delay(1);
  }
  noTone(soundpin);

}

void disgusted(int tdiff)
{
  int lower = random(200, 300);
  int upper = random(3000, 4000);

  delay(150);

  soundRampUp(lower, upper, 5);
  soundRampDown(upper, lower, 20);
}

void horny(int tdiff)
{
  soundRampUp(random(200, 400), random(3000, 3500), 20);

  int lower = random(200, 400);
  int upper = random(3000, 3500);

  delay(150);

  soundRampUp(lower, upper, 10);
  soundRampDown(upper, lower, 20);
}

void disappointed(int tdiff)
{
  soundRampDown(random(400, 440), 50, 0.3);
}

void antisocial(int tdiff)
{
  float freq = random(300, 400);

  for(float steps=0; steps<32; steps+=0.05)
  {
    tone(soundpin, freq + sin(steps) * 25);
    delay(1);
  }
  noTone(soundpin);
}

void dying(int tdiff)
{
  int lower = random(200, 400);
  int upper = random(3000, 3500);

  soundRampDown(upper, lower, 1);
}






