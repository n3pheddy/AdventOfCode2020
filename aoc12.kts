import java.io.File

/**
 * Represents a ship and its location.
 */
class Ship() {
  private var locationX = 0
  private var locationY = 0
  
  // Returns the manhanttan distance from point of origin.
  val manhanttanDistance: Int
    get() = Math.abs(locationX) + Math.abs(locationY)

  // Moves the ship's location by the given X and Y values.
  fun move(offsetX: Int, offsetY: Int) {
    this.locationX += offsetX
    this.locationY += offsetY
  }

  // Resets this ship's location to the point of origin.
  fun resetLocation() {
    locationX = 0
    locationY = 0
  }
}

/**
 * Represents a navigation strategy that interprets instructions as
 * movement from the ship's current position.
 */
class DirectionNavigator(private val ship: Ship, direction: Int) {
  private var offsetX = 0
  private var offsetY = 0
 
  // Direction of the ship (in degrees) affects where the ship will move towards.
  private var direction = 0
    get() = field
    set(value) {
      var standardizedValue = value % 360
      while (standardizedValue < 0) {
        standardizedValue += 360
      }

      when (standardizedValue) {
        0 -> {
          offsetX = 0
          offsetY = -1
        }
        90 -> {
          offsetX = 1
          offsetY = 0
        }
        180 -> {
          offsetX = 0
          offsetY = 1
        }
        270 -> {
          offsetX = -1
          offsetY = 0
        }
        else -> throw RuntimeException("Unsupported degrees: $standardizedValue")
      }
      field = standardizedValue
    }
  
  init {
    this.direction = direction
  }

  /**
   * Reads the instruction and intepret it as movement relative to the ship.
   */
  fun read(action: Char, by: Int) {
    when (action) {
      'F' -> ship.move(this.offsetX * by, this.offsetY * by)
      'N' -> ship.move(0, -by)
      'E' -> ship.move(by, 0)
      'S' -> ship.move(0, by)
      'W' -> ship.move(-by, 0)
      'L' -> this.direction -= by
      'R' -> this.direction += by
      else -> throw RuntimeException("Unsupported action: $action")
    }
  }
}

/**
 * Represents a navigation strategy that interprets instructions as
 * changing the waypoint to which the ship should move to.
 */
class WaypointNavigator(private val ship: Ship, var waypointX: Int, var waypointY: Int) {
  /**
   * Reads the instruction and intepret it as changing the location of the waypoint.
   */
  fun read(action: Char, by: Int) {
    when (action) {
      'F' -> ship.move(waypointX * by, waypointY * by)
      'N' -> waypointY -= by
      'E' -> waypointX += by
      'S' -> waypointY += by
      'W' -> waypointX -= by
      'L' -> {
        if (by < 0 || by % 90 != 0) {
          throw RuntimeException("Unsupported degrees: $by")
        }

        for (i in 1..(by/90)) {
          val newWaypointY = -waypointX
          waypointX = waypointY
          waypointY = newWaypointY
        }
      }
      'R' -> {
        if (by < 0 || by % 90 != 0) {
          throw RuntimeException("Unsupported degrees: $by")
        }

        for (i in 1..(by/90)) {
          val newWayPointY = waypointX
          waypointX = -waypointY
          waypointY = newWayPointY
        }
      }
      else -> throw RuntimeException("Unsupported action: $action")
    }
  }
}

/**
 * Converts a line into an action and value.
 */
fun parseLine(line: String): Pair<Char, Int> {
  val action = line.get(0)
  val by = line.substring(1, line.length).toInt()

  return Pair(action, by)
}

/**
 * Given a list of strings representing instructions, determine the manhattan distance
 * for the navigation strategies.
 */
fun main(lines: List<String>) {
  val ship = Ship()
  val directionNavigator = DirectionNavigator(ship, direction=90)

  lines.forEach {
    val actionBy = parseLine(it)
    directionNavigator.read(actionBy.first, actionBy.second)
  }

  println("Manhattan distance for Direction navigation: ${ship.manhanttanDistance}")

  ship.resetLocation()
  val waypointNavigator = WaypointNavigator(ship, waypointX=10, waypointY=-1)

  lines.forEach {
    val actionBy = parseLine(it)
    waypointNavigator.read(actionBy.first, actionBy.second)
  }

  println("Manhattan distance for Waypoint navigation: ${ship.manhanttanDistance}")
}

// Entry point - reads the input file and calls main()
val filename = "var/aoc12_input.txt"
val lines = File(filename).readLines()

main(lines)
