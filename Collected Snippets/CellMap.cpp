#include "WProgram.h"
#include "CellMap.h"
#include <stdint.h>
CellMap::CellMap()
{
  prog_uint32_t cellData; // one individual cell is a 32bit unsigned integer
  PROGMEM  prog_uint32_t  cellGridMap[24][24]; // declare 2d array representing the course map. each element is a prog_uint32_t  - an unsigned long (4 bytes) 0 to 4,294,967,295 of the form below.
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
}
 



