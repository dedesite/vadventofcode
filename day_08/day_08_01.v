import os

enum Operation {
	nop acc jmp
}

struct Instruction {
	operation string //Operation
	argument int
mut:
	executed bool
}

instructions := os.read_lines('input')?
mut program := []Instruction{}
for inst in instructions {
	program << Instruction {
		// todo cast to enum
		operation: inst.split(" ")[0]
		argument: inst.split(" ")[1].int()
	}
}

mut accumulator := 0
mut cursor := 0
for {
	if program[cursor].executed {
		break
	}

	program[cursor].executed = true
	match program[cursor].operation {
		"nop" {
			cursor++
		}
		"acc" {
			accumulator += program[cursor].argument
			cursor++
		}
		"jmp" {
			cursor += program[cursor].argument
		}
		else {}
	}
}

println("accumulator $accumulator")