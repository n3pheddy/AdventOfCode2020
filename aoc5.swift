import Foundation

/**
  Given an array of lines with format ^([F|B]{7})([L|R]{3})$, find the missing and
  largest ID.

  Time complexity : O(10.n^3.logn)
  Space complexity: O(n)

  TODO: Can be reduced to O(10.n^2.logn^2) by performing a binary search for the
  missing ID instead of a linear search.
*/
func find(missingAndLargestIdFrom: [String]) -> (Int?, Int) {
  let identifiers: [Int] = lines
    .filter { line in line.length > 0 }
    .map { line in
      let rowSequence = line.substring(to: line.length - 3)
      let colSequence = line.substring(from: line.length - 3)

      var rowNumber = 0..<128, colNumber = 0..<9

      rowSequence.forEach { char in
        let halfway = rowNumber.lowerBound + ((rowNumber.upperBound - rowNumber.lowerBound) / 2)

        if (char == "F") {
          rowNumber = rowNumber.lowerBound..<halfway
        }
        else if (char == "B") {
          rowNumber = halfway..<rowNumber.upperBound
        }
      }

      colSequence.forEach { char in
        let halfway = colNumber.lowerBound + ((colNumber.upperBound - colNumber.lowerBound) / 2)

        if (char == "L") {
          colNumber = colNumber.lowerBound..<halfway
        }
        else if (char == "R") {
          colNumber = halfway..<colNumber.upperBound
        }
      }

      return (rowNumber.lowerBound * 8) + colNumber.lowerBound
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

let (missingId, largestId) = find(missingAndLargestIdFrom: lines)
print("Largest ID is \(largestId), my seat ID is \(missingId!)")
