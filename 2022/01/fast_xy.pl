open(F, '<', '/home/adri/Unsorted/aoc_2022_day01_large_input.txt') or die 'Cannot find file';
while(<F>) {
	if(length == 1) {
		if($local_sum >= $max) {
			$max3 = $max2;
			$max2 = $max;
			$max = $local_sum;
		} elsif($local_sum >= $max2) {
			$max3 = $max2;
			$max2 = $local_sum;
		} elsif($local_sum >= $max3) {
			$max3 = $local_sum;
		}
		$local_sum = 0;
	} else {
		$local_sum += int($_);
	}
}
print $max . "\n";
print $max + $max2 + $max3 . "\n";

__END__
Background: https://gathering.tweakers.net/forum/list_message/73652172#73652172 provides a 493MB input file to test our implementations on.

In the initial implementation `sort {}` is used, which is at best O(nlogn) if my memory of algorithms is correct, so that would make it way too slow. So we change our implementation to just keep track of the top 3 values instead (O(n)).

First implementation of the O(n) scan:
$ time perl fast_xy.pl < ~/Unsorted/aoc_2022_day01_large_input.txt
184028272
549010145

real	0m39.708s
user	0m35.174s
sys	0m4.528s

Changing the regex with a dumb length check (the empty line '\n' has length 1):
$ time perl fast_xy.pl < ~/Unsorted/aoc_2022_day01_large_input.txt 
184028272
549010145

real	0m34.893s
user	0m29.955s
sys	0m4.936s
-> Saves us 5 seconds

Changing the `map {} <>` to a `while(<>) {}` gives also a signifcant speed up:
$ time perl fast_xy.pl < ~/Unsorted/aoc_2022_day01_large_input.txt 
184028272
549010145

real	0m12.601s
user	0m12.537s
sys	0m0.056s
-> Shaves of an impressive 22 seconds

Taking over IO and `open()`ing the file inside Perl instead of passing it via the shell.
$ time perl fast_xy.pl
184028272
549010145

real	0m12.423s
user	0m12.366s
sys	0m0.056s
-> No real significant change.

Doing an explicit cast of `$_` to `int()`.
$ time perl fast_xy.pl
184028272
549010145

real	0m12.200s
user	0m12.158s
sys	0m0.041s
-> No real significant change.

Managing the IO and slurping the file into the filehandle in one go to then do the split ourselves makes it slower:
$ time perl fast_xy.pl
184028272
549010145

real	0m17.971s
user	0m15.834s
sys	0m2.136s
-> 6s slower when doing line splits ourselves :'(
