voidsetup()
{ 
	Serial.begin(9600); 
}


void loop() {
if (Serial.available() > 0)  // Check if data is coming in
{   
    String incomingData = Serial.readString(); // Read the message
    Serial.print("Received: ");
    Serial.println(incomingData); // Print to Serial Monitor
  }
}
