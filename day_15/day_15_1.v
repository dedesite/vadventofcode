input := '8,13,1,0,18,9'
starting_numbers := input.split(',')
mut turns := 0
mut spoken_number_list := map[string]int{}
mut last_spoken_number := 0
for turns = 1; turns < 30000000; turns++ {
	if turns < starting_numbers.len {
		spoken_number_list[starting_numbers[turns-1]] = turns
		last_spoken_number = starting_numbers[turns].int()
	} else {
		if last_spoken_number.str() in spoken_number_list {
			last_turn := spoken_number_list[last_spoken_number.str()]
			spoken_number_list[last_spoken_number.str()] = turns
			last_spoken_number = turns - last_turn
		} else {
			spoken_number_list[last_spoken_number.str()] = turns
			last_spoken_number = 0
		}

	}
}
println('The 2020th number spoken will be $last_spoken_number')
