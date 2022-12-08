my @rows = ();
while(<>) {
	chomp;
	foreach(split //) {
		push(@{$rows[$.-1]}, $_);
	}
}

print "The grid is: " . scalar(@rows) . " rows long\n";
print "The grid is: " . scalar(@{$rows[0]}) . " columns long\n";
my $trees_on_the_edge = scalar(@rows)*2 + (scalar(@{$rows[0]})-2)*2;
print "There are $trees_on_the_edge trees on the edge\n";

my $visible = $trees_on_the_edge;
for($i = 1; $i < @rows-1; $i++) {
	for($j = 1; $j < @{$rows[$i]}-1; $j++) {
		print "Checking row = $i, column = $j - value: " . $rows[$i][$j] . "\n";

		# check trees above
		$above = $i - 1;
		my $visible_from_above = 1;
		while($above >= 0) {
			if($rows[$above][$j] >= $rows[$i][$j]) {
				$visible_from_above = 0; # we found a tree with equal or higher height
			}
			$above--;
		}
		print "\tVisible from above: $visible_from_above\n";

		# check trees below
		$below = $i + 1;
		my $visible_from_below = 1;
		while($below < @rows) {
			if($rows[$below][$j] >= $rows[$i][$j]) {
				$visible_from_below = 0; # we found a tree with equal or higher height
			}
			$below++;
		}
		print "\tVisible from below: $visible_from_below\n";
		
		# check trees left
		$left = $j - 1;
		my $visible_from_left = 1;
		while($left >= 0) {
			if($rows[$i][$left] >= $rows[$i][$j]) {
				$visible_from_left = 0; # we found a tree with equal or higher height
			}
			$left--;
		}
		print "\tVisible from left: $visible_from_below\n";
		
		# check trees right
		$right = $j + 1;
		my $visible_from_right = 1;
		while($right < @{$rows[$i]}) {
			if($rows[$i][$right] >= $rows[$i][$j]) {
				$visible_from_right = 0; # we found a tree with equal or higher height
			}
			$right++;
		}
		print "\tVisible from right: $visible_from_below\n";


		if($visible_from_left || $visible_from_right || $visible_from_above || $visible_from_below) {
			$visible++;
		}
	}
}
print "Trees visible: $visible\n";
