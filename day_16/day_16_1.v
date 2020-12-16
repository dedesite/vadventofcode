import os

fn parse_rule(rule_str string) []int {
	rule_numbers := rule_str.split(':')[1]
	mut n := rule_numbers.split('or')
	n = [
		n[0].split('-')[0],
		n[0].split('-')[1],
		n[1].split('-')[0],
		n[1].split('-')[1],
	]
	return n.map(it.trim_space().int())
}

fn parse_ticket(ticket_str string) []int {
	return ticket_str.split(',').map(it.int())
}

// returns -1 if no invalid value found
fn find_invalid_value_for_ticket(ticket []int, rules [][]int) int {
	for value in ticket {
		mut valid := false
		for rule in rules {
			if (value >= rule[0] && value <= rule[1]) || (value >= rule[2] && value <= rule[3]) {
				valid = true
			}
		}
		if !valid {
			return value
		}
	}
	return -1
}

rules_and_tickets := os.read_lines('input') ?
mut rules := [][]int{}
mut my_ticket_ind := 0
for ind, line in rules_and_tickets {
	if line == '' {
		my_ticket_ind = ind + 2
		break
	}
	rules << parse_rule(line)
}
my_ticket := parse_ticket(rules_and_tickets[my_ticket_ind])
mut ticket_scanning_error_rate := 0
for ticket in rules_and_tickets[my_ticket_ind + 3..rules_and_tickets.len] {
	nearby_ticket := parse_ticket(ticket)
	invalid_value := find_invalid_value_for_ticket(nearby_ticket, rules)
	if invalid_value != -1 {
		ticket_scanning_error_rate += invalid_value
	}
}
println('My ticket scannin error rate is $ticket_scanning_error_rate')
