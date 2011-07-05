const int switchPin = 53;    // switch input
  const int Lmotor1Pin = 7;    // H-bridge leg 1 
  const int Lmotor2Pin = 8;    // H-bridge leg 2
  const int LenablePin = 9;    // H-bridge enable pin pwm
  const int Rmotor1Pin = 10;    // H-bridge leg 1 
  const int Rmotor2Pin = 11;    // H-bridge leg 2 
  const int RenablePin = 12;    // H-bridge enable pin pwm
  const int ledPin = 30;      // LED 
  const int ledGnd = 31;

  void setup() {
    // set the switch as an input:
    pinMode(switchPin, INPUT); 
    digitalWrite(switchPin, HIGH);

    // set all the other pins you're using as outputs:
    pinMode(Lmotor1Pin, OUTPUT); 
    pinMode(Lmotor2Pin, OUTPUT); 
    pinMode(LenablePin, OUTPUT);
    pinMode(ledPin, OUTPUT);
    pinMode(Rmotor1Pin, OUTPUT); 
    pinMode(Rmotor2Pin, OUTPUT); 
    pinMode(RenablePin, OUTPUT);
    pinMode(ledGnd, OUTPUT);

    // set LenablePin high so that motor can turn on:
    digitalWrite(LenablePin, HIGH); 
    digitalWrite(RenablePin, HIGH); 
    // blink the LED 3 times. This should happen only once.
    // if you see the LED blink three times, it means that the module
    // reset itself,. probably because the motor caused a brownout
    // or a short.
    blink(ledPin, 3, 1000);
  }

  void loop() 
  {
    // if the switch is high, motor will turn on one direction:
    if (digitalRead(switchPin) == HIGH) 
    {
      digitalWrite(Lmotor1Pin, LOW);   // set leg 1 of the H-bridge low
      digitalWrite(Lmotor2Pin, HIGH);  // set leg 2 of the H-bridge high
      digitalWrite(Rmotor1Pin, LOW);   // set leg 1 of the H-bridge low
      digitalWrite(Rmotor2Pin, HIGH);  // set leg 2 of the H-bridge high
    } 
    // if the switch is low, motor will turn in the other direction:
    else 
    {
      digitalWrite(Lmotor1Pin, HIGH);  // set leg 1 of the H-bridge high
      digitalWrite(Lmotor2Pin, LOW);   // set leg 2 of the H-bridge low
      digitalWrite(Rmotor1Pin, HIGH);  // set leg 1 of the H-bridge high
      digitalWrite(Rmotor2Pin, LOW);   // set leg 2 of the H-bridge low
    }
  }
  
  //remember to resolder motor wires according to signs shown on motors to make this work.
  
  forward()
  

  /*
    blinks an LED
   */
  void blink(int whatPin, int howManyTimes, int milliSecs) 
  {
    for (int i = 0; i < howManyTimes; i++) 
    {
      digitalWrite(whatPin, HIGH);
      delay(milliSecs/2);
      digitalWrite(whatPin, LOW);
      delay(milliSecs/2);
    }
  }

