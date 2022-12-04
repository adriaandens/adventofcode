map {
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
		$local_sum += $_;
	}
} <>;
print $max . "\n";
print $max + $max2 + $max3 . "\n";

__END__
Background: https://gathering.tweakers.net/forum/list_message/73652172#73652172 provides a 493MB input file to test our implementations on.

In the initial implementation `sort {}` is used, which is at best O(nlogn) if my memory of algorithms is correct, so that would make it way too slow. So we change our implementation to just keep track of the top 3 values instead.

First implementation of the O(n) scan:
$ time perl fast_xy.pl < ~/Unsorted/aoc_2022_day01_large_input.txt
184028272
549010145

real	0m39.708s
user	0m35.174s
sys		0m4.528s

Changing the regex with a dumb length check (the empty line '\n' has length 1):
$ time perl fast_xy.pl < ~/Unsorted/aoc_2022_day01_large_input.txt 
184028272
549010145

real	0m34.893s
user	0m29.955s
sys	0m4.936s
-> Saves us 5 seconds
