using System;
using System.Drawing;
using System.IO;

class aoc3
{
    /// <summary>
    /// Given an array of lines, number of rights to shift (xOffset) and
    /// number of downs to shift (yOffset), find the number of "#" encountered
    /// when looped from top down. Horizontal patterns will be repeated.
    /// 
    /// Time complexity : O(n)
    /// Space complexity: O(1)
    /// Where n is lines.Length.
    /// </summary>
    static int CountTrees(string[] lines, int xOffset, int yOffset)
    {
        var position = new Point(0, 0);
        var trees = 0;

        // Skip the first row.
        for (int i = yOffset; i < lines.Length; i += yOffset)
        {
            var line = lines[i];
            position.Offset(xOffset, yOffset);

            if (line[position.X % line.Length].Equals('#'))
            {
                trees += 1;
            }
        }

        return trees;
    }

    /// <summary>
    /// Entry point, reads input from the given file and calculates the number
    /// of trees encountered when looped from top down.
    /// </summary>
    public static void Run()
    {
        string[] lines = File.ReadAllLines(@"var/aoc3_input.txt");

        var trees = CountTrees(lines, 3, 1);
        Console.WriteLine($"Number of trees for right 3, down 1 is {trees}");

        var sizes = new Size[] {
            new Size(1, 1),
            new Size(3, 1),
            new Size(5, 1),
            new Size(7, 1),
            new Size(1, 2)
        };

        long product = 1;

        foreach(var size in sizes)
        {
            trees = CountTrees(lines, size.Width, size.Height);
            product *= trees;
        }

        Console.WriteLine($"Product of trees in the given sizes is {product}");
    }
}

aoc3.Run();
