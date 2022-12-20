# Day 20

Implemented using a fixed array and a linked list. The fixed array contains pointers to the items in the original order that they appeared. The Linked List allows for O(1) inserts and deletes when moving an item.

Only "two tricks":
* I initially only unlinked after I found the correct position but this renders incorrect results when you start looping so I have to really unlink it after I start moving pointers.
* doing `$value % length(array) - 1` does `($value % length(array)) - 1` instead of what I wanted: `$value % (length(array) -1)`. Took me a bit of troubleshooting to correct this mistake.

```
Original: 
1, 20, -3, 3, -2, 0, 4

If we need to move '20', we can just move 2 times instead.
We notice that after moving 6 times to the right, we end up back in the same position and the length of the array is 7. so the "formula" is $val % (length(array) - 1) (20 % 6 = 2
```
