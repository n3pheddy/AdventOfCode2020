# AdventOfCode2020
Solutions for Advent of Code 2020 https://adventofcode.com/2020. Solutions are built on a Windows machine.
Some workarounds are required to get certain languages to run. These are documented sparingly, but should
give you enough hint to know how to approach it.

Install Python through Visual Studio or download from https://www.python.org. Alternatively, run it in
the Windows Subsystem for Linux (WSL).

1. python aoc1.py  
Addends = 2 -> 942 + 1078 = 2020, 942 * 1078 = 1015476  
Addends = 3 -> 956 + 802 + 262 = 2020, 956 * 802 * 262 = 200878544

I ran this using node, but it should also be runnable on any modern browser.

2. node aoc2.js  
Valid passwords by counting: 418  
Valid passwords by positioning: 616

Install <code>dotnet.script</code> with <code>choco install -y dotnet.script</code>.

3. dotnet script aoc3.csx  
Number of trees for right 3, down 1 is 178  
Product of trees in the given sizes is 3492520200

Run it in WSL.

4. perl aoc4.pl  
Number of passports with required fields: 190  
Number of passports with validated fields: 121

Create a container using an image with Swift <code>docker run --interactive --tty --name swift-latest swift:latest /bin/bash</code>,
then invoke the <code>swift</code> interpretor.

5. swift aoc5.swift  
Largest ID is 826, my seat ID is 678  