import os

fn push_to_contigus(contigus_ones int, mut contigus_ones_list []int) {
	if contigus_ones == 2 {
		contigus_ones_list << 2
	} else if contigus_ones == 3 {
		contigus_ones_list << 4
	} else if contigus_ones > 3 {
		contigus_ones_list << 4 + 3 * (contigus_ones - 3)
	}
}

joltage_str := os.read_lines('small_input') ?
mut joltage_list := joltage_str.map(it.int())
joltage_list.sort()
// Add the first value corresponding to the initial joltage
joltage_list.prepend(0)
println(joltage_list)
// We have at least 3 joltage diff from the device
mut diff_3 := 1
mut diff_1 := 0
mut contigus_ones_list := []int{}
mut contigus_ones := 0
for i, joltage in joltage_list[0..joltage_list.len - 1] {
	diff := joltage_list[i + 1] - joltage
	match diff {
		1 {
			diff_1++
			contigus_ones++
		}
		3 {
			push_to_contigus(contigus_ones, mut contigus_ones_list)
			contigus_ones = 0
			diff_3++
		}
		else {}
	}
}
push_to_contigus(contigus_ones, mut contigus_ones_list)
combinaisons := contigus_ones_list.reduce(fn (combin int, curr int) int {
	return if combin == 0 { curr } else { combin * curr }
}, 0)
println('diff 1 : $diff_1, diff 3 : $diff_3 total = ${diff_1 * diff_3}')
println('Number of possible combinaisons $combinaisons')
