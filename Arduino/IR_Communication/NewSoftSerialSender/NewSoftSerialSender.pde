
#include <NewSoftSerial.h>

NewSoftSerial mySerial(4, 3);

void setup()  
{
  Serial.begin(57600);
  Serial.println("Goodnight moon!");

  // set the data rate for the NewSoftSerial port
  mySerial.begin(9600);
  
}

void loop()                     // run over and over again
{

  mySerial.println("Hello, world?");
  delay(1500);
}
