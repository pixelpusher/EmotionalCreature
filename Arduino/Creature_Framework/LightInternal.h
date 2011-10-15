// --------------------------- Internal light state ---------------------------
int ledCurrent[6];
int ledStart[6];
int ledDiff[6];
int ledLength[2];
long ledStartTick[2];
boolean ledRunning[2];

void updateLight()
{
  boolean running = false;
  
  for(int led=0; led<2; led++)
  {
    if(ledRunning[led])
    {
      running = true;
      long tick = millis() - ledStartTick[led];
    
      if(tick > ledLength[led])
      {
        ledRunning[led] = false;
        tick = ledLength[led];
      }

      for(int colour=0; colour<3; colour++)
      {
        int index = led * 3 + colour; // led array index
        int val = ledStart[index] + (ledDiff[index] * tick) / ledLength[led];     
        ledCurrent[index] = val;
      }
    }
  }
  
  //Serial.print("\n");   
  
  if(running)
  {
    dimmer.setMulti(dimmer.PWM0, 
      ledCurrent[0], ledCurrent[1], ledCurrent[2], // RGB
      0, 0, 0,// Unused pins
      ledCurrent[3], ledCurrent[4], ledCurrent[5], // RGB
      0, 0,
      0, 0, 0, 0, 0, -1);
  
  }

}


// Standard functions used to set light variables up

// Copy RGB values from current led status to ledStart array
void _copyLedCurrentToLedStart(int ledNumber)
{
  for(int colour=0; colour<3; colour++)
  {
    int index = ledNumber * 3 + colour;
    ledStart[index] = ledCurrent[index];
  }
}

// Set ledDiff from ledStart and destination colour
void _setLedDiff(int ledNumber, int colourNumber, byte destination)
{
  int index = ledNumber * 3 + colourNumber;
  ledDiff[index] = destination - ledStart[index];
}
