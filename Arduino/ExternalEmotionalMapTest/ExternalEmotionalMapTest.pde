/*
 * This is a test of the "brain" of the creature - it loads an array
 * containing emotional responses along with functions for changing emotional
 * states. It uses PROGMEM to load the giant array into program memory,
 * because the ATMEGA doesn't have enough RAM to store all of the data. 
 *
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
 
#include <avr/pgmspace.h>

int NUM_EMOTIONS = 11;

unsigned int HAPPY=0;
unsigned int SAD = 1;
unsigned int ANGRY = 2;
unsigned int BORED = 3;
unsigned int DISGUSTED = 4;
unsigned int SURPRISED = 5;
unsigned int HUNGRY = 6;
unsigned int HORNY = 7;
unsigned int ANTISOCIAL = 8;
unsigned int DYING=9;
unsigned int DEAD = 10;
unsigned int EMOTIONS_END = 11; 

// current emotional state / received state / next state
//
const prog_uchar ExternalStateMap[] PROGMEM = {
3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3};

unsigned int To3DIndex(unsigned int i, unsigned int j, unsigned int k)
{
  unsigned int ii = (unsigned int)(i);
  unsigned int jj = (unsigned int)(j);
  unsigned int kk = (unsigned int) (k);
  return (ii*NUM_EMOTIONS*NUM_EMOTIONS) + (jj*NUM_EMOTIONS) + kk;
}

void setup()
{
  Serial.begin(38400); 
   
  Serial.print("External Happy/happy/sad: ");
  unsigned int index =  To3DIndex(HAPPY,HAPPY,SAD);
  Serial.println(index);
  char myChar =  pgm_read_byte_near(ExternalStateMap + index);
  Serial.println(float(myChar)/10.0f);
  Serial.println("DONE");
 
}

void loop()
{
 
}
