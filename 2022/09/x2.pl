
my $i = 0; my $j = 0; # We start at (0, 0) because we have no idea where we're gonna go and how far...
my $k = 0; my $l = 0; # Position head
my @positions = (); # keep track of positions visited.

while(<>) {
	chomp;
	my ($direction, $amount) = /(\w) (\d+)/;
	if($direction eq 'R') {
		print "== R $amount ==\n";
		while($amount--) {
			$l++; # Head moves right.
			move_tail();
		}
	}

	if($direction eq 'U') {
		print "== U $amount ==\n";
		while($amount--) {
			$k--;
			move_tail();
		}
	}

	if($direction eq 'L') {
		print "== L $amount ==\n";
		while($amount--) {
			$l--;
			move_tail();
		}
	}

	if($direction eq 'D') {
		print "== D $amount ==\n";
		while($amount--) {
			$k++;
			move_tail();
		}
	}
}

my $count = 0;
my %uniq = ();
print "Number of positions: @positions\n";
foreach(@positions) {
	$uniq{$_} = 1;
}
print "Total: " . keys(%uniq) . "\n";

sub move_tail {
	print "Position head: ($k, $l) ; Position tail: ($i, $j)\n";
	if($k == $i && $l == $j) {
		print "\tHead and tail are in the same position\n";
		# we don't need to move the tail
	} elsif($k == $i && abs($j - $l) == 1) {
		print "\tHead is just one step away horizontally\n";
		# we don't need to move the tail
	} elsif($k == $i && $l - $j > 1) {
		print "\tHead is two steps away horizontally\n";
		$j++;
	} elsif($k == $i && $j - $l > 1) {
		print "\tHead is two steps away horizontally\n";
		$j--;
	} elsif($l == $j && abs($k - $i) == 1) {
		print "\tHead is one step away vertically\n";
		# we don't need to move the tail
	} elsif($l == $j && $k - $i > 1) {
		print "\tHead is two step away vertically\n";
		$i++;
	} elsif($l == $j && $i - $k > 1) {
		print "\tHead is two step away vertically\n";
		$i--;
	} else {
		print "\tHead is diagonally from tail\n";
		if(abs($k - $i) == 1 && abs($l - $j) == 1) {
			print "\tHead is diagonally one away from tail\n";
			# nothing to do yet
		} else {
			if(($k == $i - 1 && $l == $j - 2) || ($k == $i - 2 && $l == $j - 1)) {
				# do (i-1,j-1)
				$i--; $j--;
			} elsif(($k == $i - 1 && $l == $j + 2) || ($k == $i - 2 && $l == $j + 1)) {
				# do i-1, j+1
				$i--; $j++;
			} elsif(($k == $i + 1 && $l == $j - 2) || ($k == $i + 2 && $l == $j - 1)) {
				# do i+1, j-1
				$i++; $j--;
			} elsif(($k == $i + 1 && $l == $j + 2) || ($k == $i + 2 && $l == $j + 1)) {
				# do i+1, j+1
				$i++; $j++;
			} else {
				print "\tWEIRD\n";
			}
		}
	}
	print "\t\tNew position tail: ($i, $j)\n";
	push(@positions, "$i-$j");
}

__END__
Instead of creating a field and auto-extending we just allow a full x and y-axis of coordinates and just let it go in the minus. We also ditch the 2D field and just remember the current position of the HEAD ($k, $l), the current position of the TAIL ($i, $j) and all the positions that TAIL passes (@positions). After going through the steps we make a hashmap of the positions to extract the unique positions. Faster would be to immediately store it in a hashmap, of course.

The logic for diagonal moving is best visualized in a grid:

#######
# . . #
#.H H.#
#  T  #
#.H H.#
# . . #
#######
Where H is the position of the Head and T the position of the tail at t=0.
The dots indicate the situations that we would hit that would render a move of the tail if H moves too far diagonally. If H moves to one of the dots, T needs to take the place of H to stay connected.
