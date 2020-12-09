import scala.io.Source
import scala.collection.mutable

/**
  * A Data structure that represents a bi-directional
  * relationship between 2 names.
  */
class Node(val name: String) {
  val containsNodes = mutable.Map[Node, Int]()
  val containedByNodes = mutable.Buffer[Node]()

  def add(another: Node, count: Int): Unit = {
    containsNodes(another) = count
    another.containedByNodes += this
  }
}

/**
  * Main entry point. Builds a graph of bags from the given input and
  * calculates the bag combination for a given bag name.
  */
object aoc7 extends App {
  /**
    * Calculates a set of nodes that contains [[name]].
    *
    * Time complexity : O(2n)
    * Space complexity: O(n)
    * Where n is the number of bags that can contain the given [[name]].
    */
  def containsRecursive(name: String, bags: Map[String, Node]): Set[Node] = {
    val containedByNodes = bags(name).containedByNodes.toSeq

    containedByNodes.foldLeft(containedByNodes.toSet) { (agg, node) =>
      agg ++ containsRecursive(node.name, bags)
    }
  }

  /**
    * Calculates a list of nodes which [[name]] can contain.
    *
    * Time complexity : O(2n)
    * Space complexity: O(n)
    * Where n is the number of bags that the node with given [[name]]
    * can contain, multiply by its count.
    */
  def containedByRecursive(name: String, bags: Map[String, Node]): Seq[Node] = {
    val nodes = bags(name)
      .containsNodes
      .map { case (node, count) => for (i <- 1 to count) yield node }
      .flatten
      .toSeq

    val totalNodes = nodes.foldLeft(nodes) { (agg, node) => {
        agg ++ containedByRecursive(node.name, bags)
      }
    }

    totalNodes
  }

  /**
    * Parses each line into a Node, adds to the given [[bags]], then returns the [[bags]].
    * When used in foldLeft, this builds the graph.
    *
    * Time complexity : O(2n)
    * Space complexity: O(n)
    * Where n = number of bags referenced in the line.
    */
  def parseLine(bags: mutable.Map[String, Node], line: String): mutable.Map[String, Node] = {
    val bagLines = line
      .slice(0, line.length - 1)
      .replace("contain", ", ")
      .split(",")
      .map { s => s.slice(0, s.indexOf("bag")) }
      .map { _.trim() }
      .toSeq
    
    /**
      * Gets a node from [[bags]] with the given [[name]],
      * creating one if not exists.
      */
    def getOrCreateNode(name: String): Node = {
      if (!bags.contains(name)) {
        bags(name) = new Node(name)
      }

      bags(name)
    }

    bagLines.tail.foreach { typeCount =>
      if (typeCount != "no other") {
        val (count, bagName) = (
          typeCount.substring(0, typeCount.indexOf(' ')).toInt,
          typeCount.substring(typeCount.indexOf(' ') + 1)
        )

        val bag = getOrCreateNode(bagName)
        getOrCreateNode(bagLines.head).add(bag, count)
      }
    }

    bags
  }

  /**
    * Prints the number of bags that contains [[name]] and can
    * be contained by [[name]].
    */
  def findBagCombination(name: String, bags: Map[String, Node]) = {
    val containsNodes = containsRecursive(name, bags)
    println(s"${containsNodes.size} bags can contain a $name bag.")

    val containedByNodes = containedByRecursive(name, bags)
    println(s"$name bag contains ${containedByNodes.size} other bags.")
  }

  val filename = "var/aoc7_input.txt"
  val bags = Source
    .fromFile(filename)
    .getLines()
    .foldLeft(mutable.Map[String, Node]()){ parseLine }
    .toMap
  
  findBagCombination("shiny gold", bags)
}