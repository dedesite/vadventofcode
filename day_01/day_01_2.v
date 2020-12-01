import os

fn main() {
	numbers := os.read_lines('input') ?
	mut start_key := 0
	mut founded := false
	for num in numbers {
		num_left := num.int()
		start_key++
		for n in numbers[start_key..numbers.len] {
			num_middle := n.int()
			if founded {
				break
			}
			for nr in numbers[start_key+1..numbers.len] {
				num_right := nr.int()
				if num_left + num_middle + num_right == 2020 {
					println(num_left)
					println(num_middle)
					println(num_right)
					println(num_left * num_middle * num_right)
					founded = true
					break
				}
			}
		}
	}
}