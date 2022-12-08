my @rows = ();
while(<>) {
	chomp;
	foreach(split //) {
		push(@{$rows[$.-1]}, $_);
	}
}

print "The grid is: " . scalar(@rows) . " rows long\n";
print "The grid is: " . scalar(@{$rows[0]}) . " columns long\n";

my $top_scenic = 0;
for($i = 1; $i < @rows-1; $i++) {
	for($j = 1; $j < @{$rows[$i]}-1; $j++) {
		print "Checking row = $i, column = $j - value: " . $rows[$i][$j] . "\n";

		# check trees above
		$above = $i - 1;
		my $visible_from_above = 0;
		while($above >= 0) {
			$visible_from_above++;
			if($rows[$i][$j] <= $rows[$above][$j]) {
				last; # We can't see any tree further than this
			}
			$above--;
		}
		print "\tVisible from above: $visible_from_above\n";

		# check trees below
		$below = $i + 1;
		my $visible_from_below = 0;
		while($below < @rows) {
			$visible_from_below++;
			if($rows[$i][$j] <= $rows[$below][$j]) {
				last;
			}
			$below++;
		}
		print "\tVisible from below: $visible_from_below\n";
		
		# check trees left
		$left = $j - 1;
		my $visible_from_left = 0;
		while($left >= 0) {
			$visible_from_left++;
			if($rows[$i][$left] >= $rows[$i][$j]) {
				last;
			}
			$left--;
		}
		print "\tVisible from left: $visible_from_left\n";
		
		# check trees right
		$right = $j + 1;
		my $visible_from_right = 0;
		while($right < @{$rows[$i]}) {
			$visible_from_right++;
			if($rows[$i][$right] >= $rows[$i][$j]) {
				last;
			}
			$right++;
		}
		print "\tVisible from right: $visible_from_right\n";

		my $scenic_score = $visible_from_above * $visible_from_below * $visible_from_left * $visible_from_right;
		if($scenic_score > $top_scenic) {
			$top_scenic = $scenic_score;
		}

	}
}
print "Top scenic: $top_scenic\n";
