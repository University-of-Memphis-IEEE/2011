#ifndef CellMap_h
#define CellMap_h

#include "WProgram.h"
#include "Cell.h"
#include <avr/pgmspace.h>


class CellMap
{
  public:
    CellMap();
    void setCell(byte X, byte Y, unsigned long cellData);// specify cell location on big map and CellData
    void setCell(byte room, byte roomX, byte roomY, unsigned long cellData);// specify room number, cell location on small room map, and CellData
    unsigned long getCell(byte room, byte roomX, byte roomY);
    unsigned long getCell(byte X, byte Y);
    byte getByte0(byte X, byte Y);
    byte getByte1(byte X, byte Y);
    byte getByte2(byte X, byte Y);
    byte getByte3(byte X, byte Y);
    void setByte0(byte X, byte Y, byte zeroByte);
    void setByte1(byte X, byte Y, byte oneByte);
    void setByte2(byte X, byte Y, byte twoByte);
    void setByte3(byte X, byte Y, byte threeByte);
    boolean isOnLine(byte X, byte Y);
    boolean isDoorway(byte X, byte Y);
    boolean visited(byte X, byte Y);
    boolean hasWall(byte X, byte Y);
    boolean hasLine(byte X, byte Y);
  private:
PROGMEM  prog_uint32_t  cellMap[24][24]; 

//       dynamic data/objects in cell  byte 0: bit 7 = victimStateBit1, bit 6 = victimStateBit0, bit 5 = ,            bit 4 = obstaclePresent, bit 3 = obstacleLarge, bit 2 = hazardPresent, bit 1 = visited,     bit 0 = clearToNavigateThrough
//X,Y coordinates of cell within room  byte 1: bit 7 = subMapXBCD3,     bit 6 = subMapXBCD2,     bit 5 = subMapXBCD1, bit 4 = subMapXBCD0,     bit 3 = subMapYBCD3,   bit 2 = subMapYBCD2,   bit 1 = subMapYBCD1, bit 0 = subMapYBCD0
//         static data about cell      byte 2: bit 7 = ,                bit 6 = ,                bit 5 = ,            bit 4 = ,                bit 3 = isDoorway,     bit 2 = isRoom,        bit 1 = roomNumBit1, bit 0 = roomNumBit0 
//         static data about cell      byte 3: bit 7 = eastLine         bit 6 = northLine,       bit 5 = westLine,    bit 4 = southLine,       bit 3 = eastWall,      bit 2 = northWall,     bit 1 = westWall,    bit 0 = southWall 
/*
// NOT USED!! lineBit0-1: no line = (b000xxxxx), straight LineL/R intersection = (b111xxxxx), line goes left (b10xxxxxx), line goes right (b01xxxxxx)
// NOT USED!! may recycle available 3 unused bits, each room may have multiple walls.  hasWall wallBit0-1: no wall(bxx0xxxxx), south wall(bxx100xxx), west wall(bxx101xxx), north wall(bxx110xxx), east wall(bxx111xxx),
additional notes
Byte 0:
victimStateBit0-1: display 0=dead(b00xxxxxx), 1=unconscious(b01xxxxxx), 2=conscious(b10xxxxxx), no display 3= (b11xxxxxx)
Byte 1:
high nibble is binary coded decimal representation of X coordinate of cell within room
low nibble is binary coded decimal representation of Y coordinate of cell within room
Byte 2:
isDoorway defined as the 4 cells immediately adjacent to a room(!isRoom) that have no walls in the direction of the room.
isRoom roomNumBit0-1: room 1 southwest = (bxxxxx100), room 2 northwest = (bxxxxx101), room 3 northeast = (bxxxxx110), room 4 southeast = (bxxxxx111)
                   hallwaySouth = (bxxxxx000),      hallwayWest = (bxxxxx001),     hallwayNorth = (bxxxxx010),      hallwayEast = (bxxxxx011)
    A. The course is a 2.44 m x 2.44 m square containing rooms and hallways. Refer to
    the appendix for a diagram.
    B. There are four rooms, one in each corner of the course. Each room is 1 m x 1 m
    square.
    C. Each room has a unique number, where room number one starts is in the
    southwest corner of the course and increments by one in a clockwise direction,
    ending with room number four in the southeast corner of the course.
Byte 3:
Location of any walls or lines bordering the cell.  Both walls and lines are only on the perimeter, therefore while the robot is line following, it is traveling on the border between cells.
*/









// dont use this form
//               prog_uint32_t  - an unsigned long (4 bytes) 0 to 4,294,967,295
// byte 0.7-5 subGribBits

//    static data about cell      byte 0: bit 7 = subGridBit2,   bit 6 = subGridBit1,      bit 5 = subGridBit0,       bit 4 = isDoorway,              bit 3 = isStartPad,    bit 2 = isRoom,        bit 1 = roomNumBit1,      bit 0 = roomNumBit0 
//    static data about cell      byte 1: bit 7 = hasLine,       bit 6 = lineBranchesBit1, bit 5 = lineBranchesBit0,  bit 4 = ,                       bit 3 = eastWall,      bit 2 = northWall,     bit 1 = westWall,         bit 0 = southWall 
//dynamic data/objects on course  byte 2: bit 7 = victimPresent, bit 6 = victimAlive,      bit 5 = victimConscious,   bit 4 = obstaclePresent,        bit 3 = obstacleLarge, bit 2 = hazardPresent, bit 1 = ,                 bit 0 = clearToNavigateThrough
//dynamic data/objects on course  byte 3: bit 7 = ,              bit 6 = ,                 bit 5 = ,                  bit 4 = ,                       bit 3 = ,              bit 2 = ,              bit 1 = ,                 bit 0 = 
 prog_uint32_t _cellData; 
};

#endif
