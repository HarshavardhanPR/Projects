#include <SoftwareSerial.h>
SoftwareSerial mySerial(2,3); //Rx,Tx

void setup(){
  mySerial.begin(4800);
  delay(1000);
}

void loop(){
  	delay(100);
  	mySerial.println("Hello world");
  	delay(1000);
}
