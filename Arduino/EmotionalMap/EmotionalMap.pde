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
