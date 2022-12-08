my @rows = ();
while(<>) {
	chomp;
	push(@{$rows[$.-1]}, $_) foreach split //;
}

my $top_scenic = 0;
for($i = 1; $i < @rows-1; $i++) {
	for($j = 1; $j < @{$rows[$i]}-1; $j++) {
		$above = $i - 1;
		my $visible_from_above = 0;
		while($above >= 0) {
			$visible_from_above++;
			last if $rows[$i][$j] <= $rows[$above--][$j];
		}

		$below = $i + 1;
		my $visible_from_below = 0;
		while($below < @rows) {
			$visible_from_below++;
			last if $rows[$i][$j] <= $rows[$below++][$j];
		}
		
		$left = $j - 1;
		my $visible_from_left = 0;
		while($left >= 0) {
			$visible_from_left++;
			last if $rows[$i][$left--] >= $rows[$i][$j];
		}
		
		$right = $j + 1;
		my $visible_from_right = 0;
		while($right < @{$rows[$i]}) {
			$visible_from_right++;
			last if $rows[$i][$right++] >= $rows[$i][$j];
		}

		my $scenic_score = $visible_from_above * $visible_from_below * $visible_from_left * $visible_from_right;
		$top_scenic = $scenic_score if $scenic_score > $top_scenic;

	}
}
print "Top scenic: $top_scenic\n";
