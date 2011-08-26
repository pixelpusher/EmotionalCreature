#include <NewSoftSerial.h>
 
//NewSoftSerial mySerial(4, 3);
NewSoftSerial mySerial(4, 3, true); // this device uses inverted signaling
 
void setup()
{
  Serial.begin(57600);
  Serial.println("Goodnight moon!");
 
  // set the data rate for the NewSoftSerial port
  mySerial.begin(2400);
 
}
 
void loop()                     // run over and over again
{
 
  mySerial.println("Hello, world?");
  delay(3000);
}
