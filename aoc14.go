package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

// Contains individual values for an instruction. An opcode represents "mem" or "mask", address
// is only valid for the mem opcode, and value is the argument for the opcode.
type Instruction struct {
	opcode  string
	address int64
	value   string
}

// An interface for handling the mem opcode.
type MemoryDecoder interface {
	Handle(mem *map[int64]int64, instruc Instruction, bitmask string)
}

// Performs a mask on the value, then sets the result into the given memory address.
type ValueMaskMemoryDecoder struct {
}

// Time complexity:  O(n)
// Space complexity: O(n)
// Where n is max(len(base2(value)), len(bitmask))
func (md ValueMaskMemoryDecoder) Handle(
	mem *map[int64]int64,
	instruc Instruction,
	bitmask string) {

	var sb strings.Builder
	intValue, _ := strconv.ParseInt(instruc.value, 10, 0)
	base2Value := strconv.FormatInt(intValue, 2)

	var maxLength int
	switch {
	case len(bitmask) > len(base2Value):
		maxLength = len(bitmask)
	default:
		maxLength = len(base2Value)
	}

	for i := 0; i < maxLength; i++ {
		mask := bitmask[i%len(bitmask)]
		j := len(base2Value) + i - maxLength

		var ch byte
		switch {
		case j < 0:
			ch = '0'
		default:
			ch = base2Value[j]
		}

		switch mask {
		case '1':
			fmt.Fprint(&sb, "1")
		case '0':
			fmt.Fprint(&sb, "0")
		default:
			fmt.Fprintf(&sb, "%c", ch)
		}
	}

	maskedValue, _ := strconv.ParseInt(sb.String(), 2, 0)
	(*mem)[instruc.address] = maskedValue
}

// Performs a mask on the address to find a set of addresses, then sets
// the result into the resultant addresses.
type CombinationMaskMemoryDecoder struct {
}

// Time complexity:  O(n^2)
// Space complexity: O(n^2)
// Where n is max(len(base2(value)), len(bitmask))
func (md CombinationMaskMemoryDecoder) Handle(
	mem *map[int64]int64,
	instruc Instruction,
	bitmask string) {

	sbs := []*strings.Builder{&strings.Builder{}}
	intValue, _ := strconv.ParseInt(instruc.value, 10, 0)
	base2Address := strconv.FormatInt(instruc.address, 2)

	var maxLength int
	switch {
	case len(bitmask) > len(base2Address):
		maxLength = len(bitmask)
	default:
		maxLength = len(base2Address)
	}

	for i := 0; i < maxLength; i++ {
		mask := bitmask[i%len(bitmask)]
		j := len(base2Address) + i - maxLength

		var ch byte
		switch {
		case j < 0:
			ch = '0'
		default:
			ch = base2Address[j]
		}

		switch mask {
		case '1':
			for _, sb := range sbs {
				fmt.Fprint(sb, "1")
			}
		case '0':
			for _, sb := range sbs {
				fmt.Fprintf(sb, "%c", ch)
			}
		default:
			var sbsOne []*strings.Builder

			for _, sb := range sbs {
				sbOne := strings.Builder{}
				fmt.Fprint(&sbOne, sb.String())

				fmt.Fprint(sb, "0")
				fmt.Fprint(&sbOne, "1")

				sbsOne = append(sbsOne, &sbOne)
			}

			sbs = append(sbs, sbsOne...)
		}
	}

	for _, sb := range sbs {
		address, _ := strconv.ParseInt(sb.String(), 2, 0)
		(*mem)[address] = intValue
	}
}

// Parses a line in the input file and returns an Instruction.
func ReadInstruction(line string) Instruction {
	tokens := strings.Split(line, " = ")
	instAddr := tokens[0]
	value := tokens[1]

	instruction := Instruction{value: value}

	switch {
	case strings.HasPrefix(instAddr, "mem"):
		re := regexp.MustCompile(`mem\[(\d+)\]`)
		address, _ := strconv.ParseInt(re.FindStringSubmatch(instAddr)[1], 10, 0)
		instruction.opcode = "mem"
		instruction.address = address
	default:
		instruction.opcode = instAddr
	}

	return instruction
}

// Process each line in the input file using the provided MemoryDecoder, then
// returns the sum of all values.
//
// Time complexity:  O(2n)
// Space complexity: O(n)
// Where n = len(instrucs)
// To get the total complexity we'll need to multiply this by the actual
// MemoryDecoder used.
func FindSum(md MemoryDecoder, instrucs []Instruction) int64 {
	// Default mask is to accept all bits.
	bitmask := "X"
	mem := make(map[int64]int64)
	sum := int64(0)

	for _, instruc := range instrucs {
		switch instruc.opcode {
		case "mem":
			md.Handle(&mem, instruc, bitmask)
		case "mask":
			bitmask = instruc.value
		}
	}

	for _, value := range mem {
		sum += value
	}

	return sum
}

// Entry point. Reads the input file and finds the sum for both MemoryDecoders.
func main() {
	input, _ := os.Open("var/aoc14_input.txt")
	defer input.Close()

	var instrucs []Instruction
	scanner := bufio.NewScanner(input)

	for scanner.Scan() {
		instrucs = append(instrucs, ReadInstruction(scanner.Text()))
	}

	vmmd := ValueMaskMemoryDecoder{}
	vmSum := FindSum(vmmd, instrucs)
	fmt.Printf("Sum of masked values: %v\n", vmSum)

	cmmd := CombinationMaskMemoryDecoder{}
	cmSum := FindSum(cmmd, instrucs)
	fmt.Printf("Sum of mask-generated values: %v\n", cmSum)
}
