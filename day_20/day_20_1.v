import os
import strconv

type Tiles = map[string][]u64

fn convert_line_to_uint(line string) u64 {
	return strconv.parse_uint(line.replace_each(['.', '0', '#', '1']), 2, 10)
}

fn parse_tile(tile []string) (string, []u64) {
	num := tile[0].split(' ')[1]
	tile_num := num[0..num.len - 1]

	// border top
	top := convert_line_to_uint(tile[1])
	top_r := convert_line_to_uint(tile[1].reverse())
	// border bottom
	bottom := convert_line_to_uint(tile[10])
	bottom_r := convert_line_to_uint(tile[10].reverse())

	mut left_array := []string{}
	mut right_array := []string{}
	// Then check for the left and right borders
	for line in tile[1..tile.len] {
		left_array << line[0].str()
		right_array << line[line.len - 1].str()
	}

	left := convert_line_to_uint(left_array.join(''))
	left_r := convert_line_to_uint(left_array.join('').reverse())
	right := convert_line_to_uint(right_array.join(''))
	right_r := convert_line_to_uint(right_array.join('').reverse())

	return tile_num, [top, top_r, bottom, bottom_r, left, left_r, right, right_r]
}

fn has_linked_border(tile_num string, border u64, tiles_map map[string][]u64) bool {
	for num, borders in tiles_map {
		if num != tile_num {
			if border in borders {
				return true
			}
		}
	}
	return false
}

fn main() {
	tiles_content := os.read_file('input')?

	tiles_list := tiles_content.split('\n\n')

	mut tiles_map := map[string][]u64

	for tile in tiles_list {
		if tile != "" {
			num, borders := parse_tile(tile.split('\n'))
			tiles_map[num] = borders	
		}
	}


	mut corners_id_product := u64(1)
	// Just check for corners, tile that only has 2 borders in common
	for tile_num, borders in tiles_map {
		mut linked_border_count := 0
		for b in borders {
			if has_linked_border(tile_num, b, tiles_map) {
				linked_border_count++
			}
		}
		// Don't know why it's 4 and not 2 ?
		if linked_border_count == 4 {
			println("One corner found $tile_num")
			corners_id_product *= u64(tile_num.int())
		}
	}

	println("Corner product : $corners_id_product")	
}
