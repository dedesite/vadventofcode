import os

const (
	expected_fields = [
		'byr',
		'iyr',
		'eyr',
		'hgt',
		'hcl',
		'ecl',
		'pid',
	]
)

fn main() {
	passport_content := os.read_file('input') or {
		println(err)
		return
	}
	passport_list := passport_content.split('\n\n')
	mut valid_passport_count := 0
	for passport in passport_list {
		clean_pass := passport.replace('\n', ' ').trim_space()
		fields := clean_pass.split(' ').map(it.split(':')[0])
		mut valid := true
		for expected in expected_fields {
			if expected !in fields {
				valid = false
			}
		}
		if valid {
			valid_passport_count++
		}
	}
	println('There is $valid_passport_count valid passport')
}
