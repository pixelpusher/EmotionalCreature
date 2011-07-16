/*
 * Test for the Dimmer plug by Jeelabs (http://jeelabs.org)
 *
 *  Copyright (C) 2011 Evan Raskob <evan@openlabworkshops.org> http://openlabworkshops.org
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
 */

//
// This uses 2 Piranha RGB LEDs connected to the 
// Dimmer plug, which is on port 2 of the JeeNode.
// I used a ~600 Ohm resistor from the PWR
// pin on the Dimmer plug to the common anode of the 
// LED, with direct connection between the G and B pins
// on the LEDs and a 100 Ohm resistor between the appropriate
// Dimmer output pin and the R pin on the LED.
//
// **Note that in this configuration, a value of 255 sent to an LED
// pin is OFF and a value of 0 is ON**


#include <Ports.h>
#include <RF12.h> // needed to avoid a linker error :(

PortI2C myBus (2);  // the dimmer is on Port 2
DimmerPlug dimmer (myBus, 0x41);  // the address depends on the solder jumper on the plug


void setup () {

  Serial.begin(57600); // for debugging only

  dimmer.begin();

  // set up for group blinking
  //  dimmer.setReg(dimmer.MODE2, 0x34);

  // set up for open drain - make it white, must be attached to power
  // doesn't work very well or predictably with the pirahna rgb
  //dimmer.setReg(dimmer.MODE2, 0x10);

  // set up for totem pole - make it white, must be attached to power
  dimmer.setReg(dimmer.MODE2, 0x14);

  // these next lines will cause some strange things to happen
  // and are not advised to use if you want control over each LED
  // individually:
  // blink rate: 0 = very fast, 255 = 10s
  // dimmer.setReg(dimmer.GRPFREQ, 100);
  // blink duty cycle: 0 = full on, 255 = full off
  // dimmer.setReg(dimmer.GRPPWM, 100);

}

void loop () {

  // fade in RED on the 1st, GREEN on the 2nd
  for (byte i = 0; i < 255; ++i) {
    dimmer.setMulti(dimmer.PWM0, i/*R*/, 255/*G*/, 255/*B*/, 
    255, 255-i, 255, 
    0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0, -1);
    delay(10);
  }

  // fade in GREEN on the 1st, RED on the 2nd 
  for (byte i = 0; i < 255; ++i) {
    dimmer.setMulti(dimmer.PWM0, 255/*R*/, i/*G*/, 255/*B*/, 
    255-i, 255, 255, 
    0, 0,
    0, 0, 0, 0,
    0, 0, 0, i, -1);
    delay(10);
  }

  // fade in BLUE on the 1st, GREEN on the 2nd
  for (byte i = 0; i < 255; ++i) {
    dimmer.setMulti(dimmer.PWM0, 255/*R*/, 255/*G*/, i/*B*/, 
    255, 255-i, 255, 
    0, 0,
    0, 0, 0, 0,
    0, 0, 0, i, -1);
    delay(10);
  }

  // fade in WHITE on the 1st, WHITE on the 2nd
  for (byte i = 0; i < 255; ++i) {
    dimmer.setMulti(dimmer.PWM0, i/*R*/, i/*G*/, i/*B*/, 
    i/*R*/, i/*G*/, i/*B*/,
    0, 0,
    0, 0, 0, 0,
    0, 0, 0, i, -1);
    delay(10);
  }

  // wait a second
  delay(1000);
}






