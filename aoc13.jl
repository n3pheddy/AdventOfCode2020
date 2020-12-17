"""
Finds the earliest bus that occur after `time`, then return
its ID given by (wait time) * (bus number).
"""
function find_earliest(time::Int, buses::Array{String})
  lowest_wait = nothing
  earliest_bus = nothing

  # Remove x's, parse into Int
  buses = filter(x -> x != "x", buses)
  buses = map(x -> parse(Int, x), buses)

  for bus in buses
    div = time ÷ bus
    wait = ((div + 1) * bus) - time
    bid = wait * bus

    if lowest_wait == nothing || wait < lowest_wait
      lowest_wait = wait
      earliest_bus = bus
    end
  end

  return lowest_wait * earliest_bus
end

"""
Finds the time where buses will begin arriving according to their index in the input.
"""
function find_increasing_arrival_time(buses::Array{String})
  mods = Dict{Int, Int}()

  for i in 1:length(buses)
    bus = tryparse(Int, buses[i])
    if (!isnothing(bus))
      push!(mods, bus => mod(-(i - 1), bus))
    end
  end

  bus_product = nothing
  value = nothing

  for (bus, mod) in mods
    if isnothing(bus_product) || isnothing(value)
      # Seed initial value
      bus_product = bus
      value = mod
      continue
    end

    while value % bus != mod
      value += bus_product
    end

    bus_product *= bus
  end

  return value
end

# Entry point, starts reading the input file and solves the puzzles.
lines = readlines("var/aoc13_input.txt")
time = parse(Int, lines[1])
buses = split(lines[2],",")

# Convert Array{SubString{String}} to Array{String}
buses = map(String, buses)

bid = find_earliest(time, buses)
println("ID for earliest bus: $bid")

time = find_increasing_arrival_time(buses)
println("Time where schedules align: $time")
