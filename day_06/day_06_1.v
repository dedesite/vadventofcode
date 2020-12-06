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

answers_content := os.read_file('input') ?
answers_group := answers_content.split('\n\n')
answers := answers_group.map(it.replace('\n', ''))
mut yes_count := 0
for group in answers {
	yes_count += remove_duplicates(group).len
}
println('The sum of the yes anwsers is : $yes_count')
