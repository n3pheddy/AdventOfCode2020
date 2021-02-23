import sequtils
import strformat
import strutils

type Rule = ref object
  ## Represents a rule's name and array of valid values.
  name: string
  validValues: array[1000, bool]

type ParsedInput = ref object
  ## Encapsulates the values in the various sections in the input.
  yourTicket: seq[int]
  nearbyTickets: seq[seq[int]]
  rules: seq[Rule]
  scanningErrorRate: int

proc solve(rules: seq[Rule], tickets: seq[seq[int]]): seq[(Rule, int)] =
  ## Solves the mapping between rules and field positions, given a list of tickets.
  ## The algorithm first determines a list of possible positions for the rule, then
  ## eliminate candidates based on permissible values.
  ## 
  ## Time complexity   O(2nm)
  ## Space complexity: @(2nm + m)
  ## where n is the number of rules and m is the number of fields in a ticket.

  var
    sortedCandidates = newSeqWith(len(rules), newSeq[int](0))
    sortedRules: seq[Rule] = newSeqWith(len(rules), Rule())
    assigned: seq[int] = @[]
  
  for rule in rules:
    var candidate: seq[int] = @[]

    # Init list of candidates
    for i in 0..len(tickets[0])-1:
      candidate.add(i)
    
    for ticket in tickets:
      for i, fieldVal in ticket:
        if not candidate.contains(i):
          continue
        elif not rule.validValues[fieldVal]:
          candidate[i] = -1

    candidate = candidate.filterIt(it >= 0)
    sortedRules[len(candidate)-1] = rule
    sortedCandidates[len(candidate)-1] = candidate

  for i, _ in sortedCandidates:
    sortedCandidates[i] = sortedCandidates[i].filterIt(not it.in(assigned))
    assigned.add(sortedCandidates[i][0])
  
  return sortedRules.zip(assigned)

proc parse(lines: seq[string]): ParsedInput =
  ## Reads input field as a sequence of strings and returns the values
  ## of each section into a `ParsedInput`. Since this only does a single
  ## pass, the complexity for calculating Ticket Scanning Error Rate is O(n)
  ## where n is the number of nearby tickets.
  ## 
  ## Space complexity: O(n)
  ## where n = number of rules, your ticket and nearby tickets.

  type
    Section = enum
      ValidationRules, YourTicket, NearbyTickets

  var
    section = ValidationRules
    unionValidValues: array[1000, bool]
    parsedInput = ParsedInput()

  for line in lines:
    case line:
      of "your ticket:":
        section = YourTicket
        continue
      of "nearby tickets:":
        section = NearbyTickets
        continue
      of "": continue
      else: discard
  
    case section:
      of ValidationRules:
        let
          nameIndex = line.find(": ")
          startIndex = nameIndex + len(": ")
          name = line[0 .. nameIndex-1]
          ranges = line[startIndex .. ^1].split(" or ")
        
        var rule = Rule(name: name)

        for rg in ranges:
          let
            min = parseInt(rg[0 .. rg.find("-")-1])
            max = parseInt(rg[rg.find("-")+1 .. ^1])

          for i in min..max:
            rule.validValues[i] = true
            unionValidValues[i] = true
          
        parsedInput.rules.add(rule)
      of YourTicket:
        parsedInput.yourTicket = line.split(",").map(parseInt)
      else:
        let values = line.split(",").map(parseInt)
        var valid = true

        for v in values:
          if not unionValidValues[v]:
            parsedInput.scanningErrorRate += v
            valid = false
            break
        
        if valid:
          parsedInput.nearbyTickets.add(values)

  parsedInput

proc main(): void =
  ## Entry point. Reads input, calculates Ticket Scanning Error Rate, and
  ## return product of "departure" fields.

  proc product(fieldVals: seq[int], x: int, y: (Rule, int)): int =
    ## Accumulator that multiplies the value at the given position iff
    ## rule name starts with "departure".

    let (rule, pos) = y
    if rule.name.startsWith("departure"):
      x * fieldVals[pos]
    else:
      x

  let
    lines = readFile("var/aoc16_input.txt")
      .split("\n")
      .mapIt(it.strip())
    parsedInput = parse(lines)
    ruleToPos = solve(parsedInput.rules, parsedInput.nearbyTickets)
    acc = foldl(ruleToPos, product(parsedInput.yourTicket, a, b), 1)

  echo &"Ticket Scanning Error Rate: {parsedInput.scanningErrorRate}"
  echo &"Product of departure fields: {acc}"

main()