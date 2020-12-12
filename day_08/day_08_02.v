import os

enum Operation {
	nop acc jmp
}

struct Instruction {
	argument int
mut:
	operation string //Operation
	executed bool
}

// Ensuite appeler cette fonction pour chaque jmp et nop rencontré dans le code en mode brut force
// Jusqu'à ce que ça renvoi true
fn parse_program(filename string) []Instruction {
	instructions := os.read_lines(filename) or {panic(err)}
	mut program := []Instruction{}
	for inst in instructions {
		program << Instruction {
			// todo cast to enum
			operation: inst.split(" ")[0]
			argument: inst.split(" ")[1].int()
		}
	}
	return program
}

// Faire une fonction qui execute la VM et renvoi booleen pour dire si y a eu boucle infinie
// Et renvoi l'accumulateur
fn execute_program(mut program []Instruction) (bool, int) {
	mut accumulator := 0
	mut cursor := 0
	mut infinite_loop := false
	for cursor < program.len {
		if program[cursor].executed {
			infinite_loop = true
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
	return infinite_loop, accumulator
}

prog := parse_program("input")

for line, instruction in prog {
	if instruction.operation in ['jmp', 'nop'] {
		mut modified_prog := prog.clone()
		modified_prog[line].operation = if instruction.operation == 'jmp' { 'nop' } else { 'jmp' }
		infinite_loop, acc := execute_program(mut modified_prog)
		if !infinite_loop {
			println("Found the wrong line L$line accumulator is $acc")
		}	
	}
}
