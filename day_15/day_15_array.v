// Solution taken from 
// https://www.reddit.com/r/adventofcode/comments/kdf85p/2020_day_15_solutions/gfypyty

const (
	n  = 30000000
	k  = 6
	i0 = k - 1
)

mut data := []int{ len: n, init:-1 }
input := '8,13,1,0,18,9'
for i, num in input.split(',') {
	data[i] = num.int()
}

mut rec := [n]int{}
mut spoken := 0
for i, d in data[0..k - 1] {
	rec[d] = i + 1
}
for i := i0; i + 2 <= n; i++ {
	n := data[i]
	w := rec[n]
	if w == 0 {
		rec[n] = i + 1
		spoken = 0
		data[i + 1] = spoken
	} else {
		spoken = i + 1 - w
		data[i + 1] = spoken
		rec[n] = i + 1
	}
}
println('spoken $spoken')
