
// --------------------------- Internal sound state used by sound and tone functons ---------------------------
long soundStartTick;
int soundLength;
int soundStartFreq;
int soundInt1;
int soundInt2;
long soundDiff;
boolean soundPlaying = false;

int toneInt1;
int toneInt2;
int toneInt3;
int toneInt4;

void (*soundFunc)(long); // current sound generating function
int (*toneFunc)(int, long); // current tone manipulation function



// --------------------------- Run sound function each tick ---------------------------
void updateSound()
{
  if(soundPlaying)
    (*soundFunc)(millis() - soundStartTick);
}

// Start a defined sound off
void _startSound()
{
  soundStartTick = millis();
  soundPlaying = true; 
}

// --------------------------- Sound generation ---------------------------

void _soundRamp(long tick)
{
  int freq = soundStartFreq + (soundDiff * tick) / soundLength;
  
  tone(soundPin, (*toneFunc)(freq, tick));
  if(tick > soundLength)
  {
    noTone(soundPin);
    soundPlaying = false;
  }
}

void _soundNote(long tick)
{
  tone(soundPin, (*toneFunc)(soundStartFreq, tick));
  if(tick > soundLength)
  {
    noTone(soundPin);
    soundPlaying = false;
  }
}

void _soundWave(long tick)
{
  // soundDiff = amplitud;
  // soundInt1 = cycleLength;
  
  int angle = (tick * 360) / soundInt1;
  int freq = soundStartFreq + fastSin(angle, soundDiff);
  
  tone(soundPin, (*toneFunc)(freq, tick));
  
  if(tick > soundLength)
  {
    noTone(soundPin);
    soundPlaying = false;
  }
}

// --------------------------- Tone generators ---------------------------

int _toneSimple(int inputFreq, long tick)
{
    return inputFreq;
}

int _toneRandom(int inputFreq, long tick)
{
  // toneInt1 = spreadFreq;
  // toneInt2 = individualNoteLength;
  
  if(toneInt3 <= tick || toneInt3 > (tick + toneInt2)) // Change frequency if toneInt3 is hit, or toneInt3 is set too far in advance (eg. if sample replayed)
  {
    toneInt4 = random(0, toneInt1); // Set random frequency
    toneInt3 = tick + toneInt2; // Set next note change 
  }  
  return inputFreq + toneInt4;
}

int _toneChord(int inputFreq, long tick)
{
  // toneInt1 = spreadFreq;
  // toneInt2 = count
  // toneInt3 = individualNoteLength;

  int chord = tick / toneInt3;
  return inputFreq + toneInt1 * (chord % toneInt2);
}

int _toneWave(int inputFreq, long tick)
{
  // toneInt1 = amplitud;
  // toneInt2 = cycleLength;

  int angle = (tick * 360) / toneInt2;
  int freq = fastSin(angle, toneInt1);
  return inputFreq + freq;
}
