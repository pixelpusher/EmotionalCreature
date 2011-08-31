#include <NewSoftSerial.h>

// receive port, send port
NewSoftSerial mySerial(4, 3);
 
///NewSoftSerial mySerial(4, -1, true); // this device uses inverted signaling
 
void setup()
{
  Serial.begin(57600);
  Serial.println("Goodnight moon!");
 
  // set the data rate for the NewSoftSerial port
  mySerial.begin(2400);
}
 
void loop()                     // run over and over again
{
 
  if (mySerial.available())
  {
    Serial.print((char)mySerial.read());
  }
}
