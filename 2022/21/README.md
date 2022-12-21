# Day 21

For part 2 I got a funky solution. At first I thought of recreating the function `f(humn)` and then use z3 to find a number which matches the constraints (or eval-ing).

But I found out by doing dumb things (*cough* bruteforce from 0 to infinity) that increasing `humn` slowly decreased `root` when changing it to `root: a - b` since we want to get 0. This meant that for my input, there was possibly a linear correlation between both.

So I did what every sane person would do: I pursued to create a smarter bruteforce but with bigger steps. If the root value would go under zero, I knew my `humn` was too big and I had to decrease it again, ....

It takes around 440 rounds to find a correct answer in this way.
