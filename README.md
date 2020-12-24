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

Install `dotnet.script` with `choco install -y dotnet.script`.

3. dotnet script aoc3.csx  
Number of trees for right 3, down 1 is 178  
Product of trees in the given sizes is 3492520200

Run it in WSL.

4. perl aoc4.pl  
Number of passports with required fields: 190  
Number of passports with validated fields: 121

Create a container using an image with Swift `docker run --interactive --tty --name swift-latest swift:latest /bin/bash`,
then invoke the `swift` interpretor.

5. swift aoc5.swift  
Largest ID is 826, my seat ID is 678  

Rust can be run like a script with `cargo-script`. Install with `cargo install cargo-script`.
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
features, such as `(1) jShell REPL (JEP 222)` from Java 9, `(2) Local-variable Type Inference
(JEP 286)` from Java 10, `(3) Switch Expressions (JEP 325)` from Java 12, and my favorite `(4) Single File
Execution (JEP 330)` from Java 11.

8. java aoc8.java  
Loop detected, breaking out! Accumulated value: 1446  
Repaired line 253 to nop -128  
Accumulated value: 1403  

I haven't found a way to run Visual Basic.NET source code without compiling. When I started coding I was confused by
namespaces like `My.Computer.FileSystem`. I ended up referencing aoc3.csx for usage of the .NET Core libraries.

9. dotnet run --project aoc9  
Found invalid value 22477624.  
Sum of smallest and largest of contiguous values is 2980044

I used WSL for Ruby. I spent the most time relative to other puzzles on this so far for the second star.
I knew that I could generate the full combination and then count it, but that's going to be a O(n!) solution and take forever.
I knew there must be a way to count some how, and is probably a dynamic programming solution. It wasn't until I pasted the
first 10 combinations in Excel manually that I see the pattern.

10. ruby aoc10.rb  
product of 1-jolt diff and 3-jolt diff is 2664  
Number of combinations is 148098383347712

This took me the longest time to setup so far. I used Ubuntu and GCC. I had wanted to use LLVM/Clang to use the latest syntax,
but it turned out that Ubuntu Bionic contained outdated versions. I tried compiling Clang but ran out of memory on my
8GB Microsoft Surface Book. I compiled on a bigger machine but when I tried to copy back to my Surface Book I ran out of space.
To build on Ubuntu I only needed to install `sudo apt-get install gnustep-devel`.

11. gcc $(gnustep-config --objc-flags) -std=c11 -o aoc11 aoc11.m  
Number of occupied seats using immediate seats: 2310  
Number of occupied seats using nearest seats: 2074

I referenced the Kotlin documentation a little more than expected. It seemed to have taken a lot of hints from Scala.

12. kotlin aoc12.kts  
Manhattan distance for Direction navigation: 1838  
Manhattan distance for Waypoint navigation: 89936  

I spent several days on this and probably wouldn't be able to solve this without spending several weeks studying the Chinese
remainder theory. On top of this, I chose to practise this in Julia. I ***hate*** Julia. It's the worst language I've ever
came across so far. It's super unintuitive.

i. 1-index arrays. Please read EWD831 by Edsger Dijkstra https://www.cs.utexas.edu/users/EWD/ewd08xx/EWD831.PDF

ii. Imperative syntax e.g. `split(str, delim)` instead of `str.split(delim)`. This is due to lack of classes in Julia and it makes
method chaining very clumsy. It also directly conflicts with their style guide to pass functions directly instead of lambdas:
`map(x -> parse(Int, x), value)` cannot be written as `map(parse, value)`. As of 1.5.3 there isn't a way to do line continuation!
Imagine this: `sort(map(x -> parse(Int, x), filter(x -> x != "x", split(str, delim))), rev=true)`

iii. Methods like `split(::String, ::String)`, `keys(::Dict)` don't return `Array{String}` or `Set{String}` as expected. Instead,
they return a view to the underlying type i.e. `Array{SubString{String}}`, `KeySet{Dict}`, and and is incompatible with the regular
data structures. This affects your method signature, and you can't call methods like `sort(split(str, delim))`.

iv. Integer division symbol: `÷`. Bitwise XOR is `⊻`. Checking for strict subset is `⊊`. I can't even type these characters on my laptop
keyboard. Some of these characters aren't even ASCII.

v. `%` is NOT the modulus operator. `-37 % 35` returns `-2`, not `33`. The modulus function is `mod(::Int, ::Int)`

vi. Variables declared in a local scope within a method is NOT visible to the rest of the method.
```
julia> x = 1
1
julia> for i in 1:10; x = i; end
julia> x
10 # Expected

julia> for i in 1:10; y = i; end
julia> y
ERROR: UndefVarError: y not defined # wtf!
```

I really hope there'll be a major rework in the language. It's super frustrating to work with such a badly design language.
Credits to https://dev.to/qviper/advent-of-code-2020-python-solution-day-13-24k4 for referencing the algorithm.

13. julia aoc13.jl  
ID for earliest bus is 3246  
Time where schedules align: 1010182346291467

Finally got this out. It wasn't very difficult, I got the general design out on my first attempt. I did read the
question wrong though and had to amend my code. Between Christmas celebration and debugging an issue at work, I
was trying to squeeze this one in. I love writing in Go. It's concise and Rust-like. Not too many surprises, except I
always forgot to declare and assign a new variable using `:=`, and that variables are passed by value by default. This
manifested as strange bugs when I write to one of my `[]strings.Builders` and it doesn't seemed to have any effect. I love
to be able to use pointers when needed and the ability to use `switch` statements to replace `if-else`s.

14. go run aoc14.go  
Sum of masked values: 15403588588538  
Sum of mask-generated values: 3260587250457  