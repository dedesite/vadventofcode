import os

struct Rule {
	name         string
	value_ranges []int
mut:
	field_index  int = -1
}

fn parse_rule(rule_str string) Rule {
	name := rule_str.split(':')[0]
	rule_numbers := rule_str.split(':')[1]
	mut n := rule_numbers.split('or')
	n = [
		n[0].split('-')[0],
		n[0].split('-')[1],
		n[1].split('-')[0],
		n[1].split('-')[1],
	]
	return Rule{
		name: name
		value_ranges: n.map(it.trim_space().int())
	}
}

fn parse_ticket(ticket_str string) []int {
	return ticket_str.split(',').map(it.int())
}

fn is_value_in_ranges(value int, range []int) bool {
	return (value >= range[0] && value <= range[1]) || (value >= range[2] && value <= range[3])
}

// returns -1 if no invalid value found
fn find_invalid_value_for_ticket(ticket []int, rules []Rule) int {
	for value in ticket {
		mut valid := false
		for rule in rules {
			if is_value_in_ranges(value, rule.value_ranges) {
				valid = true
			}
		}
		if !valid {
			return value
		}
	}
	return -1
}

fn find_rule_field_index(rule Rule, nearby_tickets [][]int, indexes_already_taken []int) []int {
	mut good_indexes := []int{}
	for ticket_ind, ticket in nearby_tickets {
		mut current_good_indexes := []int{}
		for ind, value in ticket {
			if is_value_in_ranges(value, rule.value_ranges) {
				current_good_indexes << ind
			}
		}
		if ticket_ind == 0 {
			good_indexes = current_good_indexes
		} else {
			good_indexes = good_indexes.filter(it in current_good_indexes &&
				it !in indexes_already_taken)
		}
	}
	return good_indexes
}

rules_and_tickets := os.read_lines('input') ?
mut rules := []Rule{}
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
mut valid_tickets := [][]int{}
for ticket in rules_and_tickets[my_ticket_ind + 3..rules_and_tickets.len] {
	nearby_ticket := parse_ticket(ticket)
	invalid_value := find_invalid_value_for_ticket(nearby_ticket, rules)
	if invalid_value != -1 {
		ticket_scanning_error_rate += invalid_value
	} else {
		valid_tickets << nearby_ticket
	}
}
mut indexes_already_taken := []int{}
for indexes_already_taken.len < rules.len {
	// Possible bug ? rule is copied and not referenced
	// for mut rule in rules.filter(it.field_index == -1) {
	for mut rule in rules {
		if rule.field_index == -1 {
			indexes := find_rule_field_index(rule, valid_tickets, indexes_already_taken)
			if indexes.len == 1 {
				rule.field_index = indexes[0]
				indexes_already_taken << indexes[0]
			}
		}
	}
}
rules.sort(a.field_index < b.field_index)
for ticket in valid_tickets {
	for ind, field in ticket {
		rule_field := rules[ind]
		if !is_value_in_ranges(field, rule_field.value_ranges) {
			panic('Problem field $field is not valid rule : $rule_field')
		}
	}
}
mut departure_values := i64(1)
for ind, field in my_ticket {
	rule_field := rules[ind]
	// Add startwith method
	if rule_field.name.split(' ')[0] == 'departure' {
		departure_values *= field
	}
}
println('The product of departure values is $departure_values')
