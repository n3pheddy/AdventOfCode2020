/// Finds the value at idx given a starting list arr.
///
/// Time complexity : O(n)
/// Space complexity: O(n)
/// where n = idx.length.
int findTerm(List<int> arr, int idx) {
  var lastPosition = new List(idx);
  var previousValue;

  for (var i = 0; i < idx; i++) {
    var value;

    if (i < arr.length) {
      value = arr[i];
    } else if (lastPosition[previousValue] == null) {
      value = 0;
    } else {
      value = i - lastPosition[previousValue];
    }

    if (previousValue != null) {
      lastPosition[previousValue] = i;
    }

    previousValue = value;
  }

  return previousValue;
}

/// Entry point. Finds the value at a given term given a starting list.
void main() {
  var testSequence = [0, 3, 6];
  var mainSequence = [14, 8, 16, 0, 1, 17];

  var value = findTerm(testSequence, 2020);
  print('2020th value for $testSequence: $value');

  value = findTerm(mainSequence, 2020);
  print('2020th value for $mainSequence: $value');

  value = findTerm(mainSequence, 30000000);
  print('30000000th value for $mainSequence: $value');
}
