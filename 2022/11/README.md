# Day 11

The first part is just coding up the problem, the second part is where things get interesting.

## Part 2

Reading quickly through the description of part 2, you think "that's a minor change in the code". So you remove a bit of the code and change the number of rounds to 10.000 and off you go! Right? Well no. Turns out things were not so easy in Perl.

If you just run the code with some debug prints, you'll notice that at several stages you see a "Inf" where you expect a number. That's not good. So you transparently enable a Big Integer library by _using_ `use bigint;`. And off we go again only to notice that it _hangs_. Turns out that the numbers get ridiculously big.

In the words of AoC, we need to keep our worry levels under control.

### Solving

To abstract the problem a bit, we basically have a really big number _a_ which is divided by the test numbers. In our code, the remainder decides what path to take in the code and which monkey the item is passed.
So if we find an equivalent (smaller) number _b_ which has the same remainders as the really big number _a_, we take the same branches in our code and we can keep our number arithmetics under control.

Now how do find a smaller number _b_ or how do find a bigger divisor so our number becomes smaller without messing up the remainders and thus the branches we take in our code? 

If you say remainders, you say **modulo**. And when you say **modulo**, you say _number theory_. The following is true:
```
If <bigger divisor> mod <test divisor> = 0:
(a mod <test divisor>) mod <bigger divisor> = a mod <bigger divisor>
``` 

The first line means that the bigger divisor we need to find needs to be a multiple of our test divisor. The second line means that you can switch out the smaller test divisor by the bigger divisor and the module/remainder result will stay the same.

Since we have different test divisors and our item can move to any monkey (in theory), we actually need to find a bigger divisor that holds for every of the test divisors, so:
```
<bigger divisor> mod <test divisor monkey 0> = 0
<bigger divisor> mod <test divisor monkey 1> = 0
<bigger divisor> mod <test divisor monkey 2> = 0
<bigger divisor> mod <test divisor monkey 3> = 0
<bigger divisor> mod <test divisor monkey 4> = 0
...
```

The easiest way to find such a bigger divisor is just to take the product of all the test divisors, it's guaranteed to be divisable by all test numbers since we used the test divisors to make the bigger divisor. For prime numbers, this is also the optimal lowest common multiplier (LCM) between the test divisors. For other natural numbers, this is just one of the solutions but not guaranteed to be the lowest (which is OK for us!).

So that's a lot of words to say that to find the smaller _b_ we just modulo our big number _a_ by the product of the test divisors and we take the same branches in the code.

#### Example(s)

Let's say our big number _a_ is 200 and the test numbers are 3, 5, 7 (prime numbers)
```
a / 3 = 200 / 3 = 63*3 with remainder 2
a / 5 = 200 / 5 = 40*5 with remainder 0
a / 7 = 200 / 7 = 28*7 with remainder 4
```

To find a smaller _b_:
```
a / 3*5*7 = 200 / 105 = 1*105 + remainder 95
```

So 95 is our _b_, we can check to see that it will give the same remainders and thus take the same branches in the code:
```
95 / 3 = 31*3 with remainder 2
95 / 5 = 19*5 with remainder 0
95 / 7 = 13*7 with remainder 4
```

As you can see, the remainders stay the same.

Another example with 323 as our _a_:
```
a % 3 = 323 % 3 = remainder 2
a % 5 = 323 % 5 = remainder 3
a % 7 = 323 % 7 = remainder 1

323 / 105 (remember 105 the product of our prime test numbers 3, 5 and 7) = 3*105 with remainder 8.

Verifying:
b % 3 = 8 % 3 = remainder 2
b % 5 = 8 % 5 = remainder 3
b % 7 = 8 % 7 = remainder 1
```

#### My code for part 2

My code is a bit weird in that I only found out about the above _number theory_ after messing around with primes. So you'll see that each item and worry level is an array containing all the prime factors of the original number. Honestly, it's a bit of a mess because of the "+" operation. Additions don't play nice with prime factors. It also doesn't really seem necessary to find the smaller equivalent number in every case so I just did it for the addition operation where I forced to calculate the resulting number and thus could do the above switcharoo.
