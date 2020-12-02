const fs = require('fs');
const readline = require('readline');

/**
 * Returns the number of valid lines by treating the first token as two 1-index
 * positions where exactly one of it must be the given letter.
 * 
 * Time complexity : O(n)
 * Space complexity: O(1)
 * Where n = len(lines)
 */
function count_positions(lines) {
  var valid = 0;

  for (const line of lines) {
    const tokens = line.split(' ');
    const range = tokens[0];
    const letter = tokens[1].substr(0, tokens[1].length - 1);
    const password = tokens[2];

    const firstPosition = parseInt(range.substr(0, range.indexOf('-'))) - 1;
    const secondPosition = parseInt(range.substr(range.indexOf('-') + 1)) - 1;

    var found = false;

    [firstPosition, secondPosition].forEach(pos => {
      if (password[pos] === letter) {
        found = !found;
      }
    });

    if (found) {
      valid += 1;
    }
  }

  return valid;
}

/**
 * Returns the number of valid lines by treating the first token as a range of
 * valid number of occurrences for the given letter.
 * 
 * Time complexity : O(m*n)
 * Space complexity: O(m)
 * Where m = number of characters in each password, n = len(lines)
 */
function count_occurrences(lines) {
  var valid = 0;

  for (const line of lines) {
    const tokens = line.split(' ');
    const range = tokens[0];
    const letter = tokens[1].substr(0, tokens[1].length - 1);
    const password = tokens[2];
    const counter = {};

    const lowest = range.substr(0, range.indexOf('-'));
    const highest = range.substr(range.indexOf('-') + 1);

    for (const c in password) {
      const count = counter[password[c]] || 0;
      counter[password[c]] = count + 1;
    }

    if (typeof(counter[letter]) !== 'undefined'
      && counter[letter] >= lowest && counter[letter] <= highest) {
        valid += 1;
    }
  }

  return valid;
}

/**
 * Reads contents from file and returns an array of strings for each line.
 */
async function read_input() {
  const input = readline.createInterface({
    input: fs.createReadStream('var/aoc2_input.txt')
  });

  var lines = [];

  for await (const line of input) {
    lines.push(line);
  }

  return lines;
}

/**
 * Entry point. Reads contents from file and invokes the 2 search functions.
 */
async function main() {
  const input = await read_input();
  
  const valid_occurrences = count_occurrences(input);
  console.log(`Valid passwords by counting: ${valid_occurrences}`);

  const valid_positions = count_positions(input);
  console.log(`Valid passwords by positioning: ${valid_positions}`);
}

main();
