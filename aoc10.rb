# Finds the number of possible solutions where the difference between
# any 2 numbers is between 1 and look_ahead.
#
# *Time complexity: O(n)
# Space complexity: O(m)
# Where n = lines.length and m = look_ahead
# * Excludes sorting, which will be nlogn.
def find_solution_count(lines, look_ahead=3)
  init = Struct.new(:value, :length).new
  init.value = 0
  init.length = 1

  running_lengths = Array[init]

  for i in 0..lines.length - 1 do
    current = Struct.new(:value, :length).new
    current.value = lines[i]
    current.length = running_lengths.inject(0) { |sum, item|
      current.value <= item.value + look_ahead ?
        sum += item.length : sum
    }

    running_lengths.unshift current

    if running_lengths.length > look_ahead
      running_lengths.pop
    end
  end

  # running_lengths contains values for 180, 179, and 178, in that order.
  return running_lengths[0].length
end

# Finds the product of the number of 1-jolt difference
# and 3-jolt difference.
#
# *Time complexity: O(n)
# Space complexity: O(m)
# Where n = lines.length and m = max_jolt_diff
# * Excludes sorting, which will be nlogn.
def find_jolt_product(lines, max_jolt_diff=3, adapter_to_device_jolts=3)
  diff_counts = Array.new(max_jolt_diff, 0)

  for i in 0..lines.length do
    # Account for first element.
    lower = i > 0 ? lines[i - 1] : 0
    # Accounts for the difference between the last adapter and device.
    higher = i < lines.length ?
      lines[i] : lines[i - 1] + adapter_to_device_jolts

    diff = higher - lower
    diff_counts[diff - 1] += 1
  end

  return diff_counts[0] * diff_counts[2]
end

# Includes sorting here, which is nlogn
lines = File
  .read('var/aoc10_input.txt')
  .split
  .map { |line| line.chomp.to_i }
  .sort

jolt_product = find_jolt_product(lines)
puts "product of 1-jolt diff and 3-jolt diff is #{jolt_product}"

solution_count = find_solution_count(lines)
puts "Number of combinations is #{solution_count}"
