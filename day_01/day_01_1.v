import os

fn main() {
	numbers := os.read_lines('input') ?
	mut start_key := 0
	for num in numbers {
		num_left := num.int()
		start_key++
		for n in numbers[start_key..numbers.len] {
			num_right := n.int()
			if num_left + num_right == 2020 {
				println(num_left)
				println(num_right)
				println(num_left * num_right)
				break
			}
		}
	}
}