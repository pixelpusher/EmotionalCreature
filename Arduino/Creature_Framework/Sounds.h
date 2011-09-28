// --------------------------- Set tone types ---------------------------

// Simple flat tones
void setInstrumentSimple()
{
  toneFunc = &_toneSimple;
}

// Simple flat tones
void setInstrumentRandom(int spreadFreq, int individualNoteLength)
{
  toneInt1 = spreadFreq;
  toneInt2 = individualNoteLength;
  toneInt3 = 0;
  toneFunc = &_toneRandom;
}

// play a chord with count number of notes with spreadFreq hz between them
void setInstrumentChord(int spreadFreq, int count, int individualNoteLength)
{
  toneInt1 = spreadFreq;
  toneInt2 = count;
  toneInt3 = individualNoteLength;
  
  toneFunc = &_toneChord;
}

// Sin wave note
void setInstrumentWave(int amplitud, int cycleLength)
{
  toneInt1 = amplitud;
  toneInt2 = cycleLength;
  toneFunc = &_toneWave;
}

// --------------------------- Sound playing functions ---------------------------

// Play a sound ramp
void playSoundNote(int freq, int length)
{
  // Set state for this sound type
  soundStartFreq = freq;
  soundLength = length;
  soundFunc = &_soundNote;
  
  _startSound();
}

// Play a sound ramp
void playSoundRamp(int startFreq, int endFreq, int length)
{
  // Set state for this sound type
  soundStartFreq = startFreq;
  soundLength = length;
  soundDiff = endFreq - startFreq;
  soundFunc = &_soundRamp;
  
  _startSound();
}

// Play sin wave sound
void playSoundWave(int startFreq, int amplitud, int cycleLength, int length)
{
  soundStartFreq = startFreq;
  soundDiff = amplitud;
  soundInt1 = cycleLength;
  soundLength = length;
  soundFunc = &_soundWave;
  
  _startSound();
}
