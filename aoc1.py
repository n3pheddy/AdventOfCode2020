from functools import reduce
from operator import mul

def find_addends(sum, input, level):
  """
  Given a target sum and a list of possible combinations, enumerate input
  and look for addends that return the given sum. level=0 indicates 2 addends,
  level=1 indicates 1 addends, and so on. Returns a list of its result.

  Time complexity : O(m*n)
  Space complexity: O(m*n)
  Where m = len(input), n = level+1

  It's possible to get O(m*nlogn) by sorting the list first, then generate an
  array of {sum} elements for an O(1) lookup.
  """
  candidates = []

  for addend in input:
    remainder = sum - addend

    if level == 0:
      if addend in candidates:
        return [addend, remainder]
      else:
        candidates.append(remainder)
    else:
      input.remove(addend)
      next_remainder = find_addends(remainder, input, level-1)

      if next_remainder:
        next_remainder.insert(0, addend)
        return next_remainder

def find_solution(sum, input, level):
  """
  Given a target sum and a list of possible combinations, find
  a solution and print its result.
  """
  result = find_addends(sum, input, level)

  if result:
    sresult = list(map(str, result))
    product = reduce(mul, result)

    print(f'Addends = {level+2} -> {" + ".join(sresult)} = {sum}, ' +
          f'{" * ".join(sresult)} = {product}')
  else:
    print('No solution!')

if __name__ == '__main__':
  sum = 2020
  input = []

  with open('var/aoc1_input.txt') as f:
    line = f.readline()
    while line:
      input.append(int(line))
      line = f.readline()

  # Use level=0 to find 2 operands, level=1 to find 3 operands, etc.
  for level in range(0, 2):
    find_solution(sum, input.copy(), level)
    