import os

fn main() {
	numbers := os.read_lines('input') or {
		println(err)
		return
	}
	for key, num in numbers {
		num_left := num.int()
		for n in numbers[key+1..numbers.len] {
			num_right := n.int()
			if num_left + num_right == 2020 {
				println("$num_left + $num_right = ${num_left + num_right}")
				println("$num_left * $num_right = ${num_left * num_right}")
				break
			}
		}
	}
}