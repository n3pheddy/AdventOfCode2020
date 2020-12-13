#import <Foundation/Foundation.h>

/**
 * Contains the result of calculating the next generation.
 */
struct NextGenerationResults {
  NSArray *nextGeneration;
  NSUInteger occupiedSeats;
};

/**
 * Contains class methods to determine whether a seat will be occupied in the next
 * generation, and finds the number of occupied seats when the configuration is stable.
 */
@interface aoc11
@end
@implementation aoc11

/**
 * Finds the value of the nearest neighbor, give a radius to look for and the
 * difference in X and Y values in each step. If the lookup reaches the edge
 * of the given lines, return '.'.
 *
 * Time complexity : O(n)
 * Space complexity: O(1)
 * Where n = radius
 */
+(unichar)findNeighbor:(NSArray *)lines
                radius:(NSUInteger)radius
                startY:(NSUInteger)startY
                startX:(NSUInteger)startX
               offsetY:(NSInteger)offsetY
               offsetX:(NSInteger)offsetX {

  unichar ch = '.';
  NSUInteger currentX = startX, currentY = startY;

  for (NSUInteger i = 0; i < radius; i++) {
    // Tests for edge conditions.
    if ( (offsetY > 0 && currentX + offsetY >= [[lines objectAtIndex:startY] length])
      || (offsetY < 0 && currentX < -offsetY)
      || (offsetX > 0 && currentY + offsetX >= [lines count])
      || (offsetX < 0 && currentY < -offsetX)) {
      break;
    }
    else {
      ch = [[lines objectAtIndex:offsetX + currentY] characterAtIndex:offsetY + currentX];

      if (ch != '.') {
        break;
      }
    }

    currentX += offsetY;
    currentY += offsetX;
  }

  return ch;
}

/**
 * Generates the next generation. radius controls how far to look for in a given direction,
 * while vacanSeatWhenAdjacent determine how many neighbors there must be in order for the
 * seat to be given up.
 *
 * Time complexity : O(mnr)
 * Space complexity: O(n)
 * Where n = [lines count], m = [[lines objectAtIndex:0] length] (length of each line), r = radius
 */
+(struct NextGenerationResults)nextGeneration:(NSArray *)lines
                                       radius:(NSUInteger)radius
                       vacantSeatWhenAdjacent:(NSUInteger)seatLimit {

  NSMutableArray *nextGeneration = [NSMutableArray array];
  NSUInteger occupiedSeats = 0;

  for (NSUInteger i = 0; i < [lines count]; i++) {
    NSString *line = [lines objectAtIndex:i];
    NSMutableString *nextLine = [NSMutableString stringWithCapacity:[line length]];

    for (NSUInteger j = 0; j < [line length]; j++) {
      NSUInteger occupiedAdjacent = 0;
      unichar ch = [line characterAtIndex:j];

      // Finds neighbor in each of the eight directions.
      for (NSInteger k = -1; k <= 1; k++) {
        for (NSInteger l = -1; l <= 1; l++) {
          if (k != 0 || l != 0) {
            if ([self findNeighbor:lines radius:radius startY:i startX:j offsetY:l offsetX:k] == '#') {
              occupiedAdjacent += 1;
            }
          }
        }
      }

      if (ch == '.') {
        [nextLine appendString:@"."];
      }
      else if (ch == 'L' && occupiedAdjacent == 0) {
        [nextLine appendString:@"#"];
        occupiedSeats += 1;
      }
      else if (ch == '#' && occupiedAdjacent >= seatLimit) {
        [nextLine appendString:@"L"];
      }
      else {
        if (ch == '#') {
          occupiedSeats += 1;
        }
        [nextLine appendFormat:@"%c", ch];
      }
    }

    [nextGeneration addObject:nextLine];
  }

  struct NextGenerationResults results;
  results.nextGeneration = nextGeneration;
  results.occupiedSeats = occupiedSeats;
  return results;
}

/**
 * Keeps looping to get the next generation of seats until the number of occupied seats is stable,
 * then returns the results.
 */
+(NSUInteger)findNumberOfOccupiedSeats:(NSArray *)lines
                                radius:(NSUInteger)radius
                vacantSeatWhenAdjacent:(NSUInteger)seatLimit {

  struct NextGenerationResults results = [aoc11 nextGeneration:lines radius:radius vacantSeatWhenAdjacent:seatLimit];
  NSUInteger occupiedSeats = results.occupiedSeats;
  NSArray *nextGeneration = results.nextGeneration;

  for (;;) {
    results = [aoc11 nextGeneration:nextGeneration radius:radius vacantSeatWhenAdjacent:seatLimit];
    nextGeneration = results.nextGeneration;

    // Assumes that if the number of occupied seats didn't change then the arrangement didn't change either.
    if (results.occupiedSeats == occupiedSeats) {
      break;
    }

    occupiedSeats = results.occupiedSeats;
  }

  return results.occupiedSeats;
}

@end

/**
 * Entry point. Does the calculation for both parts of the question (1) Looking at 1 immediate seat,
 * give up a seat when there are 4 or more adjacent occupied seats, and (2) looking to the end of
 * the row in all 8 directions, giving up a seat when there are 5 or more adjacent occupied seats.
 */
int main (int argc, const char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSString *input = [NSString stringWithContentsOfFile:@"var/aoc11_input.txt"];
  NSArray *lines = [input componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

  NSPredicate *nonEmptyString = [NSPredicate predicateWithFormat:@"length > 0"];
  NSArray *filteredLines = [lines filteredArrayUsingPredicate:nonEmptyString];

  NSUInteger occupiedSeatsUsingImmediate = [aoc11 findNumberOfOccupiedSeats:filteredLines
                                                                     radius:1
                                                     vacantSeatWhenAdjacent:4];

  NSLog(@"Number of occupied seats using immediate seats: %d", occupiedSeatsUsingImmediate);

  // Assume that length of the lines is sufficient to reach nearest neighbor.
  NSUInteger occupiedSeatsUsingNearest = [aoc11 findNumberOfOccupiedSeats:filteredLines
                                                                   radius:[filteredLines count]
                                                   vacantSeatWhenAdjacent:5];

  NSLog(@"Number of occupied seats using nearest seats: %d", occupiedSeatsUsingNearest);

  [pool drain];

  return 0;
}
