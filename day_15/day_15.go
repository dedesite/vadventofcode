// Solution taken from 
// https://www.reddit.com/r/adventofcode/comments/kdf85p/2020_day_15_solutions/gfypyty

package main

import "fmt"

const (N = 30_000_000; K = 6; I0 = K - 1)

func main(){
    data := [N]int{8,13,1,0,18,9}
    rec := [N]int{}
    spoken := 0
    for i, d := range(data[:K-1]) {
        rec[d] = i+1
    }
    for i := I0; i+2 <= N; i++{
        n := data[i]    
        w := rec[n]
        if w == 0{
            rec[n] = i+1
            spoken = 0
            data[i+1] = spoken
        } else {
            spoken = i+1-w
            data[i+1] = spoken
            rec[n] = i+1
        }
    }
    fmt.Println("spoken", spoken)
}