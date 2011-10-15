// --------------------------- Set color types ---------------------------

// Simple flat colors
void setColorSimple()
{
  colorFunc = &_colorSimple;
}

// Simple flat colors
void setColorRandom(int spreadFreq, int individualNoteLength)
{
  colorInt1 = spreadFreq;
  colorInt2 = individualNoteLength;
  colorInt3 = 0;

}

// play a chord with count number of notes with spreadFreq hz between them
void setColorChord(int spreadFreq, int count, int individualNoteLength)
{
  colorInt1 = spreadFreq;
  colorInt2 = count;
  colorInt3 = individualNoteLength;
  

}

// Sin wave note
void setColorWave(int amplitude, int cycleLength)
{
  colorInt1 = amplitude;
  colorInt2 = cycleLength;

}

// --------------------------- Light playing functions ---------------------------

// Play a light ramp
void playLightNote(int freq, int length)
{
  // Set state for this light type
  lightStartFreq = freq;
  lightLength = length;

  
  _startLight();
}

// Play a light ramp
void playLightRamp(int startFreq, int endFreq, int length)
{
  // Set state for this light type
  lightStartFreq = startFreq;
  lightLength = length;
  lightDiff = endFreq - startFreq;
  lightFunc = &_lightRamp;
  
  _startLight();
}

// Play sin wave light
void playLightWave(int startFreq, int amplitude, int cycleLength, int length)
{
  lightStartFreq = startFreq;
  lightDiff = amplitude;
  lightInt1 = cycleLength;
  lightLength = length;
  lightFunc = &_lightWave;
  
  _startLight();
}
