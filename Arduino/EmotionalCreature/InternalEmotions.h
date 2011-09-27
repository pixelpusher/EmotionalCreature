
/*
 * These are definitions of the internal emotions (that represent the internal state of the creature,
 * and update only under their own influence) - variables and functions for the system.
 *
 * NOTE: The array of internal emotion probabilities is edited by hand
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
 
#ifndef _EMOS_INTERNAL_
#define _EMOS_INTERNAL_

#include "EmotionalVars.h"

float InternalStateMap[NUM_EMOTIONS][NUM_EMOTIONS] = {
  /*HAPPY*/
 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },

  /*SAD*/
 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

  /*ANGRY*/ 
 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 /*BORED*/
 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ }  

};


EmotionState updateInternalEmotionalState(EmotionState currentState)
{
  float r = random(10000)/10000.0f;
  float sum = 0.0f;
  EmotionState index = HAPPY;
  
  // For debugging:
  //Serial.print("r=");
  //Serial.println(r);
  
  while (  index < EMOTIONS_END )
  {
    float _emval = InternalStateMap[currentState][index];
    
    // For debugging:
    
//    print("r=" + r + "::");
//    print("i,emval=");
//    print(states[index]);
//    print(",");
//    println(_emval);  
   
    sum += _emval;
    
    if (sum < r)
      index++;
    else
      break;
  }
  
  return index;
}

#endif
