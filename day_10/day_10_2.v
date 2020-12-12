import os

const (
	// I discovered by guessing that the possibilities were evolving
	// this way. And after a reading realize that it was called a tribonaci sequence
	tribonaci_sequence = [1, 1, 2, 4, 7]
)

joltage_str := os.read_lines('input') ?
mut joltage_list := joltage_str.map(it.int())
joltage_list.sort()
// Add the first value corresponding to the initial joltage
joltage_list.prepend(0)
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
			contigus_ones_list << tribonaci_sequence[contigus_ones]
			contigus_ones = 0
			diff_3++
		}
		else {}
	}
}
contigus_ones_list << tribonaci_sequence[contigus_ones]
mut combinaisons := i64(contigus_ones_list[0])
for el in contigus_ones_list[1..contigus_ones_list.len] {
	combinaisons *= el
}

println('diff 1 : $diff_1, diff 3 : $diff_3 total = ${diff_1 * diff_3}')
println('Number of possible combinaisons $combinaisons')
