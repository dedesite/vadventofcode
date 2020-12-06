import os

fn remove_duplicates(s string) string {
	mut single_letters := ''
	for letter in s {
		if letter.str() !in single_letters {
			single_letters += letter.str()
		}
	}
	return single_letters
}

fn get_everyone_yes(group string) int {
	answers := group.split('\n')
	first_person := remove_duplicates(answers[0])
	mut min_len := first_person.len
	for answer in answers {
		a := answer.split('').filter(it in first_person)
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
