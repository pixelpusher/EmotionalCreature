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
 
 
#include "HSVColor.h";


HSVColori leftColori, rightColori;
int rgbL[3], rgbR[3];



void setup()
{
 
  Serial.begin(57600);
  
  for (int i=0; i<3; i++)
  {
    // off by default
    rgbR[i] = rgbL[i] = 255;
  }
  
  Serial.print("TESTING...");
 

  Serial.println("TESTING COLORS");
  leftColori.set(255,255,255); // full red
 
  rightColori.set(0,0,0); // black
  
  HSVColori tmpColor(255,255,255);
  
    Serial.print("test: equality of tmp and left: ");
    Serial.println(tmpColor == leftColori);
  
    Serial.print("test: INequality of tmp and left: ");
    Serial.println(tmpColor != leftColori);

  
  HSVColori::lerp(leftColori, rightColori, tmpColor, 127);
  Serial.print("test: static lerp from red to black halfway:");
  Serial.print(tmpColor.h);
  Serial.print(",");
  Serial.print(tmpColor.s);
  Serial.print(",");
  Serial.println(tmpColor.v);



  leftColori.lerp(rightColori, 127);
  Serial.print("test: self lerp from red to black halfway:");
  Serial.print(leftColori.h);
  Serial.print(",");
  Serial.print(leftColori.s);
  Serial.print(",");
  Serial.println(leftColori.v);

  leftColori.shiftHue(10);
  Serial.print("test: shiftHue by +10: ");
  Serial.print(leftColori.h);
  Serial.print(",");
  Serial.print(leftColori.s);
  Serial.print(",");
  Serial.println(leftColori.v);


  leftColori.shiftHue(-139);
  Serial.print("test: shiftHue by -139: ");
  Serial.print(leftColori.h);
  Serial.print(",");
  Serial.print(leftColori.s);
  Serial.print(",");
  Serial.println(leftColori.v);
  
  leftColori.shiftHue(-255);
  Serial.print("test: shiftHue by -255: ");
  Serial.print(leftColori.h);
  Serial.print(",");
  Serial.print(leftColori.s);
  Serial.print(",");
  Serial.println(leftColori.v);

  leftColori.lerp(rightColori, 10);
  Serial.print("test: self lerp from red to black 10/255 of the way :");
  Serial.print(leftColori.h);
  Serial.print(",");
  Serial.print(leftColori.s);
  Serial.print(",");
  Serial.println(leftColori.v);

  
 
  Serial.println("DONE TESTING");
 

  
}

void loop()
{
 // nothing 
}

inline void updateRGBArrays()
{
  rightColori.toRGB(rgbR);
  leftColori.toRGB(rgbL);
}

