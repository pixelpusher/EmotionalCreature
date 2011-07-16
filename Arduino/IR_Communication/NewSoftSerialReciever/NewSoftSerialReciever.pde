
#include <NewSoftSerial.h>

//NewSoftSerial mySerial(4, 3);

NewSoftSerial myInvertedConn(4, -1, true); // this device uses inverted signaling

void setup()  
{
  Serial.begin(57600);
  Serial.println("Goodnight moon!");

  // set the data rate for the NewSoftSerial port
  myInvertedConn.begin(2400);
}

void loop()                     // run over and over again
{

  if (myInvertedConn.available()) {
      Serial.print((char)myInvertedConn.read());
  }
}
