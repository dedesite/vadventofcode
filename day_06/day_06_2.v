import os

fn get_everyone_yes(group string) int {
	answers := group.split('\n')
	mut min_len := answers.first().len
	for answer in answers[1..answers.len] {
		a := answer.split('').filter(it in answers.first())
		if a.len < min_len {
			min_len = a.len
		}
	}
	return min_len
}

answers_content := os.read_file('input') ?
answers_group := answers_content.split('\n\n')
mut yes_count := 0
for group in answers_group {
	yes_count += get_everyone_yes(group)
}
println('The sum of the yes anwsers is : $yes_count')
