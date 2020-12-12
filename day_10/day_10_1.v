import os

joltage_str := os.read_lines('input')?
mut joltage_list := joltage_str.map(it.int())
joltage_list.sort()

// Not realy true but works
mut diff_3 := if joltage_list[0] == 3 { 2 } else { 1 }
mut diff_1 := if joltage_list[0] == 1 { 1 } else { 0 }
for i, joltage in joltage_list[0..joltage_list.len - 1] {
	diff := joltage_list[i+1] - joltage
	match diff {
		1 { diff_1++ }
		3 { diff_3++ }
		else { println("Diff $diff")}
	}
}

println("diff 1 : $diff_1, diff 3 : $diff_3 total = ${diff_1 * diff_3}")