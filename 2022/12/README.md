# Day 12

The one who says "shortest path", says "Dijkstra". So that's what I did today. 

It isn't a particulary _good_ implementation of Dijkstra because I implemented the `get_next_node()` in O(n), whilst a maintaining a sorted list or priority queue would give a faster result.

For part 2, I implemented `y.xl` by doing Dijkstra for each of `a` elevations and then resetting the state. A faster way, `fast_y.pl`, does it in 1 go. We just tag all `a` points as distance 0 instead of infinity and Dijkstra will correctly calculcate the shortest path to `z` from any of the `a` elevations.

Smarter people than myself have also figured out that you can just do a breadth-first-search. And that for part 2 you can work yourself from the end point `z` to the first `a` that gets the state 'visited' (in Dijkstra's algorithm that is).
