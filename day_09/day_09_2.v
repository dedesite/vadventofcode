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

fn find_encryption_weakness(total int, num_list []int) int {
	for ind, num in num_list {
		mut sum := num
		mut smallest := num
		mut largest := num
		mut sum_ind := ind + 1
		for sum <= total {
			curr_num := num_list[sum_ind]
			sum += curr_num
			if curr_num < smallest {
				smallest = curr_num
			} else if curr_num > largest {
				largest = curr_num
			}
			if sum == total {
				//todo add smallest and largest
				return smallest + largest
			}
			sum_ind++
		}
	}
	return 0
}

numbers_str := os.read_lines('input')?
numbers := numbers_str.map(it.int())

for i, n in numbers[25..numbers.len] {
	if !is_previous_number_sum(n, numbers[i..i+25]) {
		println("The first number that is not the sum of 25 previous number is : $n")

		weakness := find_encryption_weakness(n, numbers)
		println("Encryption weakness is $weakness")
		break
	}
}