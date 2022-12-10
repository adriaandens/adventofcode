# Day 10

I've implemented a dumb solution in O(n^2) runtime and O(n) memory.

I could do better and code up a 0(n) solution and O(1) memory by just remembering the previous cycle and current cycle. Also noting that the blipping of the CRT can be implemented in bitwise logic (40 bits line of Sprite position AND register value) which should also give better results on larger datasets.
