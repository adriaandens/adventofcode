use Test::More;
use feature 'say';

run_tests();
$ok = done_testing();
#exit(0);


my @ordered_pairs = ();
my $pair = 1;
while((my $line1 = <>)) {
	chomp($line1); chomp(my $line2 = <>);
	say "Line 1: $line1";
	say "Line 2: $line2";
	eval('$left = ' . $line1 . ';$right = ' . $line2 . ';');
	if(compare($left, $right)) {
		say "Pair $pair is ordered!!\n";
		push(@ordered_pairs, $pair);
	} else {
		say "Pair $pair is unordered.\n";
	}

	# small code for later
	#push(@ordered_pairs, $pair) if compare($left, $right); # Recursive compare
	$line1 = <>; # Empty line
	$pair++;
}
say "@ordered_pairs";
map { $sum += $_ } @ordered_pairs;
say "Solution: $sum";

sub compare {
	my ($l, $r) = @_;
	my $is_ordered = 1;
	if(!ref($l) && !ref($r)) { # 2 integers
		say "Compare $l vs $r";
		if($r == '' || !defined($r)) { 
			$is_ordered = 0;
		}

		if($l > $r) {
			say "\tLeft side is bigger, this is not ordered!";
			$is_ordered = 0;
		} elsif($l == $r) {
			say "\tValues are the same, we need to check the next one!";
			$is_ordered = -1;
		} else {
			say "\tLeft side is smaller, this element is ordered.";
			$is_ordered = 1;
		}
	} elsif(ref($l) eq 'ARRAY' && ref($r) eq 'ARRAY') {
		return -1 if @{$l} == 0 && @{$r} == 0; # If they're both empty arrays [], [] we should return -1 (it'll never enter the for loop below)
		for(my $i = 0; $i < @{$l}; $i++) {
			if(@{$r} <= $i) { 
				say "We ran out of items on the right side\n";
				$is_ordered = 0;
				last;
			}
			my ($a, $b) = ($l->[$i], $r->[$i]);

			say "Comparing two items $a, $b";
			my $result = compare($a, $b);
			say "\tResult is $result";
			if($result == 0) {
				$is_ordered = 0;
				last;
			} elsif($result == 1) {
				$is_ordered = 1;
				last; # Left side was smaller so the list is in the right order
			} else { # they're the same
				$is_ordered = -1;
			}
		}
	
		# Edge case: If we run out of items on the left side but all the items that were compared so far were equal, we can also say that left is smaller!
		if($is_ordered == -1 && @{$r} > @{$l}) {
			return 1;
		}
	} elsif(ref($l) eq 'ARRAY') { # One is a list, one is a scalar
		return -1 if(!$r);
		$is_ordered = compare($l, [$r]);
	} elsif(ref($r) eq 'ARRAY') {
		$is_ordered = compare([$l], $r);
	} else {
		die "Weird stuff! Should never get here!\n";
	}

	return $is_ordered;
}

sub run_tests {
	my $a = 1;
	my $b = 2;

	ok(compare($a, $b), "Integer comparison A is smaller than B returns true");
	ok(compare($a, $a), "Integer comparison A == A returns true");
	ok(compare($b, $a) == 0, "Integer comparison A is bigger than B returns false");

	ok(compare([1], [2]), "Left array's first element is smaller");
	ok(compare([1, 2], [1, 3]), "Left array's second element is smaller");
	ok(compare([1], [1, 2]), "Left runs out first, this is ok");
	ok(compare([1], []) == 0, "Right runs out of items first, so it's not in order");

	ok(compare([1], [[2]]));
	ok(compare([[5]], 3) == 0);

	# Edge case: we need to stop after the first array comparison
	ok(compare([[1, 2, 3], [4, 5, 6]], [[1,2,3,4],[4,5,6]]));

	ok(compare([1, 2, 3], [1, 2, 3, 4]));
}

__END__
In Perl an array definition is:
my @array = (1, 2, 3);

But an array reference has square brackets:
$a = [1, 2, [3, 4]];
say $a->[1];

So we can just eval() that input and be done with it!


5904 <-- too high
5418 <-- too low
5418 <-- too low
5644 <-- ?
