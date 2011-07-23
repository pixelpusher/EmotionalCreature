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
 */
 
#include <Ports.h>
#include <RF12.h> // needed to avoid a linker error :(
#include "EmotionalVars.h"
#include "ExternalEmotions.h"
#include "InternalEmotions.h"
#include <avr/pgmspace.h>

void setup()
{
  Serial.begin(38400);

    Serial.print("Internal Happy/Happy: ");
    Serial.println(InternalStateMap[HAPPY][HAPPY]);
  
  
  EmotionState emstate = updateInternalEmotionalState(HAPPY);
  Serial.print("New state:");
  Serial.println(emstate);
  delay(1500);
  
  Serial.print("External Happy/angry/sad: ");
  unsigned int index = EmotionStateTo3DIndex(HAPPY,ANGRY,SAD);
  Serial.print(index);
  char myChar =  pgm_read_byte_near(ExternalStateMap + index);
  Serial.println(myChar,BYTE);
  myChar =  pgm_read_byte_near(ExternalStateMap + 1);
  Serial.println(myChar);
  Serial.println("DONE");
  
  emstate = updateExternalEmotionalState(HAPPY, HAPPY );
  Serial.print("New state:");
  Serial.println(emstate);
}

void loop()
{
  
}
