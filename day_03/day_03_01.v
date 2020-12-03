import os

fn main() {
	toboggan_map := os.read_lines('input') or {
		println(err)
		return
	}
	mut x_pos := 0
	mut tree_encountered := 0
	// Start at line 1, we don't count tree on first line
	for line in toboggan_map[1..toboggan_map.len] {
		x_pos = (x_pos + 3) % line.len
		if line[x_pos] == `#` {
			tree_encountered++
		}
	}

	println("You would encoutered $tree_encountered trees by using this scheme.")
}