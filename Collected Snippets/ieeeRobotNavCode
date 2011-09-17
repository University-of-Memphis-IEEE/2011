// Includes
// TODO

// defines and global variables.

//predefined headings
#define int east 		= 0;  // heading divides the unit circle into 256 parts 0-255
#define int northeast 	= 256 * 1/8;
#define int north		= 256 * 2/8;
#define int northwest 	= 256 * 3/8;
#define int west 		= 256 * 4/8;
#define int southwest	= 256 * 5/8;
#define int south 		= 256 * 6/8;
#define int southeast 	= 256 * 7/8;
 
uint magneticHeading = 90;
uint compassOffset = 90; 
uint currentHeading = magneticHeading + compassOffset;

uint currentXgrid;
uint currentYgrid;

uint commandedXgrid;
uint commandedYgrid;

#define long xyUnitDistance	= 500; // define the basis unit for x and y direction in terms of milliseconds at default speed.  Currently an arbitrary value.  TODO determine the number of milliseconds driveStraightForward() and driveStraightReverse() must be called to drive straight 1 grid square distance.
int leftDefaultSpeed; // may need to be a long if finer tuning required 
int rightDefaultSpeed; // to maintain uniform straight travel.

int leftFrontBumperPin;
int rightFrontBumperPin;

// Utility functions
 
void zeroCompass()// assumes robot is facing relative north
{
currentHeading = north;
compassOffset = magneticHeading;
}

void debounce(int inputPin)
{
	// TODO
}

driveStraightForward(double distance)
{
	// TODO
}

driveStraightReverse(double distance)
{
	// TODO
}

// Interrupt Service Routines

void startButtonPushed()
{
	zeroCompass();
	// TODO anything else required
	// check bumper states
	//
	//enter autonomous
	loop();
}

void leftFrontBumper()
{
	debounce(leftFrontBumperPin);
	// TODO
}

void rightFrontBumper()
{
	debounce(rightFrontBumperPin);
	// TODO
}


void main()
{
	void setup()
	{
		// TODO
	}

	void loop()
	{
		// TODO
	}
}
