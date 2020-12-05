import os

fn bisect(min_num int, max_num int, seat_str string, lower_char byte, upper_char byte) int {
	if seat_str.len == 0 {
		return min_num
	}
	new_min := if seat_str[0] == lower_char { min_num } else { min_num + (max_num - min_num) / 2 + 1 }
	new_max := if seat_str[0] == upper_char { max_num } else { new_min + (max_num - new_min) / 2 }
	return bisect(new_min, new_max, seat_str[1..seat_str.len], lower_char, upper_char)
}

fn calculate_seat_id(seat_str string) int {
	row := bisect(0, 127, seat_str[0..7], `F`, `B`)
	column := bisect(0, 7, seat_str[7..seat_str.len], `L`, `R`)
	return row * 8 + column
}

fn main() {
	seat_list := os.read_lines('input') or {
		println(err)
		return
	}
	seat_id_list := seat_list.map(calculate_seat_id(it))
	highest_seat_id := seat_id_list.reduce(fn (highest int, current int) int {
		return if current > highest { current } else { highest }
	}, 0)
	println('The highest seat ID is $highest_seat_id')
}
