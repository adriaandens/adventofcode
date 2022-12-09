
my @rows = ();
my $i = 0; my $j = 0; # We start at (0, 0) because we have no idea where we're gonna go and how far...
my $k = 0; my $l = 0; # Position head
$rows[$i][$j] = 's';

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
		my $missing_rows = $amount - $k; 
		print "We are missing $missing_rows rows above us\n";
		if($missing_rows > 0) {
			while($missing_rows--) {
				# We need to add rows before us because there are not enough
				my @new_row = ();
				unshift(@rows, \@new_row);
				$k++; # Our current position index (k, l) has changed since we have added a new row on top
				$i++;
			}
		}

		while($amount--) {
			$k--;
			move_tail();
		}
	}

	if($direction eq 'L') {
		print "== L $amount ==\n";
		my $missing_columns = $amount - ($l);
		if($missing_columns > 0) {
			print "\tWe need to add some columns before our grid\n";
			foreach my $r (@rows) {
				foreach(0..$missing_columns) {
					unshift(@{$r}, ' ');
				}
			}
			$l+=$missing_columns;
			$j+=$missing_columns;
		}

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
foreach my $r (@rows) {
	#print "@{$r}" . "\n";
	if(@{$r}) {
		foreach(@{$r}) {
			$count++ if $_ eq '#';
		}
	} else {
		print "not an array, wut\n";
	}
}
print "Total: $count\n";

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
	$rows[$i][$j] = '#';
}

__END__
Failed solution.
I was creating a 2D field that would auto-extend and mark visited positions with '#' but that proved difficult. It's still a valid way to solve small inputs and it'll print a nice 2D field at the end (handy for debugging) but it's not trivial to implement.
