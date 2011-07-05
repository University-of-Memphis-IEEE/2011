#include <EEPROM.h>
#include <VoiceShield.h>
#include <Wire.h>					//Include I2C library.

#define viewer 0x50

long starDate = 2011020710;
int launchTime = 0;
VoiceShield SubSpace(80);
int whenReady = 0;
int viewDig3 = 0x23;                          
int viewDig2 = 0x22;
int viewDig1 = 0x21;
int viewDig0 = 0x20;
int startdigit = 0;

int MasterX = 12;					//current X coordinate
int MasterY = 1;					//current Y coordinate
int MasterDir = 0;					//Current Facing
int DirOffset = 0;					//offset between top of map and compass north

void setup() {
	Serial.begin(9600);
	digitalWrite(32, HIGH);			//Start Button
	pinMode(32, INPUT);
	pinMode(20, OUTPUT);			//I2C transmit pin
	Wire.begin();					//Join I2C bus
	Wire.beginTransmission(viewer);
		Wire.send(0x04);			// select configuration register
		Wire.send(0x01);			// disable shutdown;
		Wire.send(0x01);			// Digits 0 and 2 intensity
		Wire.send(0x33);			//10 ma
		Wire.send(0x02);			//Digits Digit 1 and 3 intensity
		Wire.send(0x33);			//10 ma
		Wire.send(0x07);			//all segments
		Wire.send(0x01);			//all on
	Wire.endTransmission();	
}
void loop() {
	if (starDate == 2011020710) { //initialization sequence
		//starMap();
		//delay(3000);
		//displayMap();
		starDate++;
		Wire.beginTransmission(viewer);
			Wire.send(0x07);		//all segments
			Wire.send(0x00);		//all off
		Wire.endTransmission();
		SubSpace.ISDPLAY_to_EOM(17);
	}
	whenReady = digitalRead(32);
	if (whenReady == LOW && starDate > 2011020710){
		launchTime = micros();
		Kirk();
	}
}
/*	Map	*/
void displayMap() {
	int contents = 0;
	for(int row = 24; row >= 0; row--) {
		for(int col = 0; col < 25; col++) {
			contents = EEPROM.read(25 * row + col);
			Serial.print(contents, DEC);
			if (contents < 10) Serial.print("  ");
			else Serial.print(" ");
		}
		Serial.println();
	}
	Serial.println("\n\n");
}
void starMap() {
	for(int off = 0; off < 625; off++) {                                                                                                                                                                                        
		EEPROM.write(off, 0);
	}
	for(int off = 0; off < 24; off++) {	// Outer Walls
		EEPROM.write(off, EEPROM.read(off) + 2);
		EEPROM.write(off + 1, EEPROM.read(off + 1) + 8);
		EEPROM.write(600 + off, EEPROM.read(600 + off) + 2);
		EEPROM.write(600 + off + 1, EEPROM.read(600 + off + 1) + 8);
		EEPROM.write(25 * off, EEPROM.read(25 * off) + 1);
		EEPROM.write(25 * (off + 1), EEPROM.read(25 * (off + 1)) + 4);
		EEPROM.write(24 + 25 * off, EEPROM.read(24 + 25 * off) + 1);
		EEPROM.write(24 + 25 * (off + 1), EEPROM.read(24 + 25 * (off + 1)) + 4);
	}
	for(int off = 0; off < 10; off++) { // Inner Long Walls
		EEPROM.write(350 + off, EEPROM.read(350 + off) + 2);
		EEPROM.write(350 + off + 1, EEPROM.read(350 + off + 1) + 8);
		EEPROM.write(364 + off, EEPROM.read(364 + off) + 2);
		EEPROM.write(364 + off + 1, EEPROM.read(364 + off + 1) + 8);
		EEPROM.write(10 + 25 * off, EEPROM.read(10 + 25 * off) + 1);
		EEPROM.write(10 + 25 * (off + 1), EEPROM.read(10 + 25 * (off + 1)) + 4);
		EEPROM.write(14 + 25 * off, EEPROM.read(14 + 25 * off) + 1);
		EEPROM.write(14 + 25 * (off + 1), EEPROM.read(14 + 25 * (off + 1)) + 4);
	}
	for(int off = 0; off < 6; off++) { // Inner Short Walls
		EEPROM.write(254 + off, EEPROM.read(254 + off) + 2);
		EEPROM.write(254 + off + 1, EEPROM.read(254 + off + 1) + 8);
		EEPROM.write(264 + off, EEPROM.read(264 + off) + 2);
		EEPROM.write(264 + off + 1, EEPROM.read(264 + off + 1) + 8);
		EEPROM.write(360 + 25 * off, EEPROM.read(360 + 25 * off) + 1);
		EEPROM.write(360 + 25 * (off + 1), EEPROM.read(360 + 25 * (off + 1)) + 4);
		EEPROM.write(364 + 25 * off, EEPROM.read(374 + 25 * off) + 1);
		EEPROM.write(364 + 25 * (off + 1), EEPROM.read(374 + 25 * (off + 1)) + 4);
	}
}
/*	Map end	*/
/*	Kirk	*/
void Kirk () {
	int foundVic = -1;
	int navReport = -1;
	int clock = 0;
	SubSpace.ISDPLAY_to_EOM(40);		// Play Star Trek Theme Intro
	navReport = warp3 (12, 12);
	//process navReport.........
	navReport = warp3 (22, 12);
	//process navReport.........
	while (clock < 50) {
		navReport = Sulu (2, 22, 10);		// Standard Orbit (clockwise) in Room 4
		if (navReport == 3) {				// Victim found
			foundVic = Spock ();
			Uhura (MasterX, MasterY, foundVic);
		}
		clock = (micros() - launchTime) / 1000000;
	}
	navReport = warp3 (2, 12);
	//process navReport.........
	while (clock < 110) {
		navReport = Sulu (3, 2, 10);			// Reverse Orbit (counter-clockwise) in Room 1
		if (navReport == 3) {
			foundVic = Spock ();
			Uhura (MasterX, MasterY, foundVic);
		}
	}
	navReport = warp3 (12, 22);
	//process navReport.........
	while (clock < 170) {
		navReport = Sulu (2, 2, 14);			// Standard Orbit (clockwise) in Room 3
		if (navReport == 3) {
			foundVic = Spock ();
			Uhura (MasterX, MasterY, foundVic);
		}
	}
	while (clock < 250) {
		navReport = Sulu (3, 2, 10);			// Reverse Orbit (counter-clockwise) in Room 2
		if (navReport == 3) {
			foundVic = Spock ();
			Uhura (MasterX, MasterY, foundVic);
		}
	}
}
int warp3 (int x, int y) {
	int nr = 0;
	int foundVic = 0;

	while (nr < 2) {
		nr = Sulu (1, x, y);	// Normal move to location x, y
		if (nr == 0) {
			foundVic = Spock();
		}
		if (MasterX == 23 && MasterY == 12) {
			nr = 2;
		}
	}
	return (nr);
}
int locateQuadrant(int x, int y) {
	int room = 0;
	if (x < 1 || x > 23 || y < 1 || y > 23) room = 6; // beyond map
	else if(x < 10 && y < 10) room = 1;
	else if(x > 14 && y > 14) room = 3;
	else if(x > 14 && y < 10) room = 4;
	else if(x < 10 && y > 14) room = 2;
	else room = 5;	// hallway
	return (room);
}
void indicatorPanel(int val) {
	
}
/*	Kirk end	*/
/*	Spock	*/
int  Spock() {						//-1 if error, 0=dead, 1=unconscious, 2=conscious, 3=hazard

}
/*	Spock end	*/
/*	Sulu	*/
int Sulu(int moveType, int TX, int TY) {			//0 = are we there yet? 2 = we appear to be there 3 = on victim 4 = unable to complete task 5 = warp core breach

}
/*	Sulu end	*/
/*	Uhura	*/
void Uhura (int x, int y, int found) {
	int room = 0;

	room = locateQuadrant(x, y);
	if (room == 2 || room == 3) y -= 14;
	if (room == 3 || room == 4) x -= 14;
	if (room < 5) {
		transmitSignal (found, room, x, y);
		openChannel (found, room, x, y);
	}
}
void openChannel (int found, int room, int x, int y) {
	SubSpace.ISDPLAY_to_EOM(found + 12);
	SubSpace.ISDPLAY_to_EOM(room);
	if (found != 4) {
		SubSpace.ISDPLAY_to_EOM(11);
		SubSpace.ISDPLAY_to_EOM(x);
		SubSpace.ISDPLAY_to_EOM(y);
	}
}
void transmitSignal (int found, int room, int x, int y) {	// Display Panel
	onScreen(room, viewDig0);
	if (found != 4) {
		onScreen(x, viewDig1);
		onScreen(y, viewDig2);
		onScreen(found, viewDig3);
	}
	else {
		onScreen(11, viewDig1);
		onScreen(11, viewDig2);
		onScreen(11, viewDig3);
	}
}
void onScreen(byte value, byte disp)
{
    Wire.beginTransmission(viewer);
		Wire.send(disp);			// which panel?  
		if (value == '\0') Wire.send(' ');
		else Wire.send(value);
    Wire.endTransmission();
}
/*	Uhura end	*/
