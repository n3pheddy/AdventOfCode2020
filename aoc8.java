import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.AbstractMap.SimpleImmutableEntry;
import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;
import java.util.Optional;

/**
 * Given a list of instructions, execute each line and find
 * the accumulated value.
 */
public class aoc8 {
  /**
   * Executes the instructions given in {@code pairs}, then return the
   * accumulated value. Throws an IllegalArgumentException if a loop is detected.
   */
  static int execute(ArrayList<Entry<String, Integer>> pairs) throws IllegalArgumentException {
    var acc = 0;
    var walked = new boolean[pairs.size()];

    for (var i = 0; i < pairs.size(); i++) {
      var instruction = pairs.get(i).getKey();
      var value = pairs.get(i).getValue();

      if (walked[i]) {
        throw new IllegalArgumentException(
          String.format("Loop detected, breaking out! Accumulated value: %d", acc)
        );
      }

      walked[i] = !walked[i];
      
      switch (instruction) {
        case "acc" -> acc += value;
        case "jmp" -> i += value - 1;
      }
    }

    return acc;
  }

  /**
   * Returns the fixed instruction, if applicable i.e. nop <-> jmp.
   * Returns {@code Optional.empty()} if no fix is needed.
   */
  static Optional<Entry> repair(Entry<String, Integer> pair) {
    return switch (pair.getKey()) {
      case "nop" ->
        Optional.of(
          new SimpleImmutableEntry<>(
            "jmp",  pair.getValue()
          )
        );
      case "jmp" ->
        Optional.of(
          new SimpleImmutableEntry<>(
            "nop",  pair.getValue()
          )
        );
      default -> Optional.empty();
    };
  }

  /**
   * Solves the instructions by attempting to fix the corrupted operation.
   */
  static int solve(ArrayList<Entry<String, Integer>> pairs) {
    for (var i = 0; i < pairs.size(); i++) {
      try {
        var maybePair = repair(pairs.get(i));

        if (maybePair.isPresent()) {
          var pair = maybePair.get();
          pairs.set(i, pair);

          var acc = execute(pairs);
          System.out.printf("Repaired line %d to %s %d%n",
            i, pair.getKey(), pair.getValue());

          return acc;
        }
      }
      catch (IllegalArgumentException ex) {
        // Reset current value, noting that this is a switch
        // between 2 binary values. This should also never fail.
        pairs.set(i, repair(pairs.get(i)).get());
      }
    }

    throw new IllegalArgumentException("No solution!");
  }

  /**
   * Entry point. Reads the list of operations from file, fixes the
   * instructions, then print the accumulated value.
   */
  public static void main(String args[]) throws IOException {
    var filename = "var/aoc8_input.txt";
    var lines = Files.readAllLines(Paths.get(filename));
    var pairs = new ArrayList<Entry<String, Integer>>(lines.size());

    for (var i = 0; i < lines.size(); i++) {
      var instruction = lines.get(i).split(" ");
      var pair = new SimpleImmutableEntry<>(
        instruction[0], Integer.parseInt(instruction[1])
      );

      pairs.add(pair);
    }

    try {
      // Solving it now will throw an exception.
      execute(pairs);
    }
    catch (IllegalArgumentException ex) {
      System.out.println(ex.getMessage());
    }

    var acc = solve(pairs);
    System.out.printf("Accumulated value: %d%n", acc);
  }
}