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

Rust can be run like a script with <code>cargo-script</code>. Install with <code>cargo install cargo-script</code>.
It needs to be compiled to a temporary directory before running. I'll probably only use this if I'm really CPU-bound
or I needed to use a Rust library.

6. cargo script aoc6.rs  
&nbsp;&nbsp;&nbsp;&nbsp;Updating crates.io index  
&nbsp;&nbsp;&nbsp;Compiling aoc6 v0.1.0 (C:\\???\Profit!\AppData\Local\Cargo\script-cache\file-aoc6-4f48aadee8a27792)  
&nbsp;&nbsp;&nbsp;&nbsp;Finished release \[optimized\] target(s) in 2.04s  
At-least-one responses: 7027, All-or-none responses: 3579

I ran this using SBT. It's awfully slow, 13s compared to the 2s for Rust (and I was already complaining). I really enjoyed
the expressiveness of the Scala language though. Talk about a love-hate relationship.

7. sbt run  
[**info**] welcome to sbt 1.4.3 (Oracle Corporation Java 14.0.2)  
[**info**] loading project definition from C:\???\Profit!\project  
[**info**] loading settings for project aoc7 from build.sbt ...  
[**info**] set current project to aoc7 (in build file:/C:/???/Profit!/)  
[**info**] compiling 1 Scala source to C:\???\Profit!\target\scala-2.13\classes ...  
[**info**] running aoc7  
148 bags can contain a shiny gold bag.  
shiny gold bag contains 24867 other bags.  
[**success**] Total time: 13 s, completed Dec 8, 2020, 11:34:51 PM

Java has changed a lot since I last used it. During my time at Amazon we were stuck at Java 8. The first thing I realized
though is the number of imports compared to other languages I've used so far. I've also used some of the newer Java
features, such as <code>(1) jShell REPL (JEP 222)</code> from Java 9, <code>(2) Local-variable Type Inference
(JEP 286)</code> from Java 10, <code>(3) Switch Expressions (JEP 325)</code> from Java 12, and my favorite <code>(4) Single File
Execution (JEP 330)</code> from Java 11.

8. java aoc8.java  
Loop detected, breaking out! Accumulated value: 1446  
Repaired line 253 to nop -128  
Accumulated value: 1403  

I haven't found a way to run Visual Basic.NET source code without compiling. When I started coding I was confused by
namespaces like <code>My.Computer.FileSystem</code>. I ended up referencing aoc3.csx for usage of the .NET Core libraries.

9. dotnet run --project aoc9  
Found invalid value 22477624.  
Sum of smallest and largest of contiguous values is 2980044