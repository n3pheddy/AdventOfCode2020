use std::{
  collections::HashMap,
  fs::File,
  io::{prelude::*, BufReader, Result}
};

const FILENAME: &str = "var/aoc6_input.txt";
const GROUP_COUNT_KEY: char = '.'; // Hack: Using an unused character for group count.

/// Analyzes the responses in the given lines and return 2 results:
/// (1) At-least-one includes non-zero responses in the given group.
/// (2) All-or-none includes responses iff all group members responded.
///
/// Time complexity : O(mn^2)
/// Space complexity: O(n)
/// Where n = lines.len() and m = length of each line.
fn count_responses(lines: Vec<String>) -> (i32, i32) {
  let mut responses = vec![HashMap::<char, i32>::new()];

  for line in lines.iter() {
    if line == "" {
      responses.push(HashMap::<char, i32>::new());
    }
    else {
      let last_index = &responses.len() - 1;
      let current_map = &mut responses[last_index];

      for ch in line.chars().into_iter() {
        let resp_count = match current_map.get(&ch) {
          Some(x) => x + 1,
          _ => 1
        };
        current_map.insert(ch, resp_count);
      }

      let grp_count = match current_map.get(&GROUP_COUNT_KEY) {
        Some(x) => x + 1,
        _ => 1
      };
      current_map.insert(GROUP_COUNT_KEY, grp_count);
    }
  }

  let mut sum = 0;
  let mut resp_sum = 0;

  for current_map in responses.iter() {
    let grp_count = current_map.get(&GROUP_COUNT_KEY).unwrap();

    for (ch, resp_count) in current_map {
      if ch != &'.' {
        sum += 1;

        if resp_count == grp_count {
          resp_sum += 1;
        }
      }
    }
  }

  (sum, resp_sum)
}

/// Entry point. Reads input from file, invokes calculation method
/// and prints result.
fn main() {
  let file = File::open(FILENAME).expect("No such file");

  let lines = BufReader::new(file)
    .lines()
    .collect::<Result<Vec<String>>>()
    .expect("Error while reading file");

  let (sum, resp_sum) = count_responses(lines);
  println!("At-least-one responses: {}, All-or-none responses: {}", sum, resp_sum);
}