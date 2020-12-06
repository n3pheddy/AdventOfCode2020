import Foundation

/**
  Performs a binary partition search, given a lowerChar selecting the lower half,
  upperChar selecting the upper half, startingRange to begin partitioning, and a
  sequence to read, partition, and select the ranges. Returns the lower bound of
  the final range.

  Time complexity : O(n)
  Space complexity: O(1)
  Where n is the number of characters in the sequence.
*/
func findNumberFromSequence(
  lowerChar: Character,
  upperChar: Character,
  startingRange: Range<Int>,
  sequence: String) -> Int {
  var currentRange = startingRange.lowerBound..<startingRange.upperBound

  sequence.forEach { char in
    let halfway = currentRange.lowerBound + ((currentRange.upperBound - currentRange.lowerBound) / 2)

    if (char == lowerChar) {
      currentRange = currentRange.lowerBound..<halfway
    }
    else if (char == upperChar) {
      currentRange = halfway..<currentRange.upperBound
    }
  }

  return currentRange.lowerBound
}

/**
  Given an array of lines with format ^([F|B]{7})([L|R]{3})$, find the missing and
  largest ID.

  Time complexity : O(m.n^3.logn)
  Space complexity: O(n)
  Where m is the length of line, n is the number of lines.

  TODO: Can be reduced to O(m.n^2.logn^2) by performing a binary search for the
  missing ID instead of a linear search.
*/
func findMissingAndLargestId(from: [String]) -> (Int?, Int) {
  let identifiers: [Int] = lines
    .filter { line in line.length > 0 }
    .map { line in
      let rowSequence = line.substring(to: line.length - 3)
      let colSequence = line.substring(from: line.length - 3)

      let rowNumber = findNumberFromSequence(lowerChar: "F", upperChar: "B", startingRange: 0..<128, sequence: rowSequence)
      let colNumber = findNumberFromSequence(lowerChar: "L", upperChar: "R", startingRange: 0..<9, sequence: colSequence)

      return (rowNumber * 8) + colNumber
    }
    .sorted()

    let offset = identifiers[0]

    for index in 0...identifiers.count {
      if ((index + offset) != identifiers[index]) {
        return ((index + offset), identifiers[identifiers.count - 1])
      }
    }

    // Should never reach here for the puzzle.
    return (nil, identifiers[identifiers.count - 1])
}

let filePath = "var/aoc5_input.txt"

let contents = try String(contentsOfFile: filePath)
let lines = contents.components(separatedBy: .newlines)

let (missingId, largestId) = findMissingAndLargestId(from: lines)
print("Largest ID is \(largestId), my seat ID is \(missingId!)")
