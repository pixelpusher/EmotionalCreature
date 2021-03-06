/*
 * These are definitions of the external emotions (the ones that are broadcast to and recieved
 * from other creatures, and the Environment) - variables and functions for the system.
 *
 * NOTE: The array of external emotion probabilities, ExternalStateMap, is 
 * generated by a Processing sketch - DON'T EDIT BY HAND
 *
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
 */
 

#ifndef _EMOS_EXTERNAL_
#define _EMOS_EXTERNAL_

#include "EmotionalVars.h"
#include <avr/pgmspace.h>


// Data represents a 3D lookup table of probabilities -
// current emotional state / received state / probability next state 
// THIS IS A TEST RIGHT NOW - THIS DATA IS GENERATED BY A PROCESSING SKETCH,
// do not change by hand...

const prog_uchar ExternalStateMap[] PROGMEM = {
5,0,0,2,0,0,0,2,1,0,0,0,4,3,0,0,3,0,0,0,0,0,0,2,3,0,3,2,0,0,0,0,0,2,0,2,2,2,0,0,0,2,0,0,0,0,3,4,0,3,0,0,0,0,0,2,2,1,0,1,2,0,1,1,0,0,2,2,2,0,2,0,0,0,2,0,0,0,0,0,0,3,4,0,3,0,0,0,0,0,3,0,4,0,0,0,3,0,0,0,5,5,0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,3,2,2,0,0,0,0,0,3,0,0,0,4,3,3,0,0,0,0,0,0,0,0,3,4,0,0,3,0,0,0,0,0,0,3,0,4,0,0,0,0,3,0,0,0,3,4,0,3,0,0,0,0,0,0,2,2,1,0,1,2,0,1,1,0,0,2,2,2,0,2,0,0,0,2,0,0,2,0,3,0,3,2,0,0,0,0,0,0,2,2,0,3,0,0,0,3,0,0,0,5,5,0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0,4,3,0,3,0,0,0,0,0,0,0,0,3,4,3,0,0,0,0,0,0,2,1,3,0,1,1,0,1,1,0,0,0,0,3,0,3,0,0,0,4,0,0,0,0,5,0,5,0,0,0,0,0,0,0,0,3,0,3,4,0,0,0,0,0,0,0,3,0,3,0,0,0,4,0,0,0,4,3,0,3,0,0,0,0,0,0,0,0,3,0,3,0,0,0,4,0,0,0,4,3,0,3,0,0,0,0,0,0,0,3,3,0,4,0,0,0,0,0,0,3,2,2,3,0,0,0,0,0,0,0,0,3,0,3,0,0,0,0,4,0,0,0,2,2,0,3,3,0,0,0,0,0,0,0,3,4,0,0,0,0,3,0,0,0,3,3,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,0,2,0,0,0,2,0,0,4,0,0,0,0,3,0,3,0,0,0,0,0,3,0,3,0,0,0,4,0,0,0,2,2,3,0,3,0,0,0,0,0,0,3,3,0,0,4,0,0,0,0,0,0,0,5,0,5,0,0,0,0,0,0,0,5,0,0,5,0,0,0,0,0,0,0,0,3,0,4,0,0,0,3,0,0,0,0,3,4,3,0,0,0,0,0,0,0,0,5,0,5,0,0,0,0,0,0,0,0,3,0,4,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,5,0,0,0,0,0,0,0,0,5,0,5,0,0,0,0,0,0,0,4,3,0,3,0,0,0,0,0,0,0,4,3,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,3,3,0,0,0,0,0,0,0,4,3,0,0,3,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,5,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,3,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0,4,3,0,0,3,0,0,0,0,0,0,5,0,0,5,0,0,0,0,0,0,0,3,3,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,5,0,0,0,5,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,5,0,0,0,0,0,5,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,3,3,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,2,0,0,3,2,0,0,0,0,0,0,0,0,0,0,10,0,0,0,3,0,3,0,0,0,0,4,0,0,0,5,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,10};

unsigned int EmotionStateTo3DIndex(EmotionState i, EmotionState j, EmotionState k)
{
  unsigned int ii = (unsigned int)(i);
  unsigned int jj = (unsigned int)(j);
  unsigned int kk = (unsigned int) (k); 
  return (ii*NUM_EMOTIONS*NUM_EMOTIONS) + (jj*NUM_EMOTIONS) + kk;
}
  
  

EmotionState updateExternalEmotionalState(EmotionState currentState, EmotionState receivedState )
{
  float r = random(10000)/10000.0f;
  float sum = 0;
  EmotionState index = HAPPY; // start at first state

  // For debugging:
  Serial.println("r=");
  Serial.println(r);

  while ( index < EMOTIONS_END )
  {
    // read back a char 
    unsigned char myChar =  pgm_read_byte_near(ExternalStateMap + EmotionStateTo3DIndex(currentState,receivedState,index));
    float _emval = float(myChar)/10.0f;
    
    // For debugging:
    Serial.print("i,emval=");
    Serial.print(index);
    Serial.print(",");
    Serial.println(_emval);
    
    sum += _emval;

    if (sum < r)
      index++;
    else
      break;
      
    // if the states are sane, this shouldn't happen:
    if (index == EMOTIONS_END)
    {
      // default to HAPPY
      index = HAPPY;
      //Serial.println("*****Bad External state determined - map is probably corrupt somehow");
    }
  }

  return index;
}


#endif







