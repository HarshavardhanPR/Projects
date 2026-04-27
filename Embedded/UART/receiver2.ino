#include <SoftwareSerial.h>
SoftwareSerial mySerial(2,3); // Rx,Tx

void setup(){
	Serial.begin(9600);
  	mySerial.begin(4800);
  	Serial.println("System Ready...");
}
/*
void  loop(){
  if(mySerial.available() > 0){
    String data = mySerial.readString();
    Serial.print("Board 2 recieved : ");
    Serial.println(data);
  }
}
*/

void loop() {
  // Check if even a single character has arrived
  if (mySerial.available() > 0) {
    
    Serial.print("Board 2 received: ");
    
    // While there is data in the buffer, read it char by char
    while (mySerial.available() > 0) {
      char c = mySerial.read();
      Serial.print(c);
      delay(2); // Tiny micro-delay to help simulation stability
    }
    
    Serial.println(); // Print a new line after the full message
  }
}
