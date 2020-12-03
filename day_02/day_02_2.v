import os

fn main() {
	passwords_and_policies := os.read_lines('input') or {
		println(err)
		return
	}
	mut valid_password_count := 0
	for pass_and_pol in passwords_and_policies {
		splited := pass_and_pol.split(' ')
		letter_pos_1 := splited[0].split('-')[0].int()
		letter_pos_2 := splited[0].split('-')[1].int()
		letter := splited[1][0]
		password := splited.last()
		mut letter_count := 0
		for index, l in password {
			if l == letter && (index + 1 == letter_pos_1 || index + 1 == letter_pos_2) {
				letter_count++
			}
		}
		if letter_count == 1 {
			valid_password_count++
		}
	}
	println('There is exaclty $valid_password_count valid password in the database')
}
