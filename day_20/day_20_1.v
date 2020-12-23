import os

enum Position {
	top
	right
	bottom
	left
}

struct Tile {
mut:
	id              u64
	borders         []string = []string{len: 4}
	reverse_borders []string = []string{len: 4}
}

fn parse_tile(tile_str []string) Tile {
	mut tile := Tile{}
	// line format : "Tile 2129:"
	num := tile_str[0].split(' ')[1]
	tile.id = u64(num[0..num.len - 1].int())
	// border top
	tile.borders[Position.top] = tile_str[1]
	// border bottom
	tile.borders[Position.bottom] = tile_str[10]
	tile_lines := tile_str[1..tile_str.len]
	tile.borders[Position.left] = tile_lines.map(it[0].str()).join('')
	tile.borders[Position.right] = tile_lines.map(it[it.len - 1].str()).join('')
	tile.reverse_borders = tile.borders.map(it.reverse())
	return tile
}

fn has_linked_border(tile_id u64, border string, tiles_array []Tile) bool {
	for tile in tiles_array {
		if tile.id != tile_id {
			if border in tile.borders || border in tile.reverse_borders {
				return true
			}
		}
	}
	return false
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
	// Just check for corners, tile that only has 2 borders in common
	for tile in tiles_array {
		mut linked_border_count := 0
		for b in tile.borders {
			if has_linked_border(tile.id, b, tiles_array) {
				linked_border_count++
			}
		}
		// Don't know why it's 4 and not 2 ?
		if linked_border_count == 2 {
			println('One corner found $tile.id')
			corners_id_product *= tile.id
		}
	}
	println('Corner product : $corners_id_product')
}
