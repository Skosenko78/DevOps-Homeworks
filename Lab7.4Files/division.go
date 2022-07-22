package main

import "fmt"

func main() {

	var array []int
	for i := 1; i < 100; i++ {
		if (i % 3) == 0 {
			array = append(array, i)
		}
	}
	fmt.Println("Can be divided by 3:", array)
}
