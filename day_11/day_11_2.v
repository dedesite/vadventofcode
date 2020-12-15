import os

const (
	empty_seat    = `L`
	occupied_seat = `#`
	floor         = `.`
)

fn get_number_occupied_adjacent_seat(line int, row int, seat_layout []string) int {
	// Starting at left diagonal
	line_diff := [-1, -1, -1, 0, 1, 1, 1, 0]
	row_diff := [-1, 0, 1, 1, 1, 0, -1, -1]
	mut adjacent_seat_count := 0
	current_line := seat_layout[line]
	for ind, diff_line in line_diff {
		mut check_line := diff_line + line
		mut check_row := row_diff[ind] + row
		if (check_line >= 0 && check_line < seat_layout.len) &&
			(check_row >= 0 && check_row < current_line.len) {
			mut check_seat := seat_layout[check_line][check_row]
			if check_seat == occupied_seat {
				adjacent_seat_count++
			} else if check_seat == floor {
				mut check_further := true
				for check_further {
					check_further = false
					check_line = check_line + diff_line
					check_row = check_row + row_diff[ind]
					check_further = (check_line >= 0 &&
						check_line < seat_layout.len) &&
						(check_row >= 0 && check_row < current_line.len)
					if check_further {
						check_seat = seat_layout[check_line][check_row]
						if check_seat == occupied_seat {
							adjacent_seat_count++
							check_further = false
						} else if check_seat == empty_seat {
							check_further = false
						}
					}
				}
			}
		}
	}
	return adjacent_seat_count
}

fn count_occupied_seats(seat_layout []string) int {
	mut occupied_seat_count := 0
	for line in seat_layout {
		for seat in line {
			if seat == occupied_seat {
				occupied_seat_count++
			}
		}
	}
	return occupied_seat_count
}

fn change_seat_state(line string, row_ind int, state string) string {
	// Need to find a better way to replace one element in a string
	return line[0..row_ind] + state + line[row_ind + 1..line.len]
}

mut current_seat_layout := os.read_lines('input') ?
mut new_seat_layout := current_seat_layout.clone()
mut layout_changed := true
for layout_changed {
	layout_changed = false
	for i, line in current_seat_layout {
		for j, seat in line {
			occupied_seat_count := get_number_occupied_adjacent_seat(i, j, current_seat_layout)
			if seat == empty_seat && occupied_seat_count == 0 {
				new_seat_layout[i] = change_seat_state(new_seat_layout[i], j, occupied_seat.str())
				layout_changed = true
			} else if seat == occupied_seat && occupied_seat_count >= 5 {
				new_seat_layout[i] = change_seat_state(new_seat_layout[i], j, empty_seat.str())
				layout_changed = true
			}
		}
	}
	current_seat_layout = new_seat_layout
	println('===============')
	for l in current_seat_layout {
		println(l)
	}
	new_seat_layout = current_seat_layout.clone()
}
count := count_occupied_seats(current_seat_layout)
println('There is $count seats occupied.')
