/*
 * This code generates the interleaved array of external emotional state responses
 * that should be pasted into the EmotionalCreature arduino sketch. 
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
 
 
 * HACKING INSTRUCTIONS:
 * The way you edit this beast is to look at the Emotions map so you can see which states (happy, sad, etc) can affect other states (happy, sad, etc).
 *
 * For example:
 *
 * ExternalStateMap3D[HAPPY][SAD][ANGRY] = 5;
 *
 * means that if the creature is HAPPY and looks at a SAD creature (e.g. receives a SAD broadcast via infrared) than the odds that it becomes angry are 5/10.
 *
 * If the creature CANNOT go from one state to another, the odds are 0:
 *
 * ExternalStateMap3D[HAPPY][SAD][HAPPY] = 0;
 *
 * This means that a HAPPY creature receiving a SAD can't stay HAPPY.
 *
 * All odds are out of 10 - so all odds for a state MUST add up to 10 and not more or less!
 *
 * So all the 11 entries for:
 * ExternalStateMap3D[HAPPY][SAD][*]
 * must add to 10.  Or else everything goes haywire.  (TODO - add a check for that in the code to warn us...)
 */


final int HAPPY=0;
final int SAD = 1;
final int ANGRY = 2;
final int BORED = 3;
final int DISGUSTED = 4;
final int SURPRISED = 5;
final int HUNGRY = 6;
final int HORNY = 7;
final int ANTISOCIAL = 8;
final int DYING=9;
final int DEAD = 10;
final int EMOTIONS_END = 11; 


String[] states = {
  "HAPPY", "SAD", "ANGRY", "BORED", "DISGUSTED", "SURPRISED", "HUNGRY", "HORNY", 
  "ANTISOCIAL", "DYING", "DEAD"
};


color[] stateColors = new color[states.length];

//List<Integer> possibleStates[11];
int maxStates = states.length*states.length*states.length;
int ExternalStateMap3D[][][] = new int[states.length][states.length][states.length];
int ExternalStateMap[] = new int[maxStates];


//
// This is used on the Arduio side, usually
//
int EmotionStateTo3DIndex(int ii, int jj, int kk)
{
  return (ii*EMOTIONS_END*EMOTIONS_END) + (jj*EMOTIONS_END) + kk;
}


//
// Sanity check on the state map!
// 
boolean testExternalStateMap()
{
  boolean result = true;

  for (int i=0; i<EMOTIONS_END; ++i)
  {
    for (int j=0; j<EMOTIONS_END; ++j)
    {
      int stateSum = 0;

      for (int k=0; k<EMOTIONS_END; ++k)
      {
        stateSum += ExternalStateMap3D[i][j][k];
      }

      if (stateSum != 10)
      {
        result = result && false;
        // ERROR!!
        println("Bad external state map for " + states[i] + ":" + states[j] + " :: " + stateSum + " (should be " + 10 + ")");
      }
    }
  }

  return result;
}


//
// Determine the updated emotional state given the current state of the creature and a broadcasted state from another
//

int updateExternalEmotionalState(int currentState, int receivedState )
{
  println("State change from " + currentState + " " + receivedState );
  println("State change from " + states[currentState] + " " + states[receivedState] );

  float r = random(10000)/10000.0f;
  float sum = 0;
  int index = HAPPY; // start at first state

  // For debugging:
  println("r=");
  println(r);

  while ( index < EMOTIONS_END )
  {
    // read back a char
    float stateProb = ExternalStateMap3D[currentState][receivedState][index];

    float _emval = stateProb/10.0f;

    // For debugging:
    print("i,emval=");
    print(index);
    print(",");
    println(_emval);

    sum += _emval;

    if (sum < r)
      ++index;
    else
      break;
  }

  // if the states are sane, this shouldn't happen:
  if (index == EMOTIONS_END)
  {
    // default to HAPPY
    index = HAPPY;
    println("*****Bad External state determined - map is probably corrupt somehow");
  }

  return index;
}


void setupStates()
{
  //far  all which aren't 0 :


  stateColors[HAPPY] = #ffff00;
  stateColors[SAD] = #0000ff;
  stateColors[ANGRY] = #ff0000;
  stateColors[BORED] = #bcbcbc;
  stateColors[DISGUSTED] = #3B8940;
  stateColors[SURPRISED] = #C3D17A;
  stateColors[HUNGRY] = #A0303F;
  stateColors[HORNY] = #D83986;
  stateColors[ANTISOCIAL] = #016408;
  stateColors[DYING] = #6C433C;
  stateColors[DEAD] = #000000;


  //HAPPY
  //Serial.println("HAPPY:");
  ExternalStateMap3D[HAPPY][HAPPY][HAPPY] = 5;
  ExternalStateMap3D[HAPPY][HAPPY][SAD] = 0;
  ExternalStateMap3D[HAPPY][HAPPY][ANGRY] = 0;
  ExternalStateMap3D[HAPPY][HAPPY][BORED] = 2;
  ExternalStateMap3D[HAPPY][HAPPY][DISGUSTED] = 0;
  ExternalStateMap3D[HAPPY][HAPPY][SURPRISED] = 0;
  ExternalStateMap3D[HAPPY][HAPPY][HORNY] = 2;
  ExternalStateMap3D[HAPPY][HAPPY][ANTISOCIAL] = 1;
  ExternalStateMap3D[HAPPY][HAPPY][DYING] = 0;
  ExternalStateMap3D[HAPPY][HAPPY][DEAD] = 0;

  ExternalStateMap3D[HAPPY][SAD][HAPPY] = 0;
  ExternalStateMap3D[HAPPY][SAD][SAD] = 4;
  ExternalStateMap3D[HAPPY][SAD][ANGRY] = 3;
  ExternalStateMap3D[HAPPY][SAD][BORED] = 0;
  ExternalStateMap3D[HAPPY][SAD][DISGUSTED] = 0;
  ExternalStateMap3D[HAPPY][SAD][SURPRISED] = 3;
  ExternalStateMap3D[HAPPY][SAD][HORNY] = 0;
  ExternalStateMap3D[HAPPY][SAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[HAPPY][SAD][DYING] = 0;
  ExternalStateMap3D[HAPPY][SAD][DEAD] = 0;

  ExternalStateMap3D[HAPPY][ANGRY][HAPPY] = 0;
  ExternalStateMap3D[HAPPY][ANGRY][SAD] = 2;
  ExternalStateMap3D[HAPPY][ANGRY][ANGRY] = 3;
  ExternalStateMap3D[HAPPY][ANGRY][BORED] = 0;
  ExternalStateMap3D[HAPPY][ANGRY][DISGUSTED] = 3;
  ExternalStateMap3D[HAPPY][ANGRY][SURPRISED] = 2;
  ExternalStateMap3D[HAPPY][ANGRY][HORNY] = 0;
  ExternalStateMap3D[HAPPY][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap3D[HAPPY][ANGRY][DYING] = 0;
  ExternalStateMap3D[HAPPY][ANGRY][DEAD] = 0;

  ExternalStateMap3D[HAPPY][BORED][HAPPY] = 2;
  ExternalStateMap3D[HAPPY][BORED][SAD] = 0;
  ExternalStateMap3D[HAPPY][BORED][ANGRY] = 2;
  ExternalStateMap3D[HAPPY][BORED][BORED] = 2;
  ExternalStateMap3D[HAPPY][BORED][DISGUSTED] = 2;
  ExternalStateMap3D[HAPPY][BORED][SURPRISED] = 0;
  ExternalStateMap3D[HAPPY][BORED][HORNY] = 0;
  ExternalStateMap3D[HAPPY][BORED][ANTISOCIAL] = 2;
  ExternalStateMap3D[HAPPY][BORED][DYING] = 0;
  ExternalStateMap3D[HAPPY][BORED][DEAD] = 0;

  ExternalStateMap3D[HAPPY][DISGUSTED][HAPPY] = 0;
  ExternalStateMap3D[HAPPY][DISGUSTED][SAD] = 0;
  ExternalStateMap3D[HAPPY][DISGUSTED][ANGRY] = 3;
  ExternalStateMap3D[HAPPY][DISGUSTED][BORED] = 4;
  ExternalStateMap3D[HAPPY][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap3D[HAPPY][DISGUSTED][SURPRISED] = 3;
  ExternalStateMap3D[HAPPY][DISGUSTED][HORNY] = 0;
  ExternalStateMap3D[HAPPY][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap3D[HAPPY][DISGUSTED][DYING] = 0;
  ExternalStateMap3D[HAPPY][DISGUSTED][DEAD] = 0;

  ExternalStateMap3D[HAPPY][SURPRISED][HAPPY] = 2;
  ExternalStateMap3D[HAPPY][SURPRISED][SAD] = 2;
  ExternalStateMap3D[HAPPY][SURPRISED][ANGRY] = 1;
  ExternalStateMap3D[HAPPY][SURPRISED][BORED] = 0;
  ExternalStateMap3D[HAPPY][SURPRISED][DISGUSTED] = 1;
  ExternalStateMap3D[HAPPY][SURPRISED][SURPRISED] = 2;
  ExternalStateMap3D[HAPPY][SURPRISED][HORNY] = 1;
  ExternalStateMap3D[HAPPY][SURPRISED][ANTISOCIAL] = 1;
  ExternalStateMap3D[HAPPY][SURPRISED][DYING] = 0;
  ExternalStateMap3D[HAPPY][SURPRISED][DEAD] = 0;

  // needs fixing
  ExternalStateMap3D[HAPPY][HUNGRY][HAPPY] = 2;
  ExternalStateMap3D[HAPPY][HUNGRY][SAD] = 2;
  ExternalStateMap3D[HAPPY][HUNGRY][ANGRY] = 2;
  ExternalStateMap3D[HAPPY][HUNGRY][BORED] = 0;
  ExternalStateMap3D[HAPPY][HUNGRY][DISGUSTED] = 2;
  ExternalStateMap3D[HAPPY][HUNGRY][SURPRISED] = 0;
  ExternalStateMap3D[HAPPY][HUNGRY][HORNY] = 0;
  ExternalStateMap3D[HAPPY][HUNGRY][ANTISOCIAL] = 2;
  ExternalStateMap3D[HAPPY][HUNGRY][DYING] = 0;
  ExternalStateMap3D[HAPPY][HUNGRY][DEAD] = 0;

  ExternalStateMap3D[HAPPY][HORNY][HAPPY] = 0;
  ExternalStateMap3D[HAPPY][HORNY][SAD] = 0;
  ExternalStateMap3D[HAPPY][HORNY][ANGRY] = 0;
  ExternalStateMap3D[HAPPY][HORNY][BORED] = 0;
  ExternalStateMap3D[HAPPY][HORNY][DISGUSTED] = 3;
  ExternalStateMap3D[HAPPY][HORNY][SURPRISED] = 4;
  ExternalStateMap3D[HAPPY][HORNY][HORNY] = 3;
  ExternalStateMap3D[HAPPY][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap3D[HAPPY][HORNY][DYING] = 0;
  ExternalStateMap3D[HAPPY][HORNY][DEAD] = 0;

  ExternalStateMap3D[HAPPY][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap3D[HAPPY][ANTISOCIAL][SAD] = 0;
  ExternalStateMap3D[HAPPY][ANTISOCIAL][ANGRY] = 3;
  ExternalStateMap3D[HAPPY][ANTISOCIAL][BORED] = 0;
  ExternalStateMap3D[HAPPY][ANTISOCIAL][DISGUSTED] = 4;
  ExternalStateMap3D[HAPPY][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap3D[HAPPY][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap3D[HAPPY][ANTISOCIAL][ANTISOCIAL] = 3;
  ExternalStateMap3D[HAPPY][ANTISOCIAL][DYING] = 0;
  ExternalStateMap3D[HAPPY][ANTISOCIAL][DEAD] = 0;

  ExternalStateMap3D[HAPPY][DYING][HAPPY] = 0;
  ExternalStateMap3D[HAPPY][DYING][SAD] = 5;
  ExternalStateMap3D[HAPPY][DYING][ANGRY] = 5;
  ExternalStateMap3D[HAPPY][DYING][BORED] = 0;
  ExternalStateMap3D[HAPPY][DYING][DISGUSTED] = 0;
  ExternalStateMap3D[HAPPY][DYING][SURPRISED] = 0;
  ExternalStateMap3D[HAPPY][DYING][HORNY] = 0;
  ExternalStateMap3D[HAPPY][DYING][ANTISOCIAL] = 0;
  ExternalStateMap3D[HAPPY][DYING][DYING] = 0;
  ExternalStateMap3D[HAPPY][DYING][DEAD] = 0;

  ExternalStateMap3D[HAPPY][DEAD][HAPPY] = 0;
  ExternalStateMap3D[HAPPY][DEAD][SAD] = 5;
  ExternalStateMap3D[HAPPY][DEAD][ANGRY] = 5;
  ExternalStateMap3D[HAPPY][DEAD][BORED] = 0;
  ExternalStateMap3D[HAPPY][DEAD][DISGUSTED] = 0;
  ExternalStateMap3D[HAPPY][DEAD][SURPRISED] = 0;
  ExternalStateMap3D[HAPPY][DEAD][HORNY] = 0;
  ExternalStateMap3D[HAPPY][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[HAPPY][DEAD][DYING] = 0;
  ExternalStateMap3D[HAPPY][DEAD][DEAD] = 0;


  //SAD

  ExternalStateMap3D[SAD][HAPPY][HAPPY] = 3;
  ExternalStateMap3D[SAD][HAPPY][SAD] = 2;
  ExternalStateMap3D[SAD][HAPPY][ANGRY] = 2;
  ExternalStateMap3D[SAD][HAPPY][BORED] = 0;
  ExternalStateMap3D[SAD][HAPPY][DISGUSTED] = 0;
  ExternalStateMap3D[SAD][HAPPY][SURPRISED] = 0;
  ExternalStateMap3D[SAD][HAPPY][HORNY] = 0;
  ExternalStateMap3D[SAD][HAPPY][ANTISOCIAL] = 3;
  ExternalStateMap3D[SAD][HAPPY][DYING] = 0;
  ExternalStateMap3D[SAD][HAPPY][DEAD] = 0;

  ExternalStateMap3D[SAD][SAD][HAPPY] = 0;
  ExternalStateMap3D[SAD][SAD][SAD] = 4;
  ExternalStateMap3D[SAD][SAD][ANGRY] = 3;
  ExternalStateMap3D[SAD][SAD][BORED] = 3;
  ExternalStateMap3D[SAD][SAD][DISGUSTED] = 0;
  ExternalStateMap3D[SAD][SAD][SURPRISED] = 0;
  ExternalStateMap3D[SAD][SAD][HORNY] = 0;
  ExternalStateMap3D[SAD][SAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[SAD][SAD][DYING] = 0;
  ExternalStateMap3D[SAD][SAD][DEAD] = 0;

  ExternalStateMap3D[SAD][ANGRY][HAPPY] = 0;
  ExternalStateMap3D[SAD][ANGRY][SAD] = 3;
  ExternalStateMap3D[SAD][ANGRY][ANGRY] = 4;
  ExternalStateMap3D[SAD][ANGRY][BORED] = 0;
  ExternalStateMap3D[SAD][ANGRY][DISGUSTED] = 0;
  ExternalStateMap3D[SAD][ANGRY][SURPRISED] = 3;
  ExternalStateMap3D[SAD][ANGRY][HORNY] = 0;
  ExternalStateMap3D[SAD][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap3D[SAD][ANGRY][DYING] = 0;
  ExternalStateMap3D[SAD][ANGRY][DEAD] = 0;

  ExternalStateMap3D[SAD][BORED][HAPPY] = 0;
  ExternalStateMap3D[SAD][BORED][SAD] = 3;
  ExternalStateMap3D[SAD][BORED][ANGRY] = 0;
  ExternalStateMap3D[SAD][BORED][BORED] = 4;
  ExternalStateMap3D[SAD][BORED][DISGUSTED] = 0;
  ExternalStateMap3D[SAD][BORED][SURPRISED] = 0;
  ExternalStateMap3D[SAD][BORED][HORNY] = 0;
  ExternalStateMap3D[SAD][BORED][ANTISOCIAL] = 3;
  ExternalStateMap3D[SAD][BORED][DYING] = 0;
  ExternalStateMap3D[SAD][BORED][DEAD] = 0;

  ExternalStateMap3D[SAD][DISGUSTED][HAPPY] = 0;
  ExternalStateMap3D[SAD][DISGUSTED][SAD] = 3;
  ExternalStateMap3D[SAD][DISGUSTED][ANGRY] = 4;
  ExternalStateMap3D[SAD][DISGUSTED][BORED] = 0;
  ExternalStateMap3D[SAD][DISGUSTED][DISGUSTED] = 3;
  ExternalStateMap3D[SAD][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap3D[SAD][DISGUSTED][HORNY] = 0;
  ExternalStateMap3D[SAD][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap3D[SAD][DISGUSTED][DYING] = 0;
  ExternalStateMap3D[SAD][DISGUSTED][DEAD] = 0;

  // needs fixing
  ExternalStateMap3D[SAD][SURPRISED][HAPPY] = 2;
  ExternalStateMap3D[SAD][SURPRISED][SAD] = 2;
  ExternalStateMap3D[SAD][SURPRISED][ANGRY] = 1;
  ExternalStateMap3D[SAD][SURPRISED][BORED] = 0;
  ExternalStateMap3D[SAD][SURPRISED][DISGUSTED] = 1;
  ExternalStateMap3D[SAD][SURPRISED][SURPRISED] = 2;
  ExternalStateMap3D[SAD][SURPRISED][HORNY] = 1;
  ExternalStateMap3D[SAD][SURPRISED][ANTISOCIAL] = 1;
  ExternalStateMap3D[SAD][SURPRISED][DYING] = 0;
  ExternalStateMap3D[SAD][SURPRISED][DEAD] = 0;

  // needs fixing
  ExternalStateMap3D[SAD][HUNGRY][HAPPY] = 2;
  ExternalStateMap3D[SAD][HUNGRY][SAD] = 2;
  ExternalStateMap3D[SAD][HUNGRY][ANGRY] = 2;
  ExternalStateMap3D[SAD][HUNGRY][BORED] = 0;
  ExternalStateMap3D[SAD][HUNGRY][DISGUSTED] = 2;
  ExternalStateMap3D[SAD][HUNGRY][SURPRISED] = 0;
  ExternalStateMap3D[SAD][HUNGRY][HORNY] = 0;
  ExternalStateMap3D[SAD][HUNGRY][ANTISOCIAL] = 2;
  ExternalStateMap3D[SAD][HUNGRY][DYING] = 0;
  ExternalStateMap3D[SAD][HUNGRY][DEAD] = 0;

  ExternalStateMap3D[SAD][HORNY][HAPPY] = 2;
  ExternalStateMap3D[SAD][HORNY][SAD] = 0;
  ExternalStateMap3D[SAD][HORNY][ANGRY] = 3;
  ExternalStateMap3D[SAD][HORNY][BORED] = 0;
  ExternalStateMap3D[SAD][HORNY][DISGUSTED] = 3;
  ExternalStateMap3D[SAD][HORNY][SURPRISED] = 2;
  ExternalStateMap3D[SAD][HORNY][HORNY] = 0;
  ExternalStateMap3D[SAD][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap3D[SAD][HORNY][DYING] = 0;
  ExternalStateMap3D[SAD][HORNY][DEAD] = 0;

  ExternalStateMap3D[SAD][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap3D[SAD][ANTISOCIAL][SAD] = 2;
  ExternalStateMap3D[SAD][ANTISOCIAL][ANGRY] = 2;
  ExternalStateMap3D[SAD][ANTISOCIAL][BORED] = 0;
  ExternalStateMap3D[SAD][ANTISOCIAL][DISGUSTED] = 3;
  ExternalStateMap3D[SAD][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap3D[SAD][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap3D[SAD][ANTISOCIAL][ANTISOCIAL] = 3;
  ExternalStateMap3D[SAD][ANTISOCIAL][DYING] = 0;
  ExternalStateMap3D[SAD][ANTISOCIAL][DEAD] = 0;

  ExternalStateMap3D[SAD][DYING][HAPPY] = 0;
  ExternalStateMap3D[SAD][DYING][SAD] = 5;
  ExternalStateMap3D[SAD][DYING][ANGRY] = 5;
  ExternalStateMap3D[SAD][DYING][BORED] = 0;
  ExternalStateMap3D[SAD][DYING][DISGUSTED] = 0;
  ExternalStateMap3D[SAD][DYING][SURPRISED] = 0;
  ExternalStateMap3D[SAD][DYING][HORNY] = 0;
  ExternalStateMap3D[SAD][DYING][ANTISOCIAL] = 0;
  ExternalStateMap3D[SAD][DYING][DYING] = 0;
  ExternalStateMap3D[SAD][DYING][DEAD] = 0;

  ExternalStateMap3D[SAD][DEAD][HAPPY] = 0;
  ExternalStateMap3D[SAD][DEAD][SAD] = 5;
  ExternalStateMap3D[SAD][DEAD][ANGRY] = 5;
  ExternalStateMap3D[SAD][DEAD][BORED] = 0;
  ExternalStateMap3D[SAD][DEAD][DISGUSTED] = 0;
  ExternalStateMap3D[SAD][DEAD][SURPRISED] = 0;
  ExternalStateMap3D[SAD][DEAD][HORNY] = 0;
  ExternalStateMap3D[SAD][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[SAD][DEAD][DYING] = 0;
  ExternalStateMap3D[SAD][DEAD][DEAD] = 0;



  //ANGRY

  ExternalStateMap3D[ANGRY][HAPPY][HAPPY] = 0;
  ExternalStateMap3D[ANGRY][HAPPY][SAD] = 4;
  ExternalStateMap3D[ANGRY][HAPPY][ANGRY] = 3;
  ExternalStateMap3D[ANGRY][HAPPY][BORED] = 0;
  ExternalStateMap3D[ANGRY][HAPPY][DISGUSTED] = 3;
  ExternalStateMap3D[ANGRY][HAPPY][SURPRISED] = 0;
  ExternalStateMap3D[ANGRY][HAPPY][HORNY] = 0;
  ExternalStateMap3D[ANGRY][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap3D[ANGRY][HAPPY][DYING] = 0;
  ExternalStateMap3D[ANGRY][HAPPY][DEAD] = 0;

  ExternalStateMap3D[ANGRY][SAD][HAPPY] = 0;
  ExternalStateMap3D[ANGRY][SAD][SAD] = 0;
  ExternalStateMap3D[ANGRY][SAD][ANGRY] = 3;
  ExternalStateMap3D[ANGRY][SAD][BORED] = 4;
  ExternalStateMap3D[ANGRY][SAD][DISGUSTED] = 3;
  ExternalStateMap3D[ANGRY][SAD][SURPRISED] = 0;
  ExternalStateMap3D[ANGRY][SAD][HORNY] = 0;
  ExternalStateMap3D[ANGRY][SAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[ANGRY][SAD][DYING] = 0;
  ExternalStateMap3D[ANGRY][SAD][DEAD] = 0;

  ExternalStateMap3D[ANGRY][ANGRY][HAPPY] = 2;
  ExternalStateMap3D[ANGRY][ANGRY][SAD] = 1;
  ExternalStateMap3D[ANGRY][ANGRY][ANGRY] = 3;
  ExternalStateMap3D[ANGRY][ANGRY][BORED] = 0;
  ExternalStateMap3D[ANGRY][ANGRY][DISGUSTED] = 1;
  ExternalStateMap3D[ANGRY][ANGRY][SURPRISED] = 1;
  ExternalStateMap3D[ANGRY][ANGRY][HORNY] = 1;
  ExternalStateMap3D[ANGRY][ANGRY][ANTISOCIAL] = 1;
  ExternalStateMap3D[ANGRY][ANGRY][DYING] = 0;
  ExternalStateMap3D[ANGRY][ANGRY][DEAD] = 0;

  ExternalStateMap3D[ANGRY][BORED][HAPPY] = 0;
  ExternalStateMap3D[ANGRY][BORED][SAD] = 0;
  ExternalStateMap3D[ANGRY][BORED][ANGRY] = 3;
  ExternalStateMap3D[ANGRY][BORED][BORED] = 0;
  ExternalStateMap3D[ANGRY][BORED][DISGUSTED] = 3;
  ExternalStateMap3D[ANGRY][BORED][SURPRISED] = 0;
  ExternalStateMap3D[ANGRY][BORED][HORNY] = 0;
  ExternalStateMap3D[ANGRY][BORED][ANTISOCIAL] = 4;
  ExternalStateMap3D[ANGRY][BORED][DYING] = 0;
  ExternalStateMap3D[ANGRY][BORED][DEAD] = 0;

  ExternalStateMap3D[ANGRY][DISGUSTED][HAPPY] = 0;
  ExternalStateMap3D[ANGRY][DISGUSTED][SAD] = 0;
  ExternalStateMap3D[ANGRY][DISGUSTED][ANGRY] = 5;
  ExternalStateMap3D[ANGRY][DISGUSTED][BORED] = 0;
  ExternalStateMap3D[ANGRY][DISGUSTED][DISGUSTED] = 5;
  ExternalStateMap3D[ANGRY][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap3D[ANGRY][DISGUSTED][HORNY] = 0;
  ExternalStateMap3D[ANGRY][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap3D[ANGRY][DISGUSTED][DYING] = 0;
  ExternalStateMap3D[ANGRY][DISGUSTED][DEAD] = 0;

  ExternalStateMap3D[ANGRY][SURPRISED][HAPPY] = 0;
  ExternalStateMap3D[ANGRY][SURPRISED][SAD] = 0;
  ExternalStateMap3D[ANGRY][SURPRISED][ANGRY] = 3;
  ExternalStateMap3D[ANGRY][SURPRISED][BORED] = 0;
  ExternalStateMap3D[ANGRY][SURPRISED][DISGUSTED] = 3;
  ExternalStateMap3D[ANGRY][SURPRISED][SURPRISED] = 4;
  ExternalStateMap3D[ANGRY][SURPRISED][HORNY] = 0;
  ExternalStateMap3D[ANGRY][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap3D[ANGRY][SURPRISED][DYING] = 0;
  ExternalStateMap3D[ANGRY][SURPRISED][DEAD] = 0;

  // needs fixing
  ExternalStateMap3D[ANGRY][HUNGRY][HAPPY] = 0;
  ExternalStateMap3D[ANGRY][HUNGRY][SAD] = 0;
  ExternalStateMap3D[ANGRY][HUNGRY][ANGRY] = 3;
  ExternalStateMap3D[ANGRY][HUNGRY][BORED] = 0;
  ExternalStateMap3D[ANGRY][HUNGRY][DISGUSTED] = 3;
  ExternalStateMap3D[ANGRY][HUNGRY][SURPRISED] = 0;
  ExternalStateMap3D[ANGRY][HUNGRY][HORNY] = 0;
  ExternalStateMap3D[ANGRY][HUNGRY][ANTISOCIAL] = 4;
  ExternalStateMap3D[ANGRY][HUNGRY][DYING] = 0;
  ExternalStateMap3D[ANGRY][HUNGRY][DEAD] = 0;

  ExternalStateMap3D[ANGRY][HORNY][HAPPY] = 0;
  ExternalStateMap3D[ANGRY][HORNY][SAD] = 4;
  ExternalStateMap3D[ANGRY][HORNY][ANGRY] = 3;
  ExternalStateMap3D[ANGRY][HORNY][BORED] = 0;
  ExternalStateMap3D[ANGRY][HORNY][DISGUSTED] = 3;
  ExternalStateMap3D[ANGRY][HORNY][SURPRISED] = 0;
  ExternalStateMap3D[ANGRY][HORNY][HORNY] = 0;
  ExternalStateMap3D[ANGRY][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap3D[ANGRY][HORNY][DYING] = 0;
  ExternalStateMap3D[ANGRY][HORNY][DEAD] = 0;

  ExternalStateMap3D[ANGRY][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap3D[ANGRY][ANTISOCIAL][SAD] = 0;
  ExternalStateMap3D[ANGRY][ANTISOCIAL][ANGRY] = 3;
  ExternalStateMap3D[ANGRY][ANTISOCIAL][BORED] = 0;
  ExternalStateMap3D[ANGRY][ANTISOCIAL][DISGUSTED] = 3;
  ExternalStateMap3D[ANGRY][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap3D[ANGRY][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap3D[ANGRY][ANTISOCIAL][ANTISOCIAL] = 4;
  ExternalStateMap3D[ANGRY][ANTISOCIAL][DYING] = 0;
  ExternalStateMap3D[ANGRY][ANTISOCIAL][DEAD] = 0;

  ExternalStateMap3D[ANGRY][DYING][HAPPY] = 0;
  ExternalStateMap3D[ANGRY][DYING][SAD] = 4;
  ExternalStateMap3D[ANGRY][DYING][ANGRY] = 3;
  ExternalStateMap3D[ANGRY][DYING][BORED] = 0;
  ExternalStateMap3D[ANGRY][DYING][DISGUSTED] = 3;
  ExternalStateMap3D[ANGRY][DYING][SURPRISED] = 0;
  ExternalStateMap3D[ANGRY][DYING][HORNY] = 0;
  ExternalStateMap3D[ANGRY][DYING][ANTISOCIAL] = 0;
  ExternalStateMap3D[ANGRY][DYING][DYING] = 0;
  ExternalStateMap3D[ANGRY][DYING][DEAD] = 0;

  ExternalStateMap3D[ANGRY][DEAD][HAPPY] = 0;
  ExternalStateMap3D[ANGRY][DEAD][SAD] = 3;
  ExternalStateMap3D[ANGRY][DEAD][ANGRY] = 3;
  ExternalStateMap3D[ANGRY][DEAD][BORED] = 0;
  ExternalStateMap3D[ANGRY][DEAD][DISGUSTED] = 4;
  ExternalStateMap3D[ANGRY][DEAD][SURPRISED] = 0;
  ExternalStateMap3D[ANGRY][DEAD][HORNY] = 0;
  ExternalStateMap3D[ANGRY][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[ANGRY][DEAD][DYING] = 0;
  ExternalStateMap3D[ANGRY][DEAD][DEAD] = 0;


  //BORED

  ExternalStateMap3D[BORED][HAPPY][HAPPY] = 3;
  ExternalStateMap3D[BORED][HAPPY][SAD] = 2;
  ExternalStateMap3D[BORED][HAPPY][ANGRY] = 2;
  ExternalStateMap3D[BORED][HAPPY][BORED] = 3;
  ExternalStateMap3D[BORED][HAPPY][DISGUSTED] = 0;
  ExternalStateMap3D[BORED][HAPPY][SURPRISED] = 0;
  ExternalStateMap3D[BORED][HAPPY][HORNY] = 0;
  ExternalStateMap3D[BORED][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap3D[BORED][HAPPY][DYING] = 0;
  ExternalStateMap3D[BORED][HAPPY][DEAD] = 0;

  ExternalStateMap3D[BORED][SAD][HAPPY] = 0;
  ExternalStateMap3D[BORED][SAD][SAD] = 3;
  ExternalStateMap3D[BORED][SAD][ANGRY] = 0;
  ExternalStateMap3D[BORED][SAD][BORED] = 3;
  ExternalStateMap3D[BORED][SAD][DISGUSTED] = 0;
  ExternalStateMap3D[BORED][SAD][SURPRISED] = 0;
  ExternalStateMap3D[BORED][SAD][HORNY] = 0;
  ExternalStateMap3D[BORED][SAD][ANTISOCIAL] = 4;
  ExternalStateMap3D[BORED][SAD][DYING] = 0;
  ExternalStateMap3D[BORED][SAD][DEAD] = 0;

  ExternalStateMap3D[BORED][ANGRY][HAPPY] = 0;
  ExternalStateMap3D[BORED][ANGRY][SAD] = 2;
  ExternalStateMap3D[BORED][ANGRY][ANGRY] = 2;
  ExternalStateMap3D[BORED][ANGRY][BORED] = 0;
  ExternalStateMap3D[BORED][ANGRY][DISGUSTED] = 3;
  ExternalStateMap3D[BORED][ANGRY][SURPRISED] = 3;
  ExternalStateMap3D[BORED][ANGRY][HORNY] = 0;
  ExternalStateMap3D[BORED][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap3D[BORED][ANGRY][DYING] = 0;
  ExternalStateMap3D[BORED][ANGRY][DEAD] = 0;

  // needs fixing
  ExternalStateMap3D[BORED][HUNGRY][HAPPY] = 2;
  ExternalStateMap3D[BORED][HUNGRY][SAD] = 2;
  ExternalStateMap3D[BORED][HUNGRY][ANGRY] = 2;
  ExternalStateMap3D[BORED][HUNGRY][BORED] = 0;
  ExternalStateMap3D[BORED][HUNGRY][DISGUSTED] = 2;
  ExternalStateMap3D[BORED][HUNGRY][SURPRISED] = 0;
  ExternalStateMap3D[BORED][HUNGRY][HORNY] = 0;
  ExternalStateMap3D[BORED][HUNGRY][ANTISOCIAL] = 2;
  ExternalStateMap3D[BORED][HUNGRY][DYING] = 0;
  ExternalStateMap3D[BORED][HUNGRY][DEAD] = 0;

  ExternalStateMap3D[BORED][BORED][HAPPY] = 0;
  ExternalStateMap3D[BORED][BORED][SAD] = 0;
  ExternalStateMap3D[BORED][BORED][ANGRY] = 3;
  ExternalStateMap3D[BORED][BORED][BORED] = 4;
  ExternalStateMap3D[BORED][BORED][DISGUSTED] = 0;
  ExternalStateMap3D[BORED][BORED][SURPRISED] = 0;
  ExternalStateMap3D[BORED][BORED][HORNY] = 0;
  ExternalStateMap3D[BORED][BORED][ANTISOCIAL] = 3;
  ExternalStateMap3D[BORED][BORED][DYING] = 0;
  ExternalStateMap3D[BORED][BORED][DEAD] = 0;

  ExternalStateMap3D[BORED][DISGUSTED][HAPPY] = 0;
  ExternalStateMap3D[BORED][DISGUSTED][SAD] = 3;
  ExternalStateMap3D[BORED][DISGUSTED][ANGRY] = 3;
  ExternalStateMap3D[BORED][DISGUSTED][BORED] = 0;
  ExternalStateMap3D[BORED][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap3D[BORED][DISGUSTED][SURPRISED] = 4;
  ExternalStateMap3D[BORED][DISGUSTED][HORNY] = 0;
  ExternalStateMap3D[BORED][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap3D[BORED][DISGUSTED][DYING] = 0;
  ExternalStateMap3D[BORED][DISGUSTED][DEAD] = 0;

  ExternalStateMap3D[BORED][SURPRISED][HAPPY] = 0;
  ExternalStateMap3D[BORED][SURPRISED][SAD] = 0;
  ExternalStateMap3D[BORED][SURPRISED][ANGRY] = 0;
  ExternalStateMap3D[BORED][SURPRISED][BORED] = 0;
  ExternalStateMap3D[BORED][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap3D[BORED][SURPRISED][SURPRISED] = 0;
  ExternalStateMap3D[BORED][SURPRISED][HORNY] = 0;
  ExternalStateMap3D[BORED][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap3D[BORED][SURPRISED][DYING] = 0;
  ExternalStateMap3D[BORED][SURPRISED][DEAD] = 0;

  ExternalStateMap3D[BORED][HORNY][HAPPY] = 4;
  ExternalStateMap3D[BORED][HORNY][SAD] = 0;
  ExternalStateMap3D[BORED][HORNY][ANGRY] = 0;
  ExternalStateMap3D[BORED][HORNY][BORED] = 0;
  ExternalStateMap3D[BORED][HORNY][DISGUSTED] = 0;
  ExternalStateMap3D[BORED][HORNY][SURPRISED] = 3;
  ExternalStateMap3D[BORED][HORNY][HORNY] = 3;
  ExternalStateMap3D[BORED][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap3D[BORED][HORNY][DYING] = 0;
  ExternalStateMap3D[BORED][HORNY][DEAD] = 0;

  ExternalStateMap3D[BORED][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap3D[BORED][ANTISOCIAL][SAD] = 0;
  ExternalStateMap3D[BORED][ANTISOCIAL][ANGRY] = 3;
  ExternalStateMap3D[BORED][ANTISOCIAL][BORED] = 0;
  ExternalStateMap3D[BORED][ANTISOCIAL][DISGUSTED] = 3;
  ExternalStateMap3D[BORED][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap3D[BORED][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap3D[BORED][ANTISOCIAL][ANTISOCIAL] = 4;
  ExternalStateMap3D[BORED][ANTISOCIAL][DYING] = 0;
  ExternalStateMap3D[BORED][ANTISOCIAL][DEAD] = 0;

  ExternalStateMap3D[BORED][DYING][HAPPY] = 0;
  ExternalStateMap3D[BORED][DYING][SAD] = 2;
  ExternalStateMap3D[BORED][DYING][ANGRY] = 2;
  ExternalStateMap3D[BORED][DYING][BORED] = 3;
  ExternalStateMap3D[BORED][DYING][DISGUSTED] = 0;
  ExternalStateMap3D[BORED][DYING][SURPRISED] = 3;
  ExternalStateMap3D[BORED][DYING][HORNY] = 0;
  ExternalStateMap3D[BORED][DYING][ANTISOCIAL] = 0;
  ExternalStateMap3D[BORED][DYING][DYING] = 0;
  ExternalStateMap3D[BORED][DYING][DEAD] = 0;

  ExternalStateMap3D[BORED][DEAD][HAPPY] = 0;
  ExternalStateMap3D[BORED][DEAD][SAD] = 3;
  ExternalStateMap3D[BORED][DEAD][ANGRY] = 3;
  ExternalStateMap3D[BORED][DEAD][BORED] = 0;
  ExternalStateMap3D[BORED][DEAD][DISGUSTED] = 0;
  ExternalStateMap3D[BORED][DEAD][SURPRISED] = 4;
  ExternalStateMap3D[BORED][DEAD][HORNY] = 0;
  ExternalStateMap3D[BORED][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[BORED][DEAD][DYING] = 0;
  ExternalStateMap3D[BORED][DEAD][DEAD] = 0;


  //DISGUSTED

  ExternalStateMap3D[DISGUSTED][HAPPY][HAPPY] = 0;
  ExternalStateMap3D[DISGUSTED][HAPPY][SAD] = 0;
  ExternalStateMap3D[DISGUSTED][HAPPY][ANGRY] = 5;
  ExternalStateMap3D[DISGUSTED][HAPPY][BORED] = 0;
  ExternalStateMap3D[DISGUSTED][HAPPY][DISGUSTED] = 5;
  ExternalStateMap3D[DISGUSTED][HAPPY][SURPRISED] = 0;
  ExternalStateMap3D[DISGUSTED][HAPPY][HORNY] = 0;
  ExternalStateMap3D[DISGUSTED][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap3D[DISGUSTED][HAPPY][DYING] = 0;
  ExternalStateMap3D[DISGUSTED][HAPPY][DEAD] = 0;

  ExternalStateMap3D[DISGUSTED][SAD][HAPPY] = 0;
  ExternalStateMap3D[DISGUSTED][SAD][SAD] = 5;
  ExternalStateMap3D[DISGUSTED][SAD][ANGRY] = 0;
  ExternalStateMap3D[DISGUSTED][SAD][BORED] = 0;
  ExternalStateMap3D[DISGUSTED][SAD][DISGUSTED] = 5;
  ExternalStateMap3D[DISGUSTED][SAD][SURPRISED] = 0;
  ExternalStateMap3D[DISGUSTED][SAD][HORNY] = 0;
  ExternalStateMap3D[DISGUSTED][SAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[DISGUSTED][SAD][DYING] = 0;
  ExternalStateMap3D[DISGUSTED][SAD][DEAD] = 0;

  ExternalStateMap3D[DISGUSTED][ANGRY][HAPPY] = 0;
  ExternalStateMap3D[DISGUSTED][ANGRY][SAD] = 0;
  ExternalStateMap3D[DISGUSTED][ANGRY][ANGRY] = 3;
  ExternalStateMap3D[DISGUSTED][ANGRY][BORED] = 0;
  ExternalStateMap3D[DISGUSTED][ANGRY][DISGUSTED] = 4;
  ExternalStateMap3D[DISGUSTED][ANGRY][SURPRISED] = 0;
  ExternalStateMap3D[DISGUSTED][ANGRY][HORNY] = 0;
  ExternalStateMap3D[DISGUSTED][ANGRY][ANTISOCIAL] = 3;
  ExternalStateMap3D[DISGUSTED][ANGRY][DYING] = 0;
  ExternalStateMap3D[DISGUSTED][ANGRY][DEAD] = 0;

  ExternalStateMap3D[DISGUSTED][BORED][HAPPY] = 0;
  ExternalStateMap3D[DISGUSTED][BORED][SAD] = 0;
  ExternalStateMap3D[DISGUSTED][BORED][ANGRY] = 3;
  ExternalStateMap3D[DISGUSTED][BORED][BORED] = 4;
  ExternalStateMap3D[DISGUSTED][BORED][DISGUSTED] = 3;
  ExternalStateMap3D[DISGUSTED][BORED][SURPRISED] = 0;
  ExternalStateMap3D[DISGUSTED][BORED][HORNY] = 0;
  ExternalStateMap3D[DISGUSTED][BORED][ANTISOCIAL] = 0;
  ExternalStateMap3D[DISGUSTED][BORED][DYING] = 0;
  ExternalStateMap3D[DISGUSTED][BORED][DEAD] = 0;

  ExternalStateMap3D[DISGUSTED][DISGUSTED][HAPPY] = 0;
  ExternalStateMap3D[DISGUSTED][DISGUSTED][SAD] = 0;
  ExternalStateMap3D[DISGUSTED][DISGUSTED][ANGRY] = 5;
  ExternalStateMap3D[DISGUSTED][DISGUSTED][BORED] = 0;
  ExternalStateMap3D[DISGUSTED][DISGUSTED][DISGUSTED] = 5;
  ExternalStateMap3D[DISGUSTED][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap3D[DISGUSTED][DISGUSTED][HORNY] = 0;
  ExternalStateMap3D[DISGUSTED][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap3D[DISGUSTED][DISGUSTED][DYING] = 0;
  ExternalStateMap3D[DISGUSTED][DISGUSTED][DEAD] = 0;

  ExternalStateMap3D[DISGUSTED][SURPRISED][HAPPY] = 0;
  ExternalStateMap3D[DISGUSTED][SURPRISED][SAD] = 0;
  ExternalStateMap3D[DISGUSTED][SURPRISED][ANGRY] = 3;
  ExternalStateMap3D[DISGUSTED][SURPRISED][BORED] = 0;
  ExternalStateMap3D[DISGUSTED][SURPRISED][DISGUSTED] = 4;
  ExternalStateMap3D[DISGUSTED][SURPRISED][SURPRISED] = 3;
  ExternalStateMap3D[DISGUSTED][SURPRISED][HORNY] = 0;
  ExternalStateMap3D[DISGUSTED][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap3D[DISGUSTED][SURPRISED][DYING] = 0;
  ExternalStateMap3D[DISGUSTED][SURPRISED][DEAD] = 0;

  ExternalStateMap3D[DISGUSTED][HORNY][HAPPY] = 0;
  ExternalStateMap3D[DISGUSTED][HORNY][SAD] = 0;
  ExternalStateMap3D[DISGUSTED][HORNY][ANGRY] = 5;
  ExternalStateMap3D[DISGUSTED][HORNY][BORED] = 0;
  ExternalStateMap3D[DISGUSTED][HORNY][DISGUSTED] = 5;
  ExternalStateMap3D[DISGUSTED][HORNY][SURPRISED] = 0;
  ExternalStateMap3D[DISGUSTED][HORNY][HORNY] = 0;
  ExternalStateMap3D[DISGUSTED][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap3D[DISGUSTED][HORNY][DYING] = 0;
  ExternalStateMap3D[DISGUSTED][HORNY][DEAD] = 0;

  ExternalStateMap3D[DISGUSTED][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap3D[DISGUSTED][ANTISOCIAL][SAD] = 0;
  ExternalStateMap3D[DISGUSTED][ANTISOCIAL][ANGRY] = 5;
  ExternalStateMap3D[DISGUSTED][ANTISOCIAL][BORED] = 0;
  ExternalStateMap3D[DISGUSTED][ANTISOCIAL][DISGUSTED] = 5;
  ExternalStateMap3D[DISGUSTED][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap3D[DISGUSTED][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap3D[DISGUSTED][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap3D[DISGUSTED][ANTISOCIAL][DYING] = 0;
  ExternalStateMap3D[DISGUSTED][ANTISOCIAL][DEAD] = 0;

  ExternalStateMap3D[DISGUSTED][DYING][HAPPY] = 0;
  ExternalStateMap3D[DISGUSTED][DYING][SAD] = 4;
  ExternalStateMap3D[DISGUSTED][DYING][ANGRY] = 3;
  ExternalStateMap3D[DISGUSTED][DYING][BORED] = 0;
  ExternalStateMap3D[DISGUSTED][DYING][DISGUSTED] = 3;
  ExternalStateMap3D[DISGUSTED][DYING][SURPRISED] = 0;
  ExternalStateMap3D[DISGUSTED][DYING][HORNY] = 0;
  ExternalStateMap3D[DISGUSTED][DYING][ANTISOCIAL] = 0;
  ExternalStateMap3D[DISGUSTED][DYING][DYING] = 0;
  ExternalStateMap3D[DISGUSTED][DYING][DEAD] = 0;

  ExternalStateMap3D[DISGUSTED][DEAD][HAPPY] = 0;
  ExternalStateMap3D[DISGUSTED][DEAD][SAD] = 4;
  ExternalStateMap3D[DISGUSTED][DEAD][ANGRY] = 3;
  ExternalStateMap3D[DISGUSTED][DEAD][BORED] = 0;
  ExternalStateMap3D[DISGUSTED][DEAD][DISGUSTED] = 3;
  ExternalStateMap3D[DISGUSTED][DEAD][SURPRISED] = 0;
  ExternalStateMap3D[DISGUSTED][DEAD][HORNY] = 0;
  ExternalStateMap3D[DISGUSTED][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[DISGUSTED][DEAD][DYING] = 0;
  ExternalStateMap3D[DISGUSTED][DEAD][DEAD] = 0;


  //SURPRISED

  ExternalStateMap3D[SURPRISED][HAPPY][HAPPY] = 0;
  ExternalStateMap3D[SURPRISED][HAPPY][SAD] = 0;
  ExternalStateMap3D[SURPRISED][HAPPY][ANGRY] = 0;
  ExternalStateMap3D[SURPRISED][HAPPY][BORED] = 0;
  ExternalStateMap3D[SURPRISED][HAPPY][DISGUSTED] = 0;
  ExternalStateMap3D[SURPRISED][HAPPY][SURPRISED] = 0;
  ExternalStateMap3D[SURPRISED][HAPPY][HORNY] = 0;
  ExternalStateMap3D[SURPRISED][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap3D[SURPRISED][HAPPY][DYING] = 0;
  ExternalStateMap3D[SURPRISED][HAPPY][DEAD] = 0;

  ExternalStateMap3D[SURPRISED][SAD][HAPPY] = 0;
  ExternalStateMap3D[SURPRISED][SAD][SAD] = 4;
  ExternalStateMap3D[SURPRISED][SAD][ANGRY] = 0;
  ExternalStateMap3D[SURPRISED][SAD][BORED] = 3;
  ExternalStateMap3D[SURPRISED][SAD][DISGUSTED] = 3;
  ExternalStateMap3D[SURPRISED][SAD][SURPRISED] = 0;
  ExternalStateMap3D[SURPRISED][SAD][HORNY] = 0;
  ExternalStateMap3D[SURPRISED][SAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[SURPRISED][SAD][DYING] = 0;
  ExternalStateMap3D[SURPRISED][SAD][DEAD] = 0;

  ExternalStateMap3D[SURPRISED][ANGRY][HAPPY] = 0;
  ExternalStateMap3D[SURPRISED][ANGRY][SAD] = 4;
  ExternalStateMap3D[SURPRISED][ANGRY][ANGRY] = 3;
  ExternalStateMap3D[SURPRISED][ANGRY][BORED] = 0;
  ExternalStateMap3D[SURPRISED][ANGRY][DISGUSTED] = 0;
  ExternalStateMap3D[SURPRISED][ANGRY][SURPRISED] = 3;
  ExternalStateMap3D[SURPRISED][ANGRY][HORNY] = 0;
  ExternalStateMap3D[SURPRISED][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap3D[SURPRISED][ANGRY][DYING] = 0;
  ExternalStateMap3D[SURPRISED][ANGRY][DEAD] = 0;

  ExternalStateMap3D[SURPRISED][BORED][HAPPY] = 5;
  ExternalStateMap3D[SURPRISED][BORED][SAD] = 5;
  ExternalStateMap3D[SURPRISED][BORED][ANGRY] = 0;
  ExternalStateMap3D[SURPRISED][BORED][BORED] = 0;
  ExternalStateMap3D[SURPRISED][BORED][DISGUSTED] = 0;
  ExternalStateMap3D[SURPRISED][BORED][SURPRISED] = 0;
  ExternalStateMap3D[SURPRISED][BORED][HORNY] = 0;
  ExternalStateMap3D[SURPRISED][BORED][ANTISOCIAL] = 0;
  ExternalStateMap3D[SURPRISED][BORED][DYING] = 0;
  ExternalStateMap3D[SURPRISED][BORED][DEAD] = 0;

  ExternalStateMap3D[SURPRISED][DISGUSTED][HAPPY] = 0;
  ExternalStateMap3D[SURPRISED][DISGUSTED][SAD] = 10;
  ExternalStateMap3D[SURPRISED][DISGUSTED][ANGRY] = 0;
  ExternalStateMap3D[SURPRISED][DISGUSTED][BORED] = 0;
  ExternalStateMap3D[SURPRISED][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap3D[SURPRISED][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap3D[SURPRISED][DISGUSTED][HORNY] = 0;
  ExternalStateMap3D[SURPRISED][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap3D[SURPRISED][DISGUSTED][DYING] = 0;
  ExternalStateMap3D[SURPRISED][DISGUSTED][DEAD] = 0;

  ExternalStateMap3D[SURPRISED][SURPRISED][HAPPY] = 5;
  ExternalStateMap3D[SURPRISED][SURPRISED][SAD] = 0;
  ExternalStateMap3D[SURPRISED][SURPRISED][ANGRY] = 0;
  ExternalStateMap3D[SURPRISED][SURPRISED][BORED] = 0;
  ExternalStateMap3D[SURPRISED][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap3D[SURPRISED][SURPRISED][SURPRISED] = 5;
  ExternalStateMap3D[SURPRISED][SURPRISED][HORNY] = 0;
  ExternalStateMap3D[SURPRISED][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap3D[SURPRISED][SURPRISED][DYING] = 0;
  ExternalStateMap3D[SURPRISED][SURPRISED][DEAD] = 0;

  ExternalStateMap3D[SURPRISED][HORNY][HAPPY] = 4;
  ExternalStateMap3D[SURPRISED][HORNY][SAD] = 0;
  ExternalStateMap3D[SURPRISED][HORNY][ANGRY] = 0;
  ExternalStateMap3D[SURPRISED][HORNY][BORED] = 0;
  ExternalStateMap3D[SURPRISED][HORNY][DISGUSTED] = 3;
  ExternalStateMap3D[SURPRISED][HORNY][SURPRISED] = 0;
  ExternalStateMap3D[SURPRISED][HORNY][HORNY] = 4;
  ExternalStateMap3D[SURPRISED][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap3D[SURPRISED][HORNY][DYING] = 0;
  ExternalStateMap3D[SURPRISED][HORNY][DEAD] = 0;

  ExternalStateMap3D[SURPRISED][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap3D[SURPRISED][ANTISOCIAL][SAD] = 0;
  ExternalStateMap3D[SURPRISED][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap3D[SURPRISED][ANTISOCIAL][BORED] = 0;
  ExternalStateMap3D[SURPRISED][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap3D[SURPRISED][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap3D[SURPRISED][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap3D[SURPRISED][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap3D[SURPRISED][ANTISOCIAL][DYING] = 0;
  ExternalStateMap3D[SURPRISED][ANTISOCIAL][DEAD] = 0;

  ExternalStateMap3D[SURPRISED][DYING][HAPPY] = 0;
  ExternalStateMap3D[SURPRISED][DYING][SAD] = 5;
  ExternalStateMap3D[SURPRISED][DYING][ANGRY] = 5;
  ExternalStateMap3D[SURPRISED][DYING][BORED] = 0;
  ExternalStateMap3D[SURPRISED][DYING][DISGUSTED] = 0;
  ExternalStateMap3D[SURPRISED][DYING][SURPRISED] = 0;
  ExternalStateMap3D[SURPRISED][DYING][HORNY] = 0;
  ExternalStateMap3D[SURPRISED][DYING][ANTISOCIAL] = 0;
  ExternalStateMap3D[SURPRISED][DYING][DYING] = 0;
  ExternalStateMap3D[SURPRISED][DYING][DEAD] = 0;

  ExternalStateMap3D[SURPRISED][DEAD][HAPPY] = 0;
  ExternalStateMap3D[SURPRISED][DEAD][SAD] = 10;
  ExternalStateMap3D[SURPRISED][DEAD][ANGRY] = 0;
  ExternalStateMap3D[SURPRISED][DEAD][BORED] = 0;
  ExternalStateMap3D[SURPRISED][DEAD][DISGUSTED] = 0;
  ExternalStateMap3D[SURPRISED][DEAD][SURPRISED] = 0;
  ExternalStateMap3D[SURPRISED][DEAD][HORNY] = 0;
  ExternalStateMap3D[SURPRISED][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[SURPRISED][DEAD][DYING] = 0;
  ExternalStateMap3D[SURPRISED][DEAD][DEAD] = 0;


  //HORNY


  ExternalStateMap3D[HORNY][HAPPY][HAPPY] = 0;
  ExternalStateMap3D[HORNY][HAPPY][SAD] = 0;
  ExternalStateMap3D[HORNY][HAPPY][ANGRY] = 0;
  ExternalStateMap3D[HORNY][HAPPY][BORED] = 0;
  ExternalStateMap3D[HORNY][HAPPY][DISGUSTED] = 0;
  ExternalStateMap3D[HORNY][HAPPY][SURPRISED] = 0;
  ExternalStateMap3D[HORNY][HAPPY][HORNY] = 0;
  ExternalStateMap3D[HORNY][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap3D[HORNY][HAPPY][DYING] = 0;
  ExternalStateMap3D[HORNY][HAPPY][DEAD] = 0;

  ExternalStateMap3D[HORNY][SAD][HAPPY] = 0;
  ExternalStateMap3D[HORNY][SAD][SAD] = 5;
  ExternalStateMap3D[HORNY][SAD][ANGRY] = 5;
  ExternalStateMap3D[HORNY][SAD][BORED] = 0;
  ExternalStateMap3D[HORNY][SAD][DISGUSTED] = 0;
  ExternalStateMap3D[HORNY][SAD][SURPRISED] = 0;
  ExternalStateMap3D[HORNY][SAD][HORNY] = 0;
  ExternalStateMap3D[HORNY][SAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[HORNY][SAD][DYING] = 0;
  ExternalStateMap3D[HORNY][SAD][DEAD] = 0;

  ExternalStateMap3D[HORNY][ANGRY][HAPPY] = 0;
  ExternalStateMap3D[HORNY][ANGRY][SAD] = 4;
  ExternalStateMap3D[HORNY][ANGRY][ANGRY] = 3;
  ExternalStateMap3D[HORNY][ANGRY][BORED] = 0;
  ExternalStateMap3D[HORNY][ANGRY][DISGUSTED] = 0;
  ExternalStateMap3D[HORNY][ANGRY][SURPRISED] = 3;
  ExternalStateMap3D[HORNY][ANGRY][HORNY] = 0;
  ExternalStateMap3D[HORNY][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap3D[HORNY][ANGRY][DYING] = 0;
  ExternalStateMap3D[HORNY][ANGRY][DEAD] = 0;

  ExternalStateMap3D[HORNY][BORED][HAPPY] = 0;
  ExternalStateMap3D[HORNY][BORED][SAD] = 5;
  ExternalStateMap3D[HORNY][BORED][ANGRY] = 0;
  ExternalStateMap3D[HORNY][BORED][BORED] = 0;
  ExternalStateMap3D[HORNY][BORED][DISGUSTED] = 5;
  ExternalStateMap3D[HORNY][BORED][SURPRISED] = 0;
  ExternalStateMap3D[HORNY][BORED][HORNY] = 0;
  ExternalStateMap3D[HORNY][BORED][ANTISOCIAL] = 0;
  ExternalStateMap3D[HORNY][BORED][DYING] = 0;
  ExternalStateMap3D[HORNY][BORED][DEAD] = 0;

  ExternalStateMap3D[HORNY][DISGUSTED][HAPPY] = 0;
  ExternalStateMap3D[HORNY][DISGUSTED][SAD] = 3;
  ExternalStateMap3D[HORNY][DISGUSTED][ANGRY] = 3;
  ExternalStateMap3D[HORNY][DISGUSTED][BORED] = 0;
  ExternalStateMap3D[HORNY][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap3D[HORNY][DISGUSTED][SURPRISED] = 4;
  ExternalStateMap3D[HORNY][DISGUSTED][HORNY] = 0;
  ExternalStateMap3D[HORNY][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap3D[HORNY][DISGUSTED][DYING] = 0;
  ExternalStateMap3D[HORNY][DISGUSTED][DEAD] = 0;

  ExternalStateMap3D[HORNY][SURPRISED][HAPPY] = 0;
  ExternalStateMap3D[HORNY][SURPRISED][SAD] = 0;
  ExternalStateMap3D[HORNY][SURPRISED][ANGRY] = 0;
  ExternalStateMap3D[HORNY][SURPRISED][BORED] = 0;
  ExternalStateMap3D[HORNY][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap3D[HORNY][SURPRISED][SURPRISED] = 0;
  ExternalStateMap3D[HORNY][SURPRISED][HORNY] = 10;
  ExternalStateMap3D[HORNY][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap3D[HORNY][SURPRISED][DYING] = 0;
  ExternalStateMap3D[HORNY][SURPRISED][DEAD] = 0;

  ExternalStateMap3D[HORNY][HORNY][HAPPY] = 0;
  ExternalStateMap3D[HORNY][HORNY][SAD] = 0;
  ExternalStateMap3D[HORNY][HORNY][ANGRY] = 0;
  ExternalStateMap3D[HORNY][HORNY][BORED] = 0;
  ExternalStateMap3D[HORNY][HORNY][DISGUSTED] = 0;
  ExternalStateMap3D[HORNY][HORNY][SURPRISED] = 0;
  ExternalStateMap3D[HORNY][HORNY][HORNY] = 10;
  ExternalStateMap3D[HORNY][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap3D[HORNY][HORNY][DYING] = 0;
  ExternalStateMap3D[HORNY][HORNY][DEAD] = 0;

  ExternalStateMap3D[HORNY][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap3D[HORNY][ANTISOCIAL][SAD] = 5;
  ExternalStateMap3D[HORNY][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap3D[HORNY][ANTISOCIAL][BORED] = 0;
  ExternalStateMap3D[HORNY][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap3D[HORNY][ANTISOCIAL][SURPRISED] = 5;
  ExternalStateMap3D[HORNY][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap3D[HORNY][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap3D[HORNY][ANTISOCIAL][DYING] = 0;
  ExternalStateMap3D[HORNY][ANTISOCIAL][DEAD] = 0;

  ExternalStateMap3D[HORNY][DYING][HAPPY] = 0;
  ExternalStateMap3D[HORNY][DYING][SAD] = 10;
  ExternalStateMap3D[HORNY][DYING][ANGRY] = 0;
  ExternalStateMap3D[HORNY][DYING][BORED] = 0;
  ExternalStateMap3D[HORNY][DYING][DISGUSTED] = 0;
  ExternalStateMap3D[HORNY][DYING][SURPRISED] = 0;
  ExternalStateMap3D[HORNY][DYING][HORNY] = 0;
  ExternalStateMap3D[HORNY][DYING][ANTISOCIAL] = 0;
  ExternalStateMap3D[HORNY][DYING][DYING] = 0;
  ExternalStateMap3D[HORNY][DYING][DEAD] = 0;

  ExternalStateMap3D[HORNY][DEAD][HAPPY] = 0;
  ExternalStateMap3D[HORNY][DEAD][SAD] = 10;
  ExternalStateMap3D[HORNY][DEAD][ANGRY] = 0;
  ExternalStateMap3D[HORNY][DEAD][BORED] = 0;
  ExternalStateMap3D[HORNY][DEAD][DISGUSTED] = 0;
  ExternalStateMap3D[HORNY][DEAD][SURPRISED] = 0;
  ExternalStateMap3D[HORNY][DEAD][HORNY] = 0;
  ExternalStateMap3D[HORNY][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap3D[HORNY][DEAD][DYING] = 0;
  ExternalStateMap3D[HORNY][DEAD][DEAD] = 0;


  //ANTISOCIAL

  ExternalStateMap3D[ANTISOCIAL][HAPPY][HAPPY] = 0;
  ExternalStateMap3D[ANTISOCIAL][HAPPY][SAD] = 0;
  ExternalStateMap3D[ANTISOCIAL][HAPPY][ANGRY] = 5;
  ExternalStateMap3D[ANTISOCIAL][HAPPY][BORED] = 0;
  ExternalStateMap3D[ANTISOCIAL][HAPPY][DISGUSTED] = 0;
  ExternalStateMap3D[ANTISOCIAL][HAPPY][SURPRISED] = 0;
  ExternalStateMap3D[ANTISOCIAL][HAPPY][HORNY] = 0;
  ExternalStateMap3D[ANTISOCIAL][HAPPY][ANTISOCIAL] = 5;
  ExternalStateMap3D[ANTISOCIAL][HAPPY][DYING] = 0;
  ExternalStateMap3D[ANTISOCIAL][HAPPY][DEAD] = 0;

  ExternalStateMap3D[ANTISOCIAL][SAD][HAPPY] = 0;
  ExternalStateMap3D[ANTISOCIAL][SAD][SAD] = 0;
  ExternalStateMap3D[ANTISOCIAL][SAD][ANGRY] = 0;
  ExternalStateMap3D[ANTISOCIAL][SAD][BORED] = 5;
  ExternalStateMap3D[ANTISOCIAL][SAD][DISGUSTED] = 0;
  ExternalStateMap3D[ANTISOCIAL][SAD][SURPRISED] = 0;
  ExternalStateMap3D[ANTISOCIAL][SAD][HORNY] = 0;
  ExternalStateMap3D[ANTISOCIAL][SAD][ANTISOCIAL] = 5;
  ExternalStateMap3D[ANTISOCIAL][SAD][DYING] = 0;
  ExternalStateMap3D[ANTISOCIAL][SAD][DEAD] = 0;

  ExternalStateMap3D[ANTISOCIAL][ANGRY][HAPPY] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANGRY][SAD] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANGRY][ANGRY] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANGRY][BORED] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANGRY][DISGUSTED] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANGRY][SURPRISED] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANGRY][HORNY] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANGRY][DYING] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANGRY][DEAD] = 0;

  ExternalStateMap3D[ANTISOCIAL][BORED][HAPPY] = 0;
  ExternalStateMap3D[ANTISOCIAL][BORED][SAD] = 0;
  ExternalStateMap3D[ANTISOCIAL][BORED][ANGRY] = 0;
  ExternalStateMap3D[ANTISOCIAL][BORED][BORED] = 0;
  ExternalStateMap3D[ANTISOCIAL][BORED][DISGUSTED] = 0;
  ExternalStateMap3D[ANTISOCIAL][BORED][SURPRISED] = 0;
  ExternalStateMap3D[ANTISOCIAL][BORED][HORNY] = 0;
  ExternalStateMap3D[ANTISOCIAL][BORED][ANTISOCIAL] = 10;
  ExternalStateMap3D[ANTISOCIAL][BORED][DYING] = 0;
  ExternalStateMap3D[ANTISOCIAL][BORED][DEAD] = 0;

  ExternalStateMap3D[ANTISOCIAL][DISGUSTED][HAPPY] = 0;
  ExternalStateMap3D[ANTISOCIAL][DISGUSTED][SAD] = 3;
  ExternalStateMap3D[ANTISOCIAL][DISGUSTED][ANGRY] = 3;
  ExternalStateMap3D[ANTISOCIAL][DISGUSTED][BORED] = 0;
  ExternalStateMap3D[ANTISOCIAL][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap3D[ANTISOCIAL][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap3D[ANTISOCIAL][DISGUSTED][HORNY] = 0;
  ExternalStateMap3D[ANTISOCIAL][DISGUSTED][ANTISOCIAL] = 4;
  ExternalStateMap3D[ANTISOCIAL][DISGUSTED][DYING] = 0;
  ExternalStateMap3D[ANTISOCIAL][DISGUSTED][DEAD] = 0;

  ExternalStateMap3D[ANTISOCIAL][SURPRISED][HAPPY] = 0;
  ExternalStateMap3D[ANTISOCIAL][SURPRISED][SAD] = 0;
  ExternalStateMap3D[ANTISOCIAL][SURPRISED][ANGRY] = 0;
  ExternalStateMap3D[ANTISOCIAL][SURPRISED][BORED] = 0;
  ExternalStateMap3D[ANTISOCIAL][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap3D[ANTISOCIAL][SURPRISED][SURPRISED] = 0;
  ExternalStateMap3D[ANTISOCIAL][SURPRISED][HORNY] = 0;
  ExternalStateMap3D[ANTISOCIAL][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap3D[ANTISOCIAL][SURPRISED][DYING] = 0;
  ExternalStateMap3D[ANTISOCIAL][SURPRISED][DEAD] = 0;

  ExternalStateMap3D[ANTISOCIAL][HORNY][HAPPY] = 3;
  ExternalStateMap3D[ANTISOCIAL][HORNY][SAD] = 0;
  ExternalStateMap3D[ANTISOCIAL][HORNY][ANGRY] = 0;
  ExternalStateMap3D[ANTISOCIAL][HORNY][BORED] = 0;
  ExternalStateMap3D[ANTISOCIAL][HORNY][DISGUSTED] = 2;
  ExternalStateMap3D[ANTISOCIAL][HORNY][SURPRISED] = 0;
  ExternalStateMap3D[ANTISOCIAL][HORNY][HORNY] = 3;
  ExternalStateMap3D[ANTISOCIAL][HORNY][ANTISOCIAL] = 2;
  ExternalStateMap3D[ANTISOCIAL][HORNY][DYING] = 0;
  ExternalStateMap3D[ANTISOCIAL][HORNY][DEAD] = 0;

  ExternalStateMap3D[ANTISOCIAL][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANTISOCIAL][SAD] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANTISOCIAL][BORED] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANTISOCIAL][ANTISOCIAL] = 10;
  ExternalStateMap3D[ANTISOCIAL][ANTISOCIAL][DYING] = 0;
  ExternalStateMap3D[ANTISOCIAL][ANTISOCIAL][DEAD] = 0;

  ExternalStateMap3D[ANTISOCIAL][DYING][HAPPY] = 0;
  ExternalStateMap3D[ANTISOCIAL][DYING][SAD] = 3;
  ExternalStateMap3D[ANTISOCIAL][DYING][ANGRY] = 0;
  ExternalStateMap3D[ANTISOCIAL][DYING][BORED] = 3;
  ExternalStateMap3D[ANTISOCIAL][DYING][DISGUSTED] = 0;
  ExternalStateMap3D[ANTISOCIAL][DYING][SURPRISED] = 0;
  ExternalStateMap3D[ANTISOCIAL][DYING][HORNY] = 0;
  ExternalStateMap3D[ANTISOCIAL][DYING][ANTISOCIAL] = 4;
  ExternalStateMap3D[ANTISOCIAL][DYING][DYING] = 0;
  ExternalStateMap3D[ANTISOCIAL][DYING][DEAD] = 0;

  ExternalStateMap3D[ANTISOCIAL][DEAD][HAPPY] = 0;
  ExternalStateMap3D[ANTISOCIAL][DEAD][SAD] = 5;
  ExternalStateMap3D[ANTISOCIAL][DEAD][ANGRY] = 0;
  ExternalStateMap3D[ANTISOCIAL][DEAD][BORED] = 0;
  ExternalStateMap3D[ANTISOCIAL][DEAD][DISGUSTED] = 0;
  ExternalStateMap3D[ANTISOCIAL][DEAD][SURPRISED] = 0;
  ExternalStateMap3D[ANTISOCIAL][DEAD][HORNY] = 0;
  ExternalStateMap3D[ANTISOCIAL][DEAD][ANTISOCIAL] = 5;
  ExternalStateMap3D[ANTISOCIAL][DEAD][DYING] = 0;
  ExternalStateMap3D[ANTISOCIAL][DEAD][DEAD] = 0;


  //DYING
  ExternalStateMap3D[DYING][HAPPY][DYING] = 8;
  ExternalStateMap3D[DYING][HAPPY][DEAD] = 2;
  ExternalStateMap3D[DYING][SAD][DYING] = 8;
  ExternalStateMap3D[DYING][SAD][DEAD] = 2;
  ExternalStateMap3D[DYING][ANGRY][DYING] = 8;
  ExternalStateMap3D[DYING][ANGRY][DEAD] = 2;
  ExternalStateMap3D[DYING][BORED][DYING] = 8;
  ExternalStateMap3D[DYING][BORED][DEAD] = 2;
  ExternalStateMap3D[DYING][DISGUSTED][DYING] = 8;
  ExternalStateMap3D[DYING][DISGUSTED][DEAD] = 2;
  ExternalStateMap3D[DYING][SURPRISED][DYING] = 8;
  ExternalStateMap3D[DYING][SURPRISED][DEAD] = 2;
  ExternalStateMap3D[DYING][HORNY][DYING] = 8;
  ExternalStateMap3D[DYING][HORNY][DEAD] = 2;
  ExternalStateMap3D[DYING][ANTISOCIAL][DYING] = 8;
  ExternalStateMap3D[DYING][ANTISOCIAL][DEAD] = 2;
  ExternalStateMap3D[DYING][DYING][DYING] = 8;
  ExternalStateMap3D[DYING][DYING][DEAD] = 2;
  ExternalStateMap3D[DYING][DEAD][DYING] = 8;
  ExternalStateMap3D[DYING][DEAD][DEAD] = 2;

  //DEAD
  ExternalStateMap3D[DEAD][HAPPY][DEAD] = 10;
  ExternalStateMap3D[DEAD][SAD][DEAD] = 10;
  ExternalStateMap3D[DEAD][ANGRY][DEAD] = 10;
  ExternalStateMap3D[DEAD][BORED][DEAD] = 10;
  ExternalStateMap3D[DEAD][DISGUSTED][DEAD] = 10;
  ExternalStateMap3D[DEAD][SURPRISED][DEAD] = 10;
  ExternalStateMap3D[DEAD][HORNY][DEAD] = 10;
  ExternalStateMap3D[DEAD][ANTISOCIAL][DEAD] = 10;
  ExternalStateMap3D[DEAD][DYING][DEAD] = 10;
  ExternalStateMap3D[DEAD][DEAD][DEAD] = 10;
}

