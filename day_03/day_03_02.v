import os

const (
	slope_list = [
		{'right': 1, 'down': 1},
		{'right': 3, 'down': 1},
		{'right': 5, 'down': 1},
		{'right': 7, 'down': 1},
		{'right': 1, 'down': 2},
	]
)	

fn main() {
	toboggan_map := os.read_lines('input') or {
		println(err)
		return
	}
	
	mut total_tree_encountered := i64(1)
	for slope in slope_list {
		mut tree_encountered := 0
		mut x_pos := 0
		// Start at the first slope
		for index, line in toboggan_map[slope['down']..toboggan_map.len] {
			if index % slope['down'] != 0 {
				continue
			}
			x_pos = (x_pos + slope['right']) % line.len
			if line[x_pos] == `#` {
				tree_encountered++
			}
		}
		println("Tree encounter for slope $slope : $tree_encountered ")
		total_tree_encountered *= tree_encountered
	}	

	println("You would encoutered $total_tree_encountered trees by using this scheme.")
}