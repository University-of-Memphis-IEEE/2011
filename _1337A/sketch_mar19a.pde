byte l1Pin = 1, l2Pin = 2, enable1 = 3, l3Pin = 4, l4Pin = 5, enable2 = 6, victimSwitchPin = 40;

void forwardL(byte spd) {
  digitalWrite(l1Pin, LOW);
  digitalWrite(l2Pin, HIGH);
  digitalWrite(enable1, spd);
}

void forwardR(byte spd) {
  digitalWrite(l3Pin, LOW);
  digitalWrite(l4Pin, HIGH);
  digitalWrite(enable2, spd);
}

void forward(byte spd){
  digitalWrite(l1Pin, LOW);
  digitalWrite(l2Pin, HIGH);
  digitalWrite(l3Pin, LOW);
  digitalWrite(l4Pin, HIGH);
  digitalWrite(enable1, spd);
  digitalWrite(enable2, spd);
}
    

void backR(byte spd) {
  digitalWrite(l1Pin, HIGH);
  digitalWrite(l2Pin, LOW);
  digitalWrite(enable1, spd);
}

void backL(byte spd) {
  digitalWrite(l3Pin, HIGH);
  digitalWrite(l4Pin, LOW);
  digitalWrite(enable2, spd);
}

void stopR() {
  digitalWrite(l1Pin, LOW);
  digitalWrite(l2Pin, LOW);
  digitalWrite(enable1, HIGH);
}

void stopL() {
  digitalWrite(l3Pin, LOW);
  digitalWrite(l4Pin, LOW);
  digitalWrite(enable2, HIGH);
}

void spin(boolean dir) { // true = left, false = right
  if (dir) {
    backL(255);
    forwardR(255);
  }
  else {
    backR(255);
    forwardL(255);
  }
}

void fullStop() {
  stopL();
  stopR();
}

void softL() {
  backL(1);
  forwardR(255);
}

void softR() {
  backR(1);
  forwardL(255);
}




