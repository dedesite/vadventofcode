import os

fn is_previous_number_sum(wanted_num int, previous []int) bool {
	for ind, left in previous {
		for right in previous[ind..previous.len] {
			if left + right == wanted_num {
				return true
			}
		}
	}
	return false
}

numbers_str := os.read_lines('input')?
numbers := numbers_str.map(it.int())

for i, n in numbers[25..numbers.len] {
	if !is_previous_number_sum(n, numbers[i..i+25]) {
		println("The first number that is not the sum of 25 previous number is : $n")
		break
	}
}