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

//List<Integer> possibleStates[11];
int maxStates = states.length*states.length*states.length;
int ExternalStateMap[] = new int[maxStates];

void setup()
{

  noLoop();
  println(maxStates+"");
  /*
possibleStates[HAPPY] = Arrays.asList( { HAPPY, SAD, BORED, DISGUSTED, SURPRISED, HORNY, ANTISOCIAL,
   DYING } );
   
   possibleStates[SAD] = Arrays.asList( { HAPPY, SAD, BORED, DISGUSTED, SURPRISED, HORNY, ANTISOCIAL,
   DYING } );
   
   possibleStates[ANGRY] = Arrays.asList( { ANGRY, BORED, DISGUSTED, SURPRISED, HORNY, ANTISOCIAL,
   DYING } );
   
   possibleStates[BORED] = Arrays.asList( { HAPPY, SAD, ANGRY, BORED, DISGUSTED, SURPRISED, HORNY, ANTISOCIAL,
   DYING } );
   
   possibleStates[DISGUSTED] = Arrays.asList( { ANGRY, BORED, DISGUSTED, SURPRISED, ANTISOCIAL,
   DYING } );
   
   possibleStates[SURPRISED] = Arrays.asList( { HAPPY, SAD, ANGRY, BORED, DISGUSTED, SURPRISED, HORNY, ANTISOCIAL,
   DYING } );
   
   possibleStates[HORNY] = Arrays.asList( { HAPPY, SAD, ANGRY, BORED, DISGUSTED, SURPRISED, HORNY, ANTISOCIAL,
   DYING } );
   
   possibleStates[ANTISOCIAL] = Arrays.asList( { HAPPY, SAD, ANGRY, BORED, DISGUSTED, SURPRISED, HORNY, ANTISOCIAL,
   DYING } );
   
   possibleStates[DYING] = Arrays.asList( { HAPPY, SAD, ANGRY, BORED, DISGUSTED, SURPRISED, HORNY, ANTISOCIAL,
   DYING, DEAD } );
   
   possibleStates[DEAD] = Arrays.asList( { DYING, DEAD } );
   
   
   for (int i=0; i < states.length; i++) // internal
   {
   for (int e=0; e < states.length; e++) // external
   {
   String stateInternal = states[i];
   String stateExternal = states[e];
   
   println("//" + stateInternal);
   
   for (List<Integer> stateIndices : possibleStates[e])
   {
   for (Integer R : stateIndices)
   {
   int r = R.intVal();
   String stateResult = states[r];
   println("ExternalStateMap["+stateInternal+"][" + stateExternal + "][" + stateResult + "] = 0.0f;");
   }
   }
   println();
   println();
   }
   */
  println("= {");
  for (int i=HAPPY; i < EMOTIONS_END; i++)
    for (int j=HAPPY; j < EMOTIONS_END; j++)
      for (int k=HAPPY; k < EMOTIONS_END; k++)
      {
        int index = EmotionStateTo3DIndex(i, j, k);
        //print("("+index+")");
        ExternalStateMap[index] = 3;
        //        print(ExternalStateMap[index]+"");
        //        if (index < maxStates) print(",");
      }

  for (int i=0; i<maxStates; i++)
  {
    print(ExternalStateMap[i]+"");
    if (i < maxStates-1) print(",");
  }
  println("};");
}


void draw()
{
}


int EmotionStateTo3DIndex(int ii, int jj, int kk)
{
  return (ii*EMOTIONS_END*EMOTIONS_END) + (jj*EMOTIONS_END) + kk;
}




  //far  all which aren't 0 :
/*
  //HAPPY
  Serial.println("HAPPY:");
  ExternalStateMap[HAPPY][HAPPY][HAPPY] = 5;
  ExternalStateMap[HAPPY][HAPPY][SAD] = 0;
  ExternalStateMap[HAPPY][HAPPY][ANGRY] = 0;
  ExternalStateMap[HAPPY][HAPPY][BORED] = 2;
  ExternalStateMap[HAPPY][HAPPY][DISGUSTED] = 0;
  ExternalStateMap[HAPPY][HAPPY][SURPRISED] = 0;
  ExternalStateMap[HAPPY][HAPPY][HORNY] = 2;
  ExternalStateMap[HAPPY][HAPPY][ANTISOCIAL] = 1;
  ExternalStateMap[HAPPY][HAPPY][DYING] = 0;
  ExternalStateMap[HAPPY][HAPPY][DEAD] = 0;
  ExternalStateMap[HAPPY][SAD][HAPPY] = 0;
  ExternalStateMap[HAPPY][SAD][SAD] = 4;
  ExternalStateMap[HAPPY][SAD][ANGRY] = 0;
  ExternalStateMap[HAPPY][SAD][BORED] = 0;
  ExternalStateMap[HAPPY][SAD][DISGUSTED] = 0;
  ExternalStateMap[HAPPY][SAD][SURPRISED] = 0;
  ExternalStateMap[HAPPY][SAD][HORNY] = 0;
  ExternalStateMap[HAPPY][SAD][ANTISOCIAL] = 0;
  ExternalStateMap[HAPPY][SAD][DYING] = 0;
  ExternalStateMap[HAPPY][SAD][DEAD] = 0;
  ExternalStateMap[HAPPY][ANGRY][HAPPY] = 0;
  ExternalStateMap[HAPPY][ANGRY][SAD] = 0;
  ExternalStateMap[HAPPY][ANGRY][ANGRY] = 0;
  ExternalStateMap[HAPPY][ANGRY][BORED] = 0;
  ExternalStateMap[HAPPY][ANGRY][DISGUSTED] = 0;
  ExternalStateMap[HAPPY][ANGRY][SURPRISED] = 0;
  ExternalStateMap[HAPPY][ANGRY][HORNY] = 0;
  ExternalStateMap[HAPPY][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap[HAPPY][ANGRY][DYING] = 0;
  ExternalStateMap[HAPPY][ANGRY][DEAD] = 0;
  ExternalStateMap[HAPPY][BORED][HAPPY] = 0;
  ExternalStateMap[HAPPY][BORED][SAD] = 0;
  ExternalStateMap[HAPPY][BORED][ANGRY] = 0;
  ExternalStateMap[HAPPY][BORED][BORED] = 0;
  ExternalStateMap[HAPPY][BORED][DISGUSTED] = 0;
  ExternalStateMap[HAPPY][BORED][SURPRISED] = 0;
  ExternalStateMap[HAPPY][BORED][HORNY] = 0;
  ExternalStateMap[HAPPY][BORED][ANTISOCIAL] = 0;
  ExternalStateMap[HAPPY][BORED][DYING] = 0;
  ExternalStateMap[HAPPY][BORED][DEAD] = 0;
  ExternalStateMap[HAPPY][DISGUSTED][HAPPY] = 0;
  ExternalStateMap[HAPPY][DISGUSTED][SAD] = 0;
  ExternalStateMap[HAPPY][DISGUSTED][ANGRY] = 0;
  ExternalStateMap[HAPPY][DISGUSTED][BORED] = 0;
  ExternalStateMap[HAPPY][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap[HAPPY][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap[HAPPY][DISGUSTED][HORNY] = 0;
  ExternalStateMap[HAPPY][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap[HAPPY][DISGUSTED][DYING] = 0;
  ExternalStateMap[HAPPY][DISGUSTED][DEAD] = 0;
  ExternalStateMap[HAPPY][SURPRISED][HAPPY] = 0;
  ExternalStateMap[HAPPY][SURPRISED][SAD] = 0;
  ExternalStateMap[HAPPY][SURPRISED][ANGRY] = 0;
  ExternalStateMap[HAPPY][SURPRISED][BORED] = 0;
  ExternalStateMap[HAPPY][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap[HAPPY][SURPRISED][SURPRISED] = 0;
  ExternalStateMap[HAPPY][SURPRISED][HORNY] = 0;
  ExternalStateMap[HAPPY][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap[HAPPY][SURPRISED][DYING] = 0;
  ExternalStateMap[HAPPY][SURPRISED][DEAD] = 0;
  ExternalStateMap[HAPPY][HORNY][HAPPY] = 0;
  ExternalStateMap[HAPPY][HORNY][SAD] = 0;
  ExternalStateMap[HAPPY][HORNY][ANGRY] = 0;
  ExternalStateMap[HAPPY][HORNY][BORED] = 0;
  ExternalStateMap[HAPPY][HORNY][DISGUSTED] = 0;
  ExternalStateMap[HAPPY][HORNY][SURPRISED] = 0;
  ExternalStateMap[HAPPY][HORNY][HORNY] = 0;
  ExternalStateMap[HAPPY][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap[HAPPY][HORNY][DYING] = 0;
  ExternalStateMap[HAPPY][HORNY][DEAD] = 0;
  ExternalStateMap[HAPPY][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap[HAPPY][ANTISOCIAL][SAD] = 0;
  ExternalStateMap[HAPPY][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap[HAPPY][ANTISOCIAL][BORED] = 0;
  ExternalStateMap[HAPPY][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap[HAPPY][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap[HAPPY][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap[HAPPY][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap[HAPPY][ANTISOCIAL][DYING] = 0;
  ExternalStateMap[HAPPY][ANTISOCIAL][DEAD] = 0;
  ExternalStateMap[HAPPY][DYING][HAPPY] = 0;
  ExternalStateMap[HAPPY][DYING][SAD] = 0;
  ExternalStateMap[HAPPY][DYING][ANGRY] = 0;
  ExternalStateMap[HAPPY][DYING][BORED] = 0;
  ExternalStateMap[HAPPY][DYING][DISGUSTED] = 0;
  ExternalStateMap[HAPPY][DYING][SURPRISED] = 0;
  ExternalStateMap[HAPPY][DYING][HORNY] = 0;
  ExternalStateMap[HAPPY][DYING][ANTISOCIAL] = 0;
  ExternalStateMap[HAPPY][DYING][DYING] = 0;
  ExternalStateMap[HAPPY][DYING][DEAD] = 0;
  ExternalStateMap[HAPPY][DEAD][HAPPY] = 0;
  ExternalStateMap[HAPPY][DEAD][SAD] = 0;
  ExternalStateMap[HAPPY][DEAD][ANGRY] = 0;
  ExternalStateMap[HAPPY][DEAD][BORED] = 0;
  ExternalStateMap[HAPPY][DEAD][DISGUSTED] = 0;
  ExternalStateMap[HAPPY][DEAD][SURPRISED] = 0;
  ExternalStateMap[HAPPY][DEAD][HORNY] = 0;
  ExternalStateMap[HAPPY][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap[HAPPY][DEAD][DYING] = 0;
  ExternalStateMap[HAPPY][DEAD][DEAD] = 0;


  //SAD
  Serial.println("SAD:");
  ExternalStateMap[SAD][HAPPY][HAPPY] = 3;
  ExternalStateMap[SAD][HAPPY][SAD] = 0;
  ExternalStateMap[SAD][HAPPY][ANGRY] = 0;
  ExternalStateMap[SAD][HAPPY][BORED] = 0;
  ExternalStateMap[SAD][HAPPY][DISGUSTED] = 0;
  ExternalStateMap[SAD][HAPPY][SURPRISED] = 0;
  ExternalStateMap[SAD][HAPPY][HORNY] = 0;
  ExternalStateMap[SAD][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap[SAD][HAPPY][DYING] = 0;
  ExternalStateMap[SAD][HAPPY][DEAD] = 0;
  ExternalStateMap[SAD][SAD][HAPPY] = 0;
  ExternalStateMap[SAD][SAD][SAD] = 0;
  ExternalStateMap[SAD][SAD][ANGRY] = 0;
  ExternalStateMap[SAD][SAD][BORED] = 0;
  ExternalStateMap[SAD][SAD][DISGUSTED] = 0;
  ExternalStateMap[SAD][SAD][SURPRISED] = 0;
  ExternalStateMap[SAD][SAD][HORNY] = 0;
  ExternalStateMap[SAD][SAD][ANTISOCIAL] = 0;
  ExternalStateMap[SAD][SAD][DYING] = 0;
  ExternalStateMap[SAD][SAD][DEAD] = 0;
  ExternalStateMap[SAD][ANGRY][HAPPY] = 0;
  ExternalStateMap[SAD][ANGRY][SAD] = 0;
  ExternalStateMap[SAD][ANGRY][ANGRY] = 0;
  ExternalStateMap[SAD][ANGRY][BORED] = 0;
  ExternalStateMap[SAD][ANGRY][DISGUSTED] = 0;
  ExternalStateMap[SAD][ANGRY][SURPRISED] = 0;
  ExternalStateMap[SAD][ANGRY][HORNY] = 0;
  ExternalStateMap[SAD][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap[SAD][ANGRY][DYING] = 0;
  ExternalStateMap[SAD][ANGRY][DEAD] = 0;
  ExternalStateMap[SAD][BORED][HAPPY] = 0;
  ExternalStateMap[SAD][BORED][SAD] = 0;
  ExternalStateMap[SAD][BORED][ANGRY] = 0;
  ExternalStateMap[SAD][BORED][BORED] = 0;
  ExternalStateMap[SAD][BORED][DISGUSTED] = 0;
  ExternalStateMap[SAD][BORED][SURPRISED] = 0;
  ExternalStateMap[SAD][BORED][HORNY] = 0;
  ExternalStateMap[SAD][BORED][ANTISOCIAL] = 0;
  ExternalStateMap[SAD][BORED][DYING] = 0;
  ExternalStateMap[SAD][BORED][DEAD] = 0;
  ExternalStateMap[SAD][DISGUSTED][HAPPY] = 0;
  ExternalStateMap[SAD][DISGUSTED][SAD] = 0;
  ExternalStateMap[SAD][DISGUSTED][ANGRY] = 0;
  ExternalStateMap[SAD][DISGUSTED][BORED] = 0;
  ExternalStateMap[SAD][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap[SAD][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap[SAD][DISGUSTED][HORNY] = 0;
  ExternalStateMap[SAD][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap[SAD][DISGUSTED][DYING] = 0;
  ExternalStateMap[SAD][DISGUSTED][DEAD] = 0;
  ExternalStateMap[SAD][SURPRISED][HAPPY] = 0;
  ExternalStateMap[SAD][SURPRISED][SAD] = 0;
  ExternalStateMap[SAD][SURPRISED][ANGRY] = 0;
  ExternalStateMap[SAD][SURPRISED][BORED] = 0;
  ExternalStateMap[SAD][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap[SAD][SURPRISED][SURPRISED] = 0;
  ExternalStateMap[SAD][SURPRISED][HORNY] = 0;
  ExternalStateMap[SAD][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap[SAD][SURPRISED][DYING] = 0;
  ExternalStateMap[SAD][SURPRISED][DEAD] = 0;
  ExternalStateMap[SAD][HORNY][HAPPY] = 0;
  ExternalStateMap[SAD][HORNY][SAD] = 0;
  ExternalStateMap[SAD][HORNY][ANGRY] = 0;
  ExternalStateMap[SAD][HORNY][BORED] = 0;
  ExternalStateMap[SAD][HORNY][DISGUSTED] = 0;
  ExternalStateMap[SAD][HORNY][SURPRISED] = 0;
  ExternalStateMap[SAD][HORNY][HORNY] = 0;
  ExternalStateMap[SAD][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap[SAD][HORNY][DYING] = 0;
  ExternalStateMap[SAD][HORNY][DEAD] = 0;
  ExternalStateMap[SAD][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap[SAD][ANTISOCIAL][SAD] = 0;
  ExternalStateMap[SAD][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap[SAD][ANTISOCIAL][BORED] = 0;
  ExternalStateMap[SAD][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap[SAD][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap[SAD][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap[SAD][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap[SAD][ANTISOCIAL][DYING] = 0;
  ExternalStateMap[SAD][ANTISOCIAL][DEAD] = 0;
  ExternalStateMap[SAD][DYING][HAPPY] = 0;
  ExternalStateMap[SAD][DYING][SAD] = 0;
  ExternalStateMap[SAD][DYING][ANGRY] = 0;
  ExternalStateMap[SAD][DYING][BORED] = 0;
  ExternalStateMap[SAD][DYING][DISGUSTED] = 0;
  ExternalStateMap[SAD][DYING][SURPRISED] = 0;
  ExternalStateMap[SAD][DYING][HORNY] = 0;
  ExternalStateMap[SAD][DYING][ANTISOCIAL] = 0;
  ExternalStateMap[SAD][DYING][DYING] = 0;
  ExternalStateMap[SAD][DYING][DEAD] = 0;
  ExternalStateMap[SAD][DEAD][HAPPY] = 0;
  ExternalStateMap[SAD][DEAD][SAD] = 0;
  ExternalStateMap[SAD][DEAD][ANGRY] = 0;
  ExternalStateMap[SAD][DEAD][BORED] = 0;
  ExternalStateMap[SAD][DEAD][DISGUSTED] = 0;
  ExternalStateMap[SAD][DEAD][SURPRISED] = 0;
  ExternalStateMap[SAD][DEAD][HORNY] = 0;
  ExternalStateMap[SAD][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap[SAD][DEAD][DYING] = 0;
  ExternalStateMap[SAD][DEAD][DEAD] = 0;



  //ANGRY
  Serial.println("ANGRY:");
  ExternalStateMap[ANGRY][HAPPY][HAPPY] = 0;
  ExternalStateMap[ANGRY][HAPPY][SAD] = 0;
  ExternalStateMap[ANGRY][HAPPY][ANGRY] = 0;
  ExternalStateMap[ANGRY][HAPPY][BORED] = 0;
  ExternalStateMap[ANGRY][HAPPY][DISGUSTED] = 0;
  ExternalStateMap[ANGRY][HAPPY][SURPRISED] = 0;
  ExternalStateMap[ANGRY][HAPPY][HORNY] = 0;
  ExternalStateMap[ANGRY][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap[ANGRY][HAPPY][DYING] = 0;
  ExternalStateMap[ANGRY][HAPPY][DEAD] = 0;
  ExternalStateMap[ANGRY][SAD][HAPPY] = 0;
  ExternalStateMap[ANGRY][SAD][SAD] = 0;
  ExternalStateMap[ANGRY][SAD][ANGRY] = 0;
  ExternalStateMap[ANGRY][SAD][BORED] = 0;
  ExternalStateMap[ANGRY][SAD][DISGUSTED] = 0;
  ExternalStateMap[ANGRY][SAD][SURPRISED] = 0;
  ExternalStateMap[ANGRY][SAD][HORNY] = 0;
  ExternalStateMap[ANGRY][SAD][ANTISOCIAL] = 0;
  ExternalStateMap[ANGRY][SAD][DYING] = 0;
  ExternalStateMap[ANGRY][SAD][DEAD] = 0;
  ExternalStateMap[ANGRY][ANGRY][HAPPY] = 0;
  ExternalStateMap[ANGRY][ANGRY][SAD] = 0;
  ExternalStateMap[ANGRY][ANGRY][ANGRY] = 0;
  ExternalStateMap[ANGRY][ANGRY][BORED] = 0;
  ExternalStateMap[ANGRY][ANGRY][DISGUSTED] = 0;
  ExternalStateMap[ANGRY][ANGRY][SURPRISED] = 0;
  ExternalStateMap[ANGRY][ANGRY][HORNY] = 0;
  ExternalStateMap[ANGRY][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap[ANGRY][ANGRY][DYING] = 0;
  ExternalStateMap[ANGRY][ANGRY][DEAD] = 0;
  ExternalStateMap[ANGRY][BORED][HAPPY] = 0;
  ExternalStateMap[ANGRY][BORED][SAD] = 0;
  ExternalStateMap[ANGRY][BORED][ANGRY] = 0;
  ExternalStateMap[ANGRY][BORED][BORED] = 0;
  ExternalStateMap[ANGRY][BORED][DISGUSTED] = 0;
  ExternalStateMap[ANGRY][BORED][SURPRISED] = 0;
  ExternalStateMap[ANGRY][BORED][HORNY] = 0;
  ExternalStateMap[ANGRY][BORED][ANTISOCIAL] = 0;
  ExternalStateMap[ANGRY][BORED][DYING] = 0;
  ExternalStateMap[ANGRY][BORED][DEAD] = 0;
  ExternalStateMap[ANGRY][DISGUSTED][HAPPY] = 0;
  ExternalStateMap[ANGRY][DISGUSTED][SAD] = 0;
  ExternalStateMap[ANGRY][DISGUSTED][ANGRY] = 0;
  ExternalStateMap[ANGRY][DISGUSTED][BORED] = 0;
  ExternalStateMap[ANGRY][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap[ANGRY][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap[ANGRY][DISGUSTED][HORNY] = 0;
  ExternalStateMap[ANGRY][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap[ANGRY][DISGUSTED][DYING] = 0;
  ExternalStateMap[ANGRY][DISGUSTED][DEAD] = 0;
  ExternalStateMap[ANGRY][SURPRISED][HAPPY] = 0;
  ExternalStateMap[ANGRY][SURPRISED][SAD] = 0;
  ExternalStateMap[ANGRY][SURPRISED][ANGRY] = 0;
  ExternalStateMap[ANGRY][SURPRISED][BORED] = 0;
  ExternalStateMap[ANGRY][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap[ANGRY][SURPRISED][SURPRISED] = 0;
  ExternalStateMap[ANGRY][SURPRISED][HORNY] = 0;
  ExternalStateMap[ANGRY][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap[ANGRY][SURPRISED][DYING] = 0;
  ExternalStateMap[ANGRY][SURPRISED][DEAD] = 0;
  ExternalStateMap[ANGRY][HORNY][HAPPY] = 0;
  ExternalStateMap[ANGRY][HORNY][SAD] = 0;
  ExternalStateMap[ANGRY][HORNY][ANGRY] = 0;
  ExternalStateMap[ANGRY][HORNY][BORED] = 0;
  ExternalStateMap[ANGRY][HORNY][DISGUSTED] = 0;
  ExternalStateMap[ANGRY][HORNY][SURPRISED] = 0;
  ExternalStateMap[ANGRY][HORNY][HORNY] = 0;
  ExternalStateMap[ANGRY][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap[ANGRY][HORNY][DYING] = 0;
  ExternalStateMap[ANGRY][HORNY][DEAD] = 0;
  ExternalStateMap[ANGRY][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap[ANGRY][ANTISOCIAL][SAD] = 0;
  ExternalStateMap[ANGRY][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap[ANGRY][ANTISOCIAL][BORED] = 0;
  ExternalStateMap[ANGRY][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap[ANGRY][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap[ANGRY][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap[ANGRY][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap[ANGRY][ANTISOCIAL][DYING] = 0;
  ExternalStateMap[ANGRY][ANTISOCIAL][DEAD] = 0;
  ExternalStateMap[ANGRY][DYING][HAPPY] = 0;
  ExternalStateMap[ANGRY][DYING][SAD] = 0;
  ExternalStateMap[ANGRY][DYING][ANGRY] = 0;
  ExternalStateMap[ANGRY][DYING][BORED] = 0;
  ExternalStateMap[ANGRY][DYING][DISGUSTED] = 0;
  ExternalStateMap[ANGRY][DYING][SURPRISED] = 0;
  ExternalStateMap[ANGRY][DYING][HORNY] = 0;
  ExternalStateMap[ANGRY][DYING][ANTISOCIAL] = 0;
  ExternalStateMap[ANGRY][DYING][DYING] = 0;
  ExternalStateMap[ANGRY][DYING][DEAD] = 0;
  ExternalStateMap[ANGRY][DEAD][HAPPY] = 0;
  ExternalStateMap[ANGRY][DEAD][SAD] = 0;
  ExternalStateMap[ANGRY][DEAD][ANGRY] = 0;
  ExternalStateMap[ANGRY][DEAD][BORED] = 0;
  ExternalStateMap[ANGRY][DEAD][DISGUSTED] = 0;
  ExternalStateMap[ANGRY][DEAD][SURPRISED] = 0;
  ExternalStateMap[ANGRY][DEAD][HORNY] = 0;
  ExternalStateMap[ANGRY][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap[ANGRY][DEAD][DYING] = 0;
  ExternalStateMap[ANGRY][DEAD][DEAD] = 0;


  //BORED
  Serial.println("BORED:");
  ExternalStateMap[BORED][HAPPY][HAPPY] = 0;
  ExternalStateMap[BORED][HAPPY][SAD] = 0;
  ExternalStateMap[BORED][HAPPY][ANGRY] = 0;
  ExternalStateMap[BORED][HAPPY][BORED] = 0;
  ExternalStateMap[BORED][HAPPY][DISGUSTED] = 0;
  ExternalStateMap[BORED][HAPPY][SURPRISED] = 0;
  ExternalStateMap[BORED][HAPPY][HORNY] = 0;
  ExternalStateMap[BORED][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap[BORED][HAPPY][DYING] = 0;
  ExternalStateMap[BORED][HAPPY][DEAD] = 0;
  ExternalStateMap[BORED][SAD][HAPPY] = 0;
  ExternalStateMap[BORED][SAD][SAD] = 0;
  ExternalStateMap[BORED][SAD][ANGRY] = 0;
  ExternalStateMap[BORED][SAD][BORED] = 0;
  ExternalStateMap[BORED][SAD][DISGUSTED] = 0;
  ExternalStateMap[BORED][SAD][SURPRISED] = 0;
  ExternalStateMap[BORED][SAD][HORNY] = 0;
  ExternalStateMap[BORED][SAD][ANTISOCIAL] = 0;
  ExternalStateMap[BORED][SAD][DYING] = 0;
  ExternalStateMap[BORED][SAD][DEAD] = 0;
  ExternalStateMap[BORED][ANGRY][HAPPY] = 0;
  ExternalStateMap[BORED][ANGRY][SAD] = 0;
  ExternalStateMap[BORED][ANGRY][ANGRY] = 0;
  ExternalStateMap[BORED][ANGRY][BORED] = 0;
  ExternalStateMap[BORED][ANGRY][DISGUSTED] = 0;
  ExternalStateMap[BORED][ANGRY][SURPRISED] = 0;
  ExternalStateMap[BORED][ANGRY][HORNY] = 0;
  ExternalStateMap[BORED][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap[BORED][ANGRY][DYING] = 0;
  ExternalStateMap[BORED][ANGRY][DEAD] = 0;
  ExternalStateMap[BORED][BORED][HAPPY] = 0;
  ExternalStateMap[BORED][BORED][SAD] = 0;
  ExternalStateMap[BORED][BORED][ANGRY] = 0;
  ExternalStateMap[BORED][BORED][BORED] = 0;
  ExternalStateMap[BORED][BORED][DISGUSTED] = 0;
  ExternalStateMap[BORED][BORED][SURPRISED] = 0;
  ExternalStateMap[BORED][BORED][HORNY] = 0;
  ExternalStateMap[BORED][BORED][ANTISOCIAL] = 0;
  ExternalStateMap[BORED][BORED][DYING] = 0;
  ExternalStateMap[BORED][BORED][DEAD] = 0;
  ExternalStateMap[BORED][DISGUSTED][HAPPY] = 0;
  ExternalStateMap[BORED][DISGUSTED][SAD] = 0;
  ExternalStateMap[BORED][DISGUSTED][ANGRY] = 0;
  ExternalStateMap[BORED][DISGUSTED][BORED] = 0;
  ExternalStateMap[BORED][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap[BORED][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap[BORED][DISGUSTED][HORNY] = 0;
  ExternalStateMap[BORED][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap[BORED][DISGUSTED][DYING] = 0;
  ExternalStateMap[BORED][DISGUSTED][DEAD] = 0;
  ExternalStateMap[BORED][SURPRISED][HAPPY] = 0;
  ExternalStateMap[BORED][SURPRISED][SAD] = 0;
  ExternalStateMap[BORED][SURPRISED][ANGRY] = 0;
  ExternalStateMap[BORED][SURPRISED][BORED] = 0;
  ExternalStateMap[BORED][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap[BORED][SURPRISED][SURPRISED] = 0;
  ExternalStateMap[BORED][SURPRISED][HORNY] = 0;
  ExternalStateMap[BORED][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap[BORED][SURPRISED][DYING] = 0;
  ExternalStateMap[BORED][SURPRISED][DEAD] = 0;
  ExternalStateMap[BORED][HORNY][HAPPY] = 0;
  ExternalStateMap[BORED][HORNY][SAD] = 0;
  ExternalStateMap[BORED][HORNY][ANGRY] = 0;
  ExternalStateMap[BORED][HORNY][BORED] = 0;
  ExternalStateMap[BORED][HORNY][DISGUSTED] = 0;
  ExternalStateMap[BORED][HORNY][SURPRISED] = 0;
  ExternalStateMap[BORED][HORNY][HORNY] = 0;
  ExternalStateMap[BORED][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap[BORED][HORNY][DYING] = 0;
  ExternalStateMap[BORED][HORNY][DEAD] = 0;
  ExternalStateMap[BORED][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap[BORED][ANTISOCIAL][SAD] = 0;
  ExternalStateMap[BORED][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap[BORED][ANTISOCIAL][BORED] = 0;
  ExternalStateMap[BORED][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap[BORED][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap[BORED][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap[BORED][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap[BORED][ANTISOCIAL][DYING] = 0;
  ExternalStateMap[BORED][ANTISOCIAL][DEAD] = 0;
  ExternalStateMap[BORED][DYING][HAPPY] = 0;
  ExternalStateMap[BORED][DYING][SAD] = 0;
  ExternalStateMap[BORED][DYING][ANGRY] = 0;
  ExternalStateMap[BORED][DYING][BORED] = 0;
  ExternalStateMap[BORED][DYING][DISGUSTED] = 0;
  ExternalStateMap[BORED][DYING][SURPRISED] = 0;
  ExternalStateMap[BORED][DYING][HORNY] = 0;
  ExternalStateMap[BORED][DYING][ANTISOCIAL] = 0;
  ExternalStateMap[BORED][DYING][DYING] = 0;
  ExternalStateMap[BORED][DYING][DEAD] = 0;
  ExternalStateMap[BORED][DEAD][HAPPY] = 0;
  ExternalStateMap[BORED][DEAD][SAD] = 0;
  ExternalStateMap[BORED][DEAD][ANGRY] = 0;
  ExternalStateMap[BORED][DEAD][BORED] = 0;
  ExternalStateMap[BORED][DEAD][DISGUSTED] = 0;
  ExternalStateMap[BORED][DEAD][SURPRISED] = 0;
  ExternalStateMap[BORED][DEAD][HORNY] = 0;
  ExternalStateMap[BORED][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap[BORED][DEAD][DYING] = 0;
  ExternalStateMap[BORED][DEAD][DEAD] = 0;


  //DISGUSTED
  Serial.println("DISGUSTED:");
  ExternalStateMap[DISGUSTED][HAPPY][HAPPY] = 0;
  ExternalStateMap[DISGUSTED][HAPPY][SAD] = 0;
  ExternalStateMap[DISGUSTED][HAPPY][ANGRY] = 0;
  ExternalStateMap[DISGUSTED][HAPPY][BORED] = 0;
  ExternalStateMap[DISGUSTED][HAPPY][DISGUSTED] = 0;
  ExternalStateMap[DISGUSTED][HAPPY][SURPRISED] = 0;
  ExternalStateMap[DISGUSTED][HAPPY][HORNY] = 0;
  ExternalStateMap[DISGUSTED][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap[DISGUSTED][HAPPY][DYING] = 0;
  ExternalStateMap[DISGUSTED][HAPPY][DEAD] = 0;
  ExternalStateMap[DISGUSTED][SAD][HAPPY] = 0;
  ExternalStateMap[DISGUSTED][SAD][SAD] = 0;
  ExternalStateMap[DISGUSTED][SAD][ANGRY] = 0;
  ExternalStateMap[DISGUSTED][SAD][BORED] = 0;
  ExternalStateMap[DISGUSTED][SAD][DISGUSTED] = 0;
  ExternalStateMap[DISGUSTED][SAD][SURPRISED] = 0;
  ExternalStateMap[DISGUSTED][SAD][HORNY] = 0;
  ExternalStateMap[DISGUSTED][SAD][ANTISOCIAL] = 0;
  ExternalStateMap[DISGUSTED][SAD][DYING] = 0;
  ExternalStateMap[DISGUSTED][SAD][DEAD] = 0;
  ExternalStateMap[DISGUSTED][ANGRY][HAPPY] = 0;
  ExternalStateMap[DISGUSTED][ANGRY][SAD] = 0;
  ExternalStateMap[DISGUSTED][ANGRY][ANGRY] = 0;
  ExternalStateMap[DISGUSTED][ANGRY][BORED] = 0;
  ExternalStateMap[DISGUSTED][ANGRY][DISGUSTED] = 0;
  ExternalStateMap[DISGUSTED][ANGRY][SURPRISED] = 0;
  ExternalStateMap[DISGUSTED][ANGRY][HORNY] = 0;
  ExternalStateMap[DISGUSTED][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap[DISGUSTED][ANGRY][DYING] = 0;
  ExternalStateMap[DISGUSTED][ANGRY][DEAD] = 0;
  ExternalStateMap[DISGUSTED][BORED][HAPPY] = 0;
  ExternalStateMap[DISGUSTED][BORED][SAD] = 0;
  ExternalStateMap[DISGUSTED][BORED][ANGRY] = 0;
  ExternalStateMap[DISGUSTED][BORED][BORED] = 0;
  ExternalStateMap[DISGUSTED][BORED][DISGUSTED] = 0;
  ExternalStateMap[DISGUSTED][BORED][SURPRISED] = 0;
  ExternalStateMap[DISGUSTED][BORED][HORNY] = 0;
  ExternalStateMap[DISGUSTED][BORED][ANTISOCIAL] = 0;
  ExternalStateMap[DISGUSTED][BORED][DYING] = 0;
  ExternalStateMap[DISGUSTED][BORED][DEAD] = 0;
  ExternalStateMap[DISGUSTED][DISGUSTED][HAPPY] = 0;
  ExternalStateMap[DISGUSTED][DISGUSTED][SAD] = 0;
  ExternalStateMap[DISGUSTED][DISGUSTED][ANGRY] = 0;
  ExternalStateMap[DISGUSTED][DISGUSTED][BORED] = 0;
  ExternalStateMap[DISGUSTED][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap[DISGUSTED][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap[DISGUSTED][DISGUSTED][HORNY] = 0;
  ExternalStateMap[DISGUSTED][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap[DISGUSTED][DISGUSTED][DYING] = 0;
  ExternalStateMap[DISGUSTED][DISGUSTED][DEAD] = 0;
  ExternalStateMap[DISGUSTED][SURPRISED][HAPPY] = 0;
  ExternalStateMap[DISGUSTED][SURPRISED][SAD] = 0;
  ExternalStateMap[DISGUSTED][SURPRISED][ANGRY] = 0;
  ExternalStateMap[DISGUSTED][SURPRISED][BORED] = 0;
  ExternalStateMap[DISGUSTED][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap[DISGUSTED][SURPRISED][SURPRISED] = 0;
  ExternalStateMap[DISGUSTED][SURPRISED][HORNY] = 0;
  ExternalStateMap[DISGUSTED][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap[DISGUSTED][SURPRISED][DYING] = 0;
  ExternalStateMap[DISGUSTED][SURPRISED][DEAD] = 0;
  ExternalStateMap[DISGUSTED][HORNY][HAPPY] = 0;
  ExternalStateMap[DISGUSTED][HORNY][SAD] = 0;
  ExternalStateMap[DISGUSTED][HORNY][ANGRY] = 0;
  ExternalStateMap[DISGUSTED][HORNY][BORED] = 0;
  ExternalStateMap[DISGUSTED][HORNY][DISGUSTED] = 0;
  ExternalStateMap[DISGUSTED][HORNY][SURPRISED] = 0;
  ExternalStateMap[DISGUSTED][HORNY][HORNY] = 0;
  ExternalStateMap[DISGUSTED][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap[DISGUSTED][HORNY][DYING] = 0;
  ExternalStateMap[DISGUSTED][HORNY][DEAD] = 0;
  ExternalStateMap[DISGUSTED][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap[DISGUSTED][ANTISOCIAL][SAD] = 0;
  ExternalStateMap[DISGUSTED][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap[DISGUSTED][ANTISOCIAL][BORED] = 0;
  ExternalStateMap[DISGUSTED][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap[DISGUSTED][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap[DISGUSTED][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap[DISGUSTED][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap[DISGUSTED][ANTISOCIAL][DYING] = 0;
  ExternalStateMap[DISGUSTED][ANTISOCIAL][DEAD] = 0;
  ExternalStateMap[DISGUSTED][DYING][HAPPY] = 0;
  ExternalStateMap[DISGUSTED][DYING][SAD] = 0;
  ExternalStateMap[DISGUSTED][DYING][ANGRY] = 0;
  ExternalStateMap[DISGUSTED][DYING][BORED] = 0;
  ExternalStateMap[DISGUSTED][DYING][DISGUSTED] = 0;
  ExternalStateMap[DISGUSTED][DYING][SURPRISED] = 0;
  ExternalStateMap[DISGUSTED][DYING][HORNY] = 0;
  ExternalStateMap[DISGUSTED][DYING][ANTISOCIAL] = 0;
  ExternalStateMap[DISGUSTED][DYING][DYING] = 0;
  ExternalStateMap[DISGUSTED][DYING][DEAD] = 0;
  ExternalStateMap[DISGUSTED][DEAD][HAPPY] = 0;
  ExternalStateMap[DISGUSTED][DEAD][SAD] = 0;
  ExternalStateMap[DISGUSTED][DEAD][ANGRY] = 0;
  ExternalStateMap[DISGUSTED][DEAD][BORED] = 0;
  ExternalStateMap[DISGUSTED][DEAD][DISGUSTED] = 0;
  ExternalStateMap[DISGUSTED][DEAD][SURPRISED] = 0;
  ExternalStateMap[DISGUSTED][DEAD][HORNY] = 0;
  ExternalStateMap[DISGUSTED][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap[DISGUSTED][DEAD][DYING] = 0;
  ExternalStateMap[DISGUSTED][DEAD][DEAD] = 0;


  //SURPRISED
  Serial.println("SURPRISED:");
  ExternalStateMap[SURPRISED][HAPPY][HAPPY] = 0;
  ExternalStateMap[SURPRISED][HAPPY][SAD] = 0;
  ExternalStateMap[SURPRISED][HAPPY][ANGRY] = 0;
  ExternalStateMap[SURPRISED][HAPPY][BORED] = 0;
  ExternalStateMap[SURPRISED][HAPPY][DISGUSTED] = 0;
  ExternalStateMap[SURPRISED][HAPPY][SURPRISED] = 0;
  ExternalStateMap[SURPRISED][HAPPY][HORNY] = 0;
  ExternalStateMap[SURPRISED][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap[SURPRISED][HAPPY][DYING] = 0;
  ExternalStateMap[SURPRISED][HAPPY][DEAD] = 0;
  ExternalStateMap[SURPRISED][SAD][HAPPY] = 0;
  ExternalStateMap[SURPRISED][SAD][SAD] = 0;
  ExternalStateMap[SURPRISED][SAD][ANGRY] = 0;
  ExternalStateMap[SURPRISED][SAD][BORED] = 0;
  ExternalStateMap[SURPRISED][SAD][DISGUSTED] = 0;
  ExternalStateMap[SURPRISED][SAD][SURPRISED] = 0;
  ExternalStateMap[SURPRISED][SAD][HORNY] = 0;
  ExternalStateMap[SURPRISED][SAD][ANTISOCIAL] = 0;
  ExternalStateMap[SURPRISED][SAD][DYING] = 0;
  ExternalStateMap[SURPRISED][SAD][DEAD] = 0;
  ExternalStateMap[SURPRISED][ANGRY][HAPPY] = 0;
  ExternalStateMap[SURPRISED][ANGRY][SAD] = 0;
  ExternalStateMap[SURPRISED][ANGRY][ANGRY] = 0;
  ExternalStateMap[SURPRISED][ANGRY][BORED] = 0;
  ExternalStateMap[SURPRISED][ANGRY][DISGUSTED] = 0;
  ExternalStateMap[SURPRISED][ANGRY][SURPRISED] = 0;
  ExternalStateMap[SURPRISED][ANGRY][HORNY] = 0;
  ExternalStateMap[SURPRISED][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap[SURPRISED][ANGRY][DYING] = 0;
  ExternalStateMap[SURPRISED][ANGRY][DEAD] = 0;
  ExternalStateMap[SURPRISED][BORED][HAPPY] = 0;
  ExternalStateMap[SURPRISED][BORED][SAD] = 0;
  ExternalStateMap[SURPRISED][BORED][ANGRY] = 0;
  ExternalStateMap[SURPRISED][BORED][BORED] = 0;
  ExternalStateMap[SURPRISED][BORED][DISGUSTED] = 0;
  ExternalStateMap[SURPRISED][BORED][SURPRISED] = 0;
  ExternalStateMap[SURPRISED][BORED][HORNY] = 0;
  ExternalStateMap[SURPRISED][BORED][ANTISOCIAL] = 0;
  ExternalStateMap[SURPRISED][BORED][DYING] = 0;
  ExternalStateMap[SURPRISED][BORED][DEAD] = 0;
  ExternalStateMap[SURPRISED][DISGUSTED][HAPPY] = 0;
  ExternalStateMap[SURPRISED][DISGUSTED][SAD] = 0;
  ExternalStateMap[SURPRISED][DISGUSTED][ANGRY] = 0;
  ExternalStateMap[SURPRISED][DISGUSTED][BORED] = 0;
  ExternalStateMap[SURPRISED][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap[SURPRISED][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap[SURPRISED][DISGUSTED][HORNY] = 0;
  ExternalStateMap[SURPRISED][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap[SURPRISED][DISGUSTED][DYING] = 0;
  ExternalStateMap[SURPRISED][DISGUSTED][DEAD] = 0;
  ExternalStateMap[SURPRISED][SURPRISED][HAPPY] = 0;
  ExternalStateMap[SURPRISED][SURPRISED][SAD] = 0;
  ExternalStateMap[SURPRISED][SURPRISED][ANGRY] = 0;
  ExternalStateMap[SURPRISED][SURPRISED][BORED] = 0;
  ExternalStateMap[SURPRISED][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap[SURPRISED][SURPRISED][SURPRISED] = 0;
  ExternalStateMap[SURPRISED][SURPRISED][HORNY] = 0;
  ExternalStateMap[SURPRISED][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap[SURPRISED][SURPRISED][DYING] = 0;
  ExternalStateMap[SURPRISED][SURPRISED][DEAD] = 0;
  ExternalStateMap[SURPRISED][HORNY][HAPPY] = 0;
  ExternalStateMap[SURPRISED][HORNY][SAD] = 0;
  ExternalStateMap[SURPRISED][HORNY][ANGRY] = 0;
  ExternalStateMap[SURPRISED][HORNY][BORED] = 0;
  ExternalStateMap[SURPRISED][HORNY][DISGUSTED] = 0;
  ExternalStateMap[SURPRISED][HORNY][SURPRISED] = 0;
  ExternalStateMap[SURPRISED][HORNY][HORNY] = 0;
  ExternalStateMap[SURPRISED][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap[SURPRISED][HORNY][DYING] = 0;
  ExternalStateMap[SURPRISED][HORNY][DEAD] = 0;
  ExternalStateMap[SURPRISED][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap[SURPRISED][ANTISOCIAL][SAD] = 0;
  ExternalStateMap[SURPRISED][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap[SURPRISED][ANTISOCIAL][BORED] = 0;
  ExternalStateMap[SURPRISED][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap[SURPRISED][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap[SURPRISED][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap[SURPRISED][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap[SURPRISED][ANTISOCIAL][DYING] = 0;
  ExternalStateMap[SURPRISED][ANTISOCIAL][DEAD] = 0;
  ExternalStateMap[SURPRISED][DYING][HAPPY] = 0;
  ExternalStateMap[SURPRISED][DYING][SAD] = 0;
  ExternalStateMap[SURPRISED][DYING][ANGRY] = 0;
  ExternalStateMap[SURPRISED][DYING][BORED] = 0;
  ExternalStateMap[SURPRISED][DYING][DISGUSTED] = 0;
  ExternalStateMap[SURPRISED][DYING][SURPRISED] = 0;
  ExternalStateMap[SURPRISED][DYING][HORNY] = 0;
  ExternalStateMap[SURPRISED][DYING][ANTISOCIAL] = 0;
  ExternalStateMap[SURPRISED][DYING][DYING] = 0;
  ExternalStateMap[SURPRISED][DYING][DEAD] = 0;
  ExternalStateMap[SURPRISED][DEAD][HAPPY] = 0;
  ExternalStateMap[SURPRISED][DEAD][SAD] = 0;
  ExternalStateMap[SURPRISED][DEAD][ANGRY] = 0;
  ExternalStateMap[SURPRISED][DEAD][BORED] = 0;
  ExternalStateMap[SURPRISED][DEAD][DISGUSTED] = 0;
  ExternalStateMap[SURPRISED][DEAD][SURPRISED] = 0;
  ExternalStateMap[SURPRISED][DEAD][HORNY] = 0;
  ExternalStateMap[SURPRISED][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap[SURPRISED][DEAD][DYING] = 0;
  ExternalStateMap[SURPRISED][DEAD][DEAD] = 0;


  //HORNY
  Serial.println("HORNY:");

  ExternalStateMap[HORNY][HAPPY][HAPPY] = 0;
  ExternalStateMap[HORNY][HAPPY][SAD] = 0;
  ExternalStateMap[HORNY][HAPPY][ANGRY] = 0;
  ExternalStateMap[HORNY][HAPPY][BORED] = 0;
  ExternalStateMap[HORNY][HAPPY][DISGUSTED] = 0;
  ExternalStateMap[HORNY][HAPPY][SURPRISED] = 0;
  ExternalStateMap[HORNY][HAPPY][HORNY] = 0;
  ExternalStateMap[HORNY][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap[HORNY][HAPPY][DYING] = 0;
  ExternalStateMap[HORNY][HAPPY][DEAD] = 0;
  ExternalStateMap[HORNY][SAD][HAPPY] = 0;
  ExternalStateMap[HORNY][SAD][SAD] = 0;
  ExternalStateMap[HORNY][SAD][ANGRY] = 0;
  ExternalStateMap[HORNY][SAD][BORED] = 0;
  ExternalStateMap[HORNY][SAD][DISGUSTED] = 0;
  ExternalStateMap[HORNY][SAD][SURPRISED] = 0;
  ExternalStateMap[HORNY][SAD][HORNY] = 0;
  ExternalStateMap[HORNY][SAD][ANTISOCIAL] = 0;
  ExternalStateMap[HORNY][SAD][DYING] = 0;
  ExternalStateMap[HORNY][SAD][DEAD] = 0;
  ExternalStateMap[HORNY][ANGRY][HAPPY] = 0;
  ExternalStateMap[HORNY][ANGRY][SAD] = 0;
  ExternalStateMap[HORNY][ANGRY][ANGRY] = 0;
  ExternalStateMap[HORNY][ANGRY][BORED] = 0;
  ExternalStateMap[HORNY][ANGRY][DISGUSTED] = 0;
  ExternalStateMap[HORNY][ANGRY][SURPRISED] = 0;
  ExternalStateMap[HORNY][ANGRY][HORNY] = 0;
  ExternalStateMap[HORNY][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap[HORNY][ANGRY][DYING] = 0;
  ExternalStateMap[HORNY][ANGRY][DEAD] = 0;
  ExternalStateMap[HORNY][BORED][HAPPY] = 0;
  ExternalStateMap[HORNY][BORED][SAD] = 0;
  ExternalStateMap[HORNY][BORED][ANGRY] = 0;
  ExternalStateMap[HORNY][BORED][BORED] = 0;
  ExternalStateMap[HORNY][BORED][DISGUSTED] = 0;
  ExternalStateMap[HORNY][BORED][SURPRISED] = 0;
  ExternalStateMap[HORNY][BORED][HORNY] = 0;
  ExternalStateMap[HORNY][BORED][ANTISOCIAL] = 0;
  ExternalStateMap[HORNY][BORED][DYING] = 0;
  ExternalStateMap[HORNY][BORED][DEAD] = 0;
  ExternalStateMap[HORNY][DISGUSTED][HAPPY] = 0;
  ExternalStateMap[HORNY][DISGUSTED][SAD] = 0;
  ExternalStateMap[HORNY][DISGUSTED][ANGRY] = 0;
  ExternalStateMap[HORNY][DISGUSTED][BORED] = 0;
  ExternalStateMap[HORNY][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap[HORNY][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap[HORNY][DISGUSTED][HORNY] = 0;
  ExternalStateMap[HORNY][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap[HORNY][DISGUSTED][DYING] = 0;
  ExternalStateMap[HORNY][DISGUSTED][DEAD] = 0;
  ExternalStateMap[HORNY][SURPRISED][HAPPY] = 0;
  ExternalStateMap[HORNY][SURPRISED][SAD] = 0;
  ExternalStateMap[HORNY][SURPRISED][ANGRY] = 0;
  ExternalStateMap[HORNY][SURPRISED][BORED] = 0;
  ExternalStateMap[HORNY][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap[HORNY][SURPRISED][SURPRISED] = 0;
  ExternalStateMap[HORNY][SURPRISED][HORNY] = 0;
  ExternalStateMap[HORNY][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap[HORNY][SURPRISED][DYING] = 0;
  ExternalStateMap[HORNY][SURPRISED][DEAD] = 0;
  ExternalStateMap[HORNY][HORNY][HAPPY] = 0;
  ExternalStateMap[HORNY][HORNY][SAD] = 0;
  ExternalStateMap[HORNY][HORNY][ANGRY] = 0;
  ExternalStateMap[HORNY][HORNY][BORED] = 0;
  ExternalStateMap[HORNY][HORNY][DISGUSTED] = 0;
  ExternalStateMap[HORNY][HORNY][SURPRISED] = 0;
  ExternalStateMap[HORNY][HORNY][HORNY] = 0;
  ExternalStateMap[HORNY][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap[HORNY][HORNY][DYING] = 0;
  ExternalStateMap[HORNY][HORNY][DEAD] = 0;
  ExternalStateMap[HORNY][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap[HORNY][ANTISOCIAL][SAD] = 0;
  ExternalStateMap[HORNY][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap[HORNY][ANTISOCIAL][BORED] = 0;
  ExternalStateMap[HORNY][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap[HORNY][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap[HORNY][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap[HORNY][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap[HORNY][ANTISOCIAL][DYING] = 0;
  ExternalStateMap[HORNY][ANTISOCIAL][DEAD] = 0;
  ExternalStateMap[HORNY][DYING][HAPPY] = 0;
  ExternalStateMap[HORNY][DYING][SAD] = 0;
  ExternalStateMap[HORNY][DYING][ANGRY] = 0;
  ExternalStateMap[HORNY][DYING][BORED] = 0;
  ExternalStateMap[HORNY][DYING][DISGUSTED] = 0;
  ExternalStateMap[HORNY][DYING][SURPRISED] = 0;
  ExternalStateMap[HORNY][DYING][HORNY] = 0;
  ExternalStateMap[HORNY][DYING][ANTISOCIAL] = 0;
  ExternalStateMap[HORNY][DYING][DYING] = 0;
  ExternalStateMap[HORNY][DYING][DEAD] = 0;
  ExternalStateMap[HORNY][DEAD][HAPPY] = 0;
  ExternalStateMap[HORNY][DEAD][SAD] = 0;
  ExternalStateMap[HORNY][DEAD][ANGRY] = 0;
  ExternalStateMap[HORNY][DEAD][BORED] = 0;
  ExternalStateMap[HORNY][DEAD][DISGUSTED] = 0;
  ExternalStateMap[HORNY][DEAD][SURPRISED] = 0;
  ExternalStateMap[HORNY][DEAD][HORNY] = 0;
  ExternalStateMap[HORNY][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap[HORNY][DEAD][DYING] = 0;
  ExternalStateMap[HORNY][DEAD][DEAD] = 0;


  //ANTISOCIAL
  Serial.println("ANTISOCIAL:");
  ExternalStateMap[ANTISOCIAL][HAPPY][HAPPY] = 0;
  ExternalStateMap[ANTISOCIAL][HAPPY][SAD] = 0;
  ExternalStateMap[ANTISOCIAL][HAPPY][ANGRY] = 0;
  ExternalStateMap[ANTISOCIAL][HAPPY][BORED] = 0;
  ExternalStateMap[ANTISOCIAL][HAPPY][DISGUSTED] = 0;
  ExternalStateMap[ANTISOCIAL][HAPPY][SURPRISED] = 0;
  ExternalStateMap[ANTISOCIAL][HAPPY][HORNY] = 0;
  ExternalStateMap[ANTISOCIAL][HAPPY][ANTISOCIAL] = 0;
  ExternalStateMap[ANTISOCIAL][HAPPY][DYING] = 0;
  ExternalStateMap[ANTISOCIAL][HAPPY][DEAD] = 0;
  ExternalStateMap[ANTISOCIAL][SAD][HAPPY] = 0;
  ExternalStateMap[ANTISOCIAL][SAD][SAD] = 0;
  ExternalStateMap[ANTISOCIAL][SAD][ANGRY] = 0;
  ExternalStateMap[ANTISOCIAL][SAD][BORED] = 0;
  ExternalStateMap[ANTISOCIAL][SAD][DISGUSTED] = 0;
  ExternalStateMap[ANTISOCIAL][SAD][SURPRISED] = 0;
  ExternalStateMap[ANTISOCIAL][SAD][HORNY] = 0;
  ExternalStateMap[ANTISOCIAL][SAD][ANTISOCIAL] = 0;
  ExternalStateMap[ANTISOCIAL][SAD][DYING] = 0;
  ExternalStateMap[ANTISOCIAL][SAD][DEAD] = 0;
  ExternalStateMap[ANTISOCIAL][ANGRY][HAPPY] = 0;
  ExternalStateMap[ANTISOCIAL][ANGRY][SAD] = 0;
  ExternalStateMap[ANTISOCIAL][ANGRY][ANGRY] = 0;
  ExternalStateMap[ANTISOCIAL][ANGRY][BORED] = 0;
  ExternalStateMap[ANTISOCIAL][ANGRY][DISGUSTED] = 0;
  ExternalStateMap[ANTISOCIAL][ANGRY][SURPRISED] = 0;
  ExternalStateMap[ANTISOCIAL][ANGRY][HORNY] = 0;
  ExternalStateMap[ANTISOCIAL][ANGRY][ANTISOCIAL] = 0;
  ExternalStateMap[ANTISOCIAL][ANGRY][DYING] = 0;
  ExternalStateMap[ANTISOCIAL][ANGRY][DEAD] = 0;
  ExternalStateMap[ANTISOCIAL][BORED][HAPPY] = 0;
  ExternalStateMap[ANTISOCIAL][BORED][SAD] = 0;
  ExternalStateMap[ANTISOCIAL][BORED][ANGRY] = 0;
  ExternalStateMap[ANTISOCIAL][BORED][BORED] = 0;
  ExternalStateMap[ANTISOCIAL][BORED][DISGUSTED] = 0;
  ExternalStateMap[ANTISOCIAL][BORED][SURPRISED] = 0;
  ExternalStateMap[ANTISOCIAL][BORED][HORNY] = 0;
  ExternalStateMap[ANTISOCIAL][BORED][ANTISOCIAL] = 0;
  ExternalStateMap[ANTISOCIAL][BORED][DYING] = 0;
  ExternalStateMap[ANTISOCIAL][BORED][DEAD] = 0;
  ExternalStateMap[ANTISOCIAL][DISGUSTED][HAPPY] = 0;
  ExternalStateMap[ANTISOCIAL][DISGUSTED][SAD] = 0;
  ExternalStateMap[ANTISOCIAL][DISGUSTED][ANGRY] = 0;
  ExternalStateMap[ANTISOCIAL][DISGUSTED][BORED] = 0;
  ExternalStateMap[ANTISOCIAL][DISGUSTED][DISGUSTED] = 0;
  ExternalStateMap[ANTISOCIAL][DISGUSTED][SURPRISED] = 0;
  ExternalStateMap[ANTISOCIAL][DISGUSTED][HORNY] = 0;
  ExternalStateMap[ANTISOCIAL][DISGUSTED][ANTISOCIAL] = 0;
  ExternalStateMap[ANTISOCIAL][DISGUSTED][DYING] = 0;
  ExternalStateMap[ANTISOCIAL][DISGUSTED][DEAD] = 0;
  ExternalStateMap[ANTISOCIAL][SURPRISED][HAPPY] = 0;
  ExternalStateMap[ANTISOCIAL][SURPRISED][SAD] = 0;
  ExternalStateMap[ANTISOCIAL][SURPRISED][ANGRY] = 0;
  ExternalStateMap[ANTISOCIAL][SURPRISED][BORED] = 0;
  ExternalStateMap[ANTISOCIAL][SURPRISED][DISGUSTED] = 0;
  ExternalStateMap[ANTISOCIAL][SURPRISED][SURPRISED] = 0;
  ExternalStateMap[ANTISOCIAL][SURPRISED][HORNY] = 0;
  ExternalStateMap[ANTISOCIAL][SURPRISED][ANTISOCIAL] = 0;
  ExternalStateMap[ANTISOCIAL][SURPRISED][DYING] = 0;
  ExternalStateMap[ANTISOCIAL][SURPRISED][DEAD] = 0;
  ExternalStateMap[ANTISOCIAL][HORNY][HAPPY] = 0;
  ExternalStateMap[ANTISOCIAL][HORNY][SAD] = 0;
  ExternalStateMap[ANTISOCIAL][HORNY][ANGRY] = 0;
  ExternalStateMap[ANTISOCIAL][HORNY][BORED] = 0;
  ExternalStateMap[ANTISOCIAL][HORNY][DISGUSTED] = 0;
  ExternalStateMap[ANTISOCIAL][HORNY][SURPRISED] = 0;
  ExternalStateMap[ANTISOCIAL][HORNY][HORNY] = 0;
  ExternalStateMap[ANTISOCIAL][HORNY][ANTISOCIAL] = 0;
  ExternalStateMap[ANTISOCIAL][HORNY][DYING] = 0;
  ExternalStateMap[ANTISOCIAL][HORNY][DEAD] = 0;
  ExternalStateMap[ANTISOCIAL][ANTISOCIAL][HAPPY] = 0;
  ExternalStateMap[ANTISOCIAL][ANTISOCIAL][SAD] = 0;
  ExternalStateMap[ANTISOCIAL][ANTISOCIAL][ANGRY] = 0;
  ExternalStateMap[ANTISOCIAL][ANTISOCIAL][BORED] = 0;
  ExternalStateMap[ANTISOCIAL][ANTISOCIAL][DISGUSTED] = 0;
  ExternalStateMap[ANTISOCIAL][ANTISOCIAL][SURPRISED] = 0;
  ExternalStateMap[ANTISOCIAL][ANTISOCIAL][HORNY] = 0;
  ExternalStateMap[ANTISOCIAL][ANTISOCIAL][ANTISOCIAL] = 0;
  ExternalStateMap[ANTISOCIAL][ANTISOCIAL][DYING] = 0;
  ExternalStateMap[ANTISOCIAL][ANTISOCIAL][DEAD] = 0;
  ExternalStateMap[ANTISOCIAL][DYING][HAPPY] = 0;
  ExternalStateMap[ANTISOCIAL][DYING][SAD] = 0;
  ExternalStateMap[ANTISOCIAL][DYING][ANGRY] = 0;
  ExternalStateMap[ANTISOCIAL][DYING][BORED] = 0;
  ExternalStateMap[ANTISOCIAL][DYING][DISGUSTED] = 0;
  ExternalStateMap[ANTISOCIAL][DYING][SURPRISED] = 0;
  ExternalStateMap[ANTISOCIAL][DYING][HORNY] = 0;
  ExternalStateMap[ANTISOCIAL][DYING][ANTISOCIAL] = 0;
  ExternalStateMap[ANTISOCIAL][DYING][DYING] = 0;
  ExternalStateMap[ANTISOCIAL][DYING][DEAD] = 0;
  ExternalStateMap[ANTISOCIAL][DEAD][HAPPY] = 0;
  ExternalStateMap[ANTISOCIAL][DEAD][SAD] = 0;
  ExternalStateMap[ANTISOCIAL][DEAD][ANGRY] = 0;
  ExternalStateMap[ANTISOCIAL][DEAD][BORED] = 0;
  ExternalStateMap[ANTISOCIAL][DEAD][DISGUSTED] = 0;
  ExternalStateMap[ANTISOCIAL][DEAD][SURPRISED] = 0;
  ExternalStateMap[ANTISOCIAL][DEAD][HORNY] = 0;
  ExternalStateMap[ANTISOCIAL][DEAD][ANTISOCIAL] = 0;
  ExternalStateMap[ANTISOCIAL][DEAD][DYING] = 0;
  ExternalStateMap[ANTISOCIAL][DEAD][DEAD] = 0;


  //DYING
  ExternalStateMap[DYING][HAPPY][DYING] = 8;
  ExternalStateMap[DYING][HAPPY][DEAD] = 2;
  ExternalStateMap[DYING][SAD][DYING] = 8;
  ExternalStateMap[DYING][SAD][DEAD] = 2;
  ExternalStateMap[DYING][ANGRY][DYING] = 8;
  ExternalStateMap[DYING][ANGRY][DEAD] = 2;
  ExternalStateMap[DYING][BORED][DYING] = 8;
  ExternalStateMap[DYING][BORED][DEAD] = 2;
  ExternalStateMap[DYING][DISGUSTED][DYING] = 8;
  ExternalStateMap[DYING][DISGUSTED][DEAD] = 2;
  ExternalStateMap[DYING][SURPRISED][DYING] = 8;
  ExternalStateMap[DYING][SURPRISED][DEAD] = 2;
  ExternalStateMap[DYING][HORNY][DYING] = 8;
  ExternalStateMap[DYING][HORNY][DEAD] = 2;
  ExternalStateMap[DYING][ANTISOCIAL][DYING] = 8;
  ExternalStateMap[DYING][ANTISOCIAL][DEAD] = 2;
  ExternalStateMap[DYING][DYING][DYING] = 8;
  ExternalStateMap[DYING][DYING][DEAD] = 2;
  ExternalStateMap[DYING][DEAD][DYING] = 8;
  ExternalStateMap[DYING][DEAD][DEAD] = 2;

  //DEAD
  ExternalStateMap[DEAD][HAPPY][DEAD] = 10;
  ExternalStateMap[DEAD][SAD][DEAD] = 10;
  ExternalStateMap[DEAD][ANGRY][DEAD] = 10;
  ExternalStateMap[DEAD][BORED][DEAD] = 10;
  ExternalStateMap[DEAD][DISGUSTED][DEAD] = 10;
  ExternalStateMap[DEAD][SURPRISED][DEAD] = 10;
  ExternalStateMap[DEAD][HORNY][DEAD] = 10;
  ExternalStateMap[DEAD][ANTISOCIAL][DEAD] = 10;
  ExternalStateMap[DEAD][DYING][DEAD] = 10;
  ExternalStateMap[DEAD][DEAD][DEAD] = 10;
  */

