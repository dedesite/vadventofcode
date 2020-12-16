const (
	total_turns = 30000000
	)

input := '8,13,1,0,18,9'
starting_numbers := input.split(',')
mut turns := 0
mut spoken_number_list := []int{len: total_turns, init: -1}
mut last_spoken_number := 0
for turns = 1; turns < total_turns; turns++ {
	if turns < starting_numbers.len {
		spoken_number_list[starting_numbers[turns-1].int()] = turns
		last_spoken_number = starting_numbers[turns].int()
	} else {
		if spoken_number_list[last_spoken_number] != -1 {
			last_turn := spoken_number_list[last_spoken_number]
			spoken_number_list[last_spoken_number] = turns
			last_spoken_number = turns - last_turn
		} else {
			spoken_number_list[last_spoken_number] = turns
			last_spoken_number = 0
		}

	}
}
println('The 2020th number spoken will be $last_spoken_number')
