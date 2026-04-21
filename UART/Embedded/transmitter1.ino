void setup(){
  Serial.begin(4800);
  delay(1000);
}

void loop(){
  	delay(100);
  	Serial.println("Hello from board 1");
  	delay(1000);
}
