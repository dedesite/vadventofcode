import os
import regex

type MyString = string

fn (s MyString) match_regex(pattern string) bool {
	mut re := regex.new()
	re.compile_opt(pattern) or {
		println(err)
	}
	start, end := re.match_string(s)
	return start >= 0 && end > start
}

const (
	expected_fields = {
		'byr': fn (f string) bool {
			return f.len == 4 && f.int() >= 1920 && f.int() <= 2002
		}
		'iyr': fn (f string) bool {
			return f.len == 4 && f.int() >= 2010 && f.int() <= 2020
		}
		'eyr': fn (f string) bool {
			return f.len == 4 && f.int() >= 2020 && f.int() <= 2030
		}
		'hgt': fn (f string) bool {
			height := f[0..f.len - 2].int()
			if f.ends_with('cm') {
				return height >= 150 && height <= 193
			} else if f.ends_with('in') {
				return height >= 59 && height <= 76
			}
			return false
		}
		'hcl': fn (f MyString) bool {
			return f.match_regex(r'^#[0-9a-f]{6}$')
		}
		'ecl': fn (f string) bool {
			return f in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
		}
		'pid': fn (f string) bool {
			return f.len == 9 && f.int() != 0
		}
	}
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
		fields := clean_pass.split(' ')
		filed_names := fields.map(it.split(':')[0])
		values := fields.map(it.split(':')[1])
		mut valid := true
		for expected, is_valid_fn in expected_fields {
			ind_f := filed_names.index(expected)
			if ind_f == -1 || !is_valid_fn(values[ind_f]) {
				valid = false
			}
		}
		if valid {
			valid_passport_count++
		}
	}
	println('There is $valid_passport_count valid passport')
}
