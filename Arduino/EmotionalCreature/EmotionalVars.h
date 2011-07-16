/*
 * These are definitions of the emotion variables for the system
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

#ifndef _EMOS_
#define _EMOS_

#define NUM_EMOTIONS 11  

enum EmotionState
{ 
  HAPPY, SAD, ANGRY, BORED, DISGUSTED, SURPRISED,
  HUNGRY, HORNY, ANTISOCIAL, DYING, DEAD, EMOTIONS_END 
}; 
 
inline void operator++(EmotionState& eVal, int)  
{ 
    eVal = EmotionState(eVal+1); 
} 

inline void operator--(EmotionState& eVal) 
{ 
    eVal = EmotionState(eVal-1); 
}  


 /*
  * THIS MAKES IT TOO BIG
  
typedef byte EmotionState ; 
 
 EmotionState HAPPY = 0;
 EmotionState SAD = 1;
 EmotionState ANGRY = 2;
 EmotionState BORED = 3;
 EmotionState DISGUSTED = 4;
 EmotionState SURPRISED = 5;
 EmotionState HUNGRY = 6;
 EmotionState HORNY = 7;
 EmotionState ANTISOCIAL = 8;
 EmotionState DYING = 9;
 EmotionState DEAD = 10;
 EmotionState EMOTIONS_END = 11; 
 */
#endif
