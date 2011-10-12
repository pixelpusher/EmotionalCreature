
void lightFade(int ledNumber, int red, int green, int blue, int fadeLength)
{
  _copyLedCurrentToLedStart(ledNumber);
  _setLedDiff(ledNumber, 0, red);
  _setLedDiff(ledNumber, 1, green);
  _setLedDiff(ledNumber, 2, blue);
  
  ledLength[ledNumber] = fadeLength;
  ledStartTick[ledNumber] = millis();
  ledRunning[ledNumber] = true;
}
