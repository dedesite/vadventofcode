import os

fn main() {
	numbers := os.read_lines('input') or {
		println(err)
		return
	}
	for key, num in numbers {
		num_left := num.int()
		for n in numbers[key+1..numbers.len] {
			num_middle := n.int()
			found := numbers[key+2..numbers.len].filter(num_left + num_middle + it.int() == 2020)
			if found.len > 0 {
				num_right := found[0].int()
				println("$num_left + $num_middle + $num_right = ${num_left + num_middle + num_right}")
				println("$num_left * $num_middle * $num_right = ${num_left * num_middle * num_right}")
				break
			}
		}
	}
}