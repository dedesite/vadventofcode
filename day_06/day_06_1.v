import os

answers_content := os.read_file('input') ?
answers_group := answers_content.split('\n\n')
splited_answers := answers_group.map(it.replace('\n', '')).map(it.split(''))
mut yes_count := 0
for group in splited_answers {
	mut single_letters := []string{}
	for letter in group {
		if letter !in single_letters {
			single_letters.push(letter)
		}
	}
	yes_count += single_letters.len
}
println('The sum of the yes anwsers is : $yes_count')
