const (
	total_turns = 30000000
)

input := '8,13,1,0,18,9'
starting_numbers := input.split(',')
mut turns := 0
mut spoken_number_list := []int{len: total_turns, init: -1}
mut last_spoken_number := 0
for turns = 1; turns < starting_numbers.len; turns++ {
	spoken_number_list[starting_numbers[turns - 1].int()] = turns
	last_spoken_number = starting_numbers[turns].int()
}
for turns = starting_numbers.len; turns < total_turns; turns++ {
	last_turn := spoken_number_list[last_spoken_number]
	spoken_number_list[last_spoken_number] = turns
	last_spoken_number = if last_turn == -1 { 0 } else { turns - last_turn }
}
println('The ${total_turns}th number spoken will be $last_spoken_number')
