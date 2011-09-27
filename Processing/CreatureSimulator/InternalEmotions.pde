
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
 

float InternalStateMap[][] = {
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

  /*DISGUST*/
 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 /*SURPRISE*/
 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

  /*HUNGRY*/
 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 /*HORNY*/
 { 0.5/*HAPPY*/, 0.0/*SAD*/,
  0.2/*ANGRY*/, 0.1/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 
  0.05/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 /*ANTISOC*/
 { 0.0/*HAPPY*/, 0.0/*SAD*/,
  0.1/*ANGRY*/, 0.2/*BORED*/, 0.1/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.2/*HORNY*/, 0.4/*ANTISOC*/, 0.05/*DYING*/, 0.0/*DEAD*/ },  

 /*DYING*/
 { 0.0/*HAPPY*/, 0.0/*SAD*/,
  0.0/*ANGRY*/, 0.0/*BORED*/, 0.0/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.3/*ANTISOC*/, 0.5/*DYING*/, 0.2/*DEAD*/ },  

 /*DEAD*/
 { 0.0/*HAPPY*/, 0.0/*SAD*/,
  0.0/*ANGRY*/, 0.0/*BORED*/, 0.0/*DISGUST*/, 0.0/*SURPRISE*/,
  0.0/*HUNGRY*/, 0.0/*HORNY*/, 0.0/*ANTISOC*/, 0.0/*DYING*/, 0.0/*DEAD*/ }  
};


int updateInternalEmotionalState(int currentState)
{
  float r = random(10000)/10000.0f;
  float sum = 0.0f;
  int index = HAPPY;
  
  // For debugging:
  //Serial.print("r=");
  //Serial.println(r);
  
  while (sum<r && index != EMOTIONS_END)
  {
    float _emval = InternalStateMap[currentState][index];
    
    // For debugging:
//    Serial.print("i,emval=");
//    Serial.print(index);
//    Serial.print(",");
//    Serial.println(_emval);
    index++;
    
    // skip 0 states
    if (_emval == 0.0f) continue;
    sum += _emval;
    
  }
  return index;
}
