input := "8,13,1,0,18,9"

struct SpokenNumber {
	number int
	last_position int
}

starting_numbers = input.split(',')
mut turns := 0
mut spoken_number_list := map[string]int
for turns < 2020 {
	if turns < starting_numbers.len {
		spoken_number_list[starting_numbers[turns]] = turns
	}
}
