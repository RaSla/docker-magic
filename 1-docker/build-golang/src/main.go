package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Printf("Starting: %s", time.Now().Local())
	var i_counter = 0
	var l_counter = 0
	for i_loop1 := 0; i_loop1 < 10; i_loop1++ {
		fmt.Printf("\nloop1: %#v", i_loop1)
		for i_loop2 := 0; i_loop2 < 32000; i_loop2++ {
			for i_loop3 := 0; i_loop3 < 32000; i_loop3++ {
				i_counter++
				l_counter++
				if i_counter > 50 {
					i_counter = 0
				}
			}
		}
	}

	fmt.Printf("\ni_counter: %#v", i_counter)
	fmt.Printf("\nl_counter: %#v", l_counter)
	fmt.Printf("\nEnd: %s\n", time.Now().Local())
}
