import os

fn main() {
	passwords_and_policies := os.read_lines('input') or {
		println(err)
		return
	}
	mut valid_password_count := 0
	for pass_and_pol in passwords_and_policies {
		splited := pass_and_pol.split(' ')
		policy_min := splited[0].split('-')[0].int()
		policy_max := splited[0].split('-')[1].int()
		letter := splited[1][0]
		password := splited.last()
		mut letter_count := 0
		for l in password {
			if l == letter {
				letter_count++
			}
		}
		if letter_count >= policy_min && letter_count <= policy_max {
			valid_password_count++
		}
	}
	println('There is exaclty $valid_password_count valid password in the database')
}
