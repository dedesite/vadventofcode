import os

const (
	num_cycles = 6
)

fn get_pos(str_pos string) (int, int, int, int) {
	pos := str_pos.split(',').map(it.int())
	return pos[0], pos[1], pos[2], pos[3]
}

fn is_pos_active(str_pos string, grid map[string]bool) bool {
	return if str_pos in grid {
		grid[str_pos]
	} else {
		false
	}
}

// Look at the 26 different direct neighboors of a cube
// and determine it's new state based on AoC rules
fn calculate_cube_new_state(str_pos string, grid map[string]bool) bool {
	// If cube is not in the grid, means it's inactive
	is_active := is_pos_active(str_pos, grid)
	x_pos, y_pos, z_pos, w_pos := get_pos(str_pos)
	dir := [1, 0, -1]
	mut active_neighbors := 0
	for w in dir {
		for z in dir {
			for y in dir {
				for x in dir {
					// If we aren't looking at our cube
					if !(x == 0 && y == 0 && z == 0 && w == 0) {
						// Check neighbour state
						neighbor_pos := '${x + x_pos},${y + y_pos},${z + z_pos},${w + w_pos}'
						if is_pos_active(neighbor_pos, grid) {
							active_neighbors++
						}
					}
				}
			}
		}
	}
	if is_active {
		return active_neighbors == 2 || active_neighbors == 3
	} else {
		return active_neighbors == 3
	}
}

fn run_cycle(grid map[string]bool) map[string]bool {
	mut next_cycle_grid := grid.clone()
	dir := [1, 0, -1]
	// We calculate active state for each active cube + it's neighbors
	for cube_pos, is_active in grid {
		if is_active {
			x_pos, y_pos, z_pos, w_pos := get_pos(cube_pos)
			for w in dir {
				for z in dir {
					for y in dir {
						for x in dir {
							str_pos := '${x + x_pos},${y + y_pos},${z + z_pos},${w + w_pos}'
							next_cycle_grid[str_pos] = calculate_cube_new_state(str_pos,
								grid)
						}
					}
				}
			}
		}
	}
	return next_cycle_grid
}

// Store the x, y, z coordinate as map keys and active or inactive state as bool
mut grid := map[string]bool{}
initial_state := os.read_lines('input') ?
z := 0
w := 0
for y, line in initial_state {
	for x, state in line {
		grid['$x,$y,$z,$w'] = if state == `#` { true } else { false }
	}
}
for _ in 0 .. num_cycles {
	grid = run_cycle(grid)
}
mut active_cube_count := 0
for _, is_active in grid {
	if is_active {
		active_cube_count++
	}
}
println('Number of cubes left active after $num_cycles cycles : $active_cube_count')
