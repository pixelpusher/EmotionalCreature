

#include <NewSoftSerial.h>


enum EmotionState
{ 
  HAPPY=0, SAD=1, ANGRY=2, BORED=3, DISGUSTED=4, SURPRISED=5,
  HUNGRY=6, HORNY=7, ANTISOCIAL=8, DYING=9, DEAD=10, EMOTIONS_END=11 
}; 


NewSoftSerial mySerial(4, 3,true);
 
char seqNum = '0'; 
 
void setup()
{
  Serial.begin(38400);
  Serial.println("starting up...");
 
  // set the data rate for the NewSoftSerial port
  mySerial.begin(2400);
 
}
 
void loop()                     // run over and over again
{
 
  char creatureId = '2';
  
  mySerial.print(creatureId);
  mySerial.print(seqNum++);
  mySerial.print(ANGRY,BYTE); // angry?
  
  if (seqNum > '9') seqNum = '0';
  
  delay(3000);
}
