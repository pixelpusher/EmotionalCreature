
#include <Ports.h>
#include <RF12.h>

//#include <stdlib.h>

// for itoa (int __val, char *__s, int __radix)

#define LED_PIN     9   // activity LED, comment out to disable

MilliTimer timer;

static unsigned long now () {
  // FIXME 49-day overflow
  return millis() / 1000;
}

static void activityLed (byte on) {
#ifdef LED_PIN
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, !on);
#endif
}



static char cmd;
static byte value, stack[RF12_MAXDATA], sendLen, dest;
static byte testbuf[RF12_MAXDATA], testCounter;

boolean quiet = true;
static byte nodeId = 1;
static byte groupId = 16;


void setup() {
  Serial.begin(57600);
  Serial.print("\n[RF12demo.8]");

  // set node id
  Serial.print("node id:");
  Serial.println((int)nodeId);

  // set band: 433,868, 915


  /*
    if (rf12_config()) {
   config.nodeId = eeprom_read_byte(RF12_EEPROM_ADDR);
   config.group = eeprom_read_byte(RF12_EEPROM_ADDR + 1);
   } else {
   config.nodeId = 0x41; // node A1 @ 433 MHz
   config.group = 0xD4;
   saveConfig();
   }
   */

  // void rf12_initialize(byte nodeId, byte freqBand, byte netGroup =212);

  // the ID of this wireless node. ID's should be unique within the netGroup
  // in which this node is operating. The range for ID's is 0 to 31, but only 1..30 
  // are available for normal use. You can pass a single capital letter as node ID,
  //  with 'A' .. 'Z' corresponding to the node ID's 1..26, but this convention is 
  // now discouraged. ID 0 is reserved for OOK use, node ID 31 is special because 
  // it will pick up packets for any node (in the same netGroup).

  rf12_initialize(nodeId, RF12_868MHZ);
}


void loop() 
{  
  // console commands
  // if (Serial.available())
  //   handleInput(Serial.read());

// send every second
  if (timer.poll(50))
  {
    testSend();
  }


  // recieve a command
  if (rf12_recvDone()) {
    byte n = rf12_len;

    if (rf12_crc == 0)
    {
      Serial.print("OK");
    } 
    else
    {
      if (quiet)
        return;
      Serial.print(" ?");
      if (n > 20) // print at most 20 bytes if crc is wrong
        n = 20;
    }

    Serial.print(' ');
    Serial.print((int) rf12_hdr);
    for (byte i = 0; i < n; ++i) {
      Serial.print(' ');
      Serial.print((int) rf12_data[i]);
    }
    Serial.println();

    if (rf12_crc == 0) 
    {
      activityLed(1);

      if (RF12_WANTS_ACK)
      {
        Serial.println(" -> ack");
        rf12_sendStart(RF12_ACK_REPLY, 0, 0);
      }

      activityLed(0);
    }
  }


  // send a command
  if (cmd && rf12_canSend()) {
    activityLed(1);

    Serial.print(" -> ");
    Serial.print((int) sendLen);
    Serial.println(" b");
//    byte header = cmd == 'a' ? RF12_HDR_ACK : 0;
  byte header = 0;
    if (dest)
      header |= RF12_HDR_DST | dest;
    rf12_sendStart(header, testbuf, sendLen);
    cmd = 0;

    activityLed(0);
  }
}


void testSend()
{
    cmd = 'm';
    sendLen = 9;
    dest = 2-nodeId+1;
    for (byte b=0; b<sendLen; b++)
      testbuf[b] = b;
}

// reset cmd stack
//memset(stack, 0, sizeof stack);


