import os
import regex

const (
	top                = 0
	right              = 1
	bottom             = 2
	left               = 3
	linked_dir         = [bottom, left, top, right]
	monster_top        = r'[.#]{18}#[.#]{1}'
	monster_middle     = r'#[.#]{4}##[.#]{4}##[.#]{4}###'
	monster_bottom     = r'[.#]{1}#[.#]{2}#[.#]{2}#[.#]{2}#[.#]{2}#[.#]{2}#[.#]{3}'
	monster_char_count = 15
)

type MyString = string

// todo : add this to regex module
fn (s MyString) match_regex(pattern string) bool {
	mut re := regex.new()
	re.compile_opt(pattern) or { println(err) }
	start, end := re.match_string(s)
	return start >= 0 && end > start
}

struct Tile {
mut:
	id              u64
	borders         []string = []string{len: 4}
	reverse_borders []string = []string{len: 4}
	linked_tiles    []u64    = []u64{len: 4}
	content         []string = []string{len: 8}
}

fn (t Tile) str() string {
	mut str := []string{}
	str << 'Tile : $t.id\n'
	mut l := t.borders[left][0].str()
	mut r := t.borders[right][0].str()
	str << '$l ${t.borders[top]} $r\n'
	for ind, line in t.content {
		// bug ?
		l = t.borders[left][ind + 1].str()
		r = t.borders[right][ind + 1].str()
		str << '$l  $line  $r\n'
	}
	l = t.borders[left][9].str()
	r = t.borders[right][9].str()
	str << '$l ${t.borders[bottom]} $r\n'
	return str.join('')
}

fn parse_tile(tile_str []string) Tile {
	mut tile := Tile{}
	// line format : "Tile 2129:"
	num := tile_str[0].split(' ')[1]
	tile.id = u64(num[0..num.len - 1].int())
	// border top
	tile.borders[top] = tile_str[1]
	// border bottom
	tile.borders[bottom] = tile_str[10]
	tile_lines := tile_str[1..tile_str.len]
	tile.borders[left] = tile_lines.map(it[0].str()).join('')
	tile.borders[right] = tile_lines.map(it[it.len - 1].str()).join('')
	tile.reverse_borders = tile.borders.map(it.reverse())
	content := tile_str[2..tile_str.len - 1]
	tile.content = content.map(it[1..it.len - 1])
	return tile
}

fn (mut t Tile) rotate_right() {
	mut new_borders := []string{len: 4}
	// Rotate borders
	new_borders[top] = t.borders[left].reverse()
	new_borders[right] = t.borders[top]
	new_borders[bottom] = t.borders[right].reverse()
	new_borders[left] = t.borders[bottom]
	t.borders = new_borders
	// Don't forget linked tiles
	t.linked_tiles.prepend(t.linked_tiles[left])
	t.linked_tiles.delete_last()
	// Then content
	mut new_content := []string{len: 8}
	for ind in 0 .. t.content.len {
		mut rotate_line := []string{}
		for line in t.content.reverse() {
			rotate_line << line[ind].str()
		}
		new_content[ind] = rotate_line.join('')
	}
	t.content = new_content
	t.reverse_borders = t.borders.map(it.reverse())
}

fn (mut t Tile) reverse_horizontal() {
	mut new_borders := []string{len: 4}
	new_borders[top] = t.borders[top].reverse()
	new_borders[right] = t.borders[left]
	new_borders[bottom] = t.borders[bottom].reverse()
	new_borders[left] = t.borders[right]
	t.borders = new_borders
	linked_right := t.linked_tiles[right]
	t.linked_tiles[right] = t.linked_tiles[left]
	t.linked_tiles[left] = linked_right
	t.content = t.content.map(it.reverse())
	t.reverse_borders = t.borders.map(it.reverse())
}

fn align_tiles(good_tile Tile, good_border_id int, to_align_tile Tile) Tile {
	mut aligned_tile := to_align_tile
	for (good_tile.borders[good_border_id] != aligned_tile.borders[linked_dir[good_border_id]]) &&
		(good_tile.borders[good_border_id] !=
		aligned_tile.reverse_borders[linked_dir[good_border_id]]) {
		aligned_tile.rotate_right()
	}
	// If it needs to be reversed
	if good_tile.borders[good_border_id] != aligned_tile.borders[linked_dir[good_border_id]] {
		if good_border_id in [left, right] {
			aligned_tile.rotate_right()
		}
		aligned_tile.reverse_horizontal()
		if good_border_id in [left, right] {
			for _ in 0 .. 3 {
				aligned_tile.rotate_right()
			}
		}
	}
	return aligned_tile
}

fn get_linked_tiles(tile Tile, tiles_array []Tile) []u64 {
	mut linked_tiles := []u64{len: 4}
	for curr_tile in tiles_array {
		if curr_tile.id != tile.id {
			for pos, border in tile.borders {
				if border in curr_tile.borders || border in curr_tile.reverse_borders {
					linked_tiles[pos] = curr_tile.id
				}
			}
		}
	}
	return linked_tiles
}

fn rotate_camera_array_right(camera_array []string) []string {
	mut new_content := []string{len: camera_array.len}
	for ind in 0 .. camera_array.len {
		mut rotate_line := []string{}
		for line in camera_array.reverse() {
			rotate_line << line[ind].str()
		}
		new_content[ind] = rotate_line.join('')
	}
	return new_content
}

fn reverse_camera_array(camera_array []string) []string {
	return camera_array.map(it.reverse())
}

fn generate_camera_array(upper_left_corner Tile, tiles_array []Tile) []string {
	mut camera_array := []string{}
	mut current_tile := upper_left_corner
	mut first_col := current_tile
	mut current_count := 0
	mut current_line_num := 0
	camera_array = current_tile.content
	for current_count < tiles_array.len {
		right_id := current_tile.linked_tiles[right]
		if right_id == 0 {
			bottom_id := first_col.linked_tiles[bottom]
			if bottom_id != 0 {
				current_tile = tiles_array.filter(it.id == bottom_id)[0]
				current_tile = align_tiles(first_col, bottom, current_tile)
				first_col = current_tile
				for line in current_tile.content {
					camera_array << line
				}
			}
			current_line_num++
			current_count++
			continue
		}
		mut right_tile := tiles_array.filter(it.id == right_id)[0]
		right_tile = align_tiles(current_tile, right, right_tile)
		for ind, line in right_tile.content {
			line_num := right_tile.content.len * current_line_num + ind
			camera_array[line_num] = '${camera_array[line_num]}$line'
		}
		current_tile = right_tile
		current_count++
	}
	return camera_array
}

fn count_sea_monsters(camera_array []string) int {
	mut monster_count := 0
	mut re_top := regex.new()
	mut re_middle := regex.new()
	mut re_bottom := regex.new()
	re_top.compile_opt(monster_top) or { println(err) }
	re_middle.compile_opt(monster_middle) or { println(err) }
	re_bottom.compile_opt(monster_bottom) or { println(err) }
	for ind, line in camera_array[1..camera_array.len - 1] {
		matches := re_middle.find_all(line)
		for i := 0; i < matches.len; i += 2 {
			start := matches[i]
			end := matches[i + 1]
			top := MyString(camera_array[ind][start..end])
			bottom := MyString(camera_array[ind + 2][start..end])
			if top.match_regex(monster_top) && bottom.match_regex(monster_bottom) {
				monster_count++
			}
		}
	}
	return monster_count
}

fn main() {
	tiles_content := os.read_file('input') ?
	tiles_list := tiles_content.split('\n\n')
	mut tiles_array := []Tile{}
	for tile in tiles_list {
		if tile != '' {
			tiles_array << parse_tile(tile.split('\n'))
		}
	}
	mut corners_id_product := u64(1)
	// We try to find the upper_left_corner (may be several because tiles are rotated)
	mut upper_left_corner := Tile{}
	// Just check for corners, tile that only has 2 borders in common
	for mut tile in tiles_array {
		tile.linked_tiles = get_linked_tiles(tile, tiles_array)
		linked := tile.linked_tiles.filter(it != 0)
		if linked.len == 2 {
			corners_id_product *= tile.id
			if tile.linked_tiles[right] != 0 && tile.linked_tiles[bottom] != 0 {
				upper_left_corner = tile
			}
		}
	}
	mut camera_array := generate_camera_array(upper_left_corner, tiles_array)
	mut monster_count := 0
	for _ in 0 .. 4 {
		mut count := count_sea_monsters(camera_array)
		if count > monster_count {
			monster_count = count
		}
		camera_array = reverse_camera_array(camera_array)
		count = count_sea_monsters(camera_array)
		if count > monster_count {
			monster_count = count
		}
		camera_array = reverse_camera_array(camera_array)
		camera_array = rotate_camera_array_right(camera_array)
	}
	mut sharp_count := 0
	for line in camera_array {
		sharp_count += line.replace('.', '').len
	}
	water_roughness := sharp_count - (monster_count * monster_char_count)
	println('Water roughness : $water_roughness sharp count $sharp_count')
}
