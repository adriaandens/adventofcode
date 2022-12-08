my @rows = ();
while(<>) {
	chomp;
	push(@{$rows[$.-1]}, $_) foreach split //;
}

my $visible = scalar(@rows)*2 + (scalar(@{$rows[0]})-2)*2;
for($i = 1; $i < @rows-1; $i++) {
	for($j = 1; $j < @{$rows[$i]}-1; $j++) {
		$above = $i - 1;
		my $visible_from_above = 1;
		while($above >= 0) {
			$visible_from_above = 0 if $rows[$above--][$j] >= $rows[$i][$j];
		}

		$below = $i + 1;
		my $visible_from_below = 1;
		while($below < @rows) {
			$visible_from_below = 0 if $rows[$below++][$j] >= $rows[$i][$j];
		}
		
		$left = $j - 1;
		my $visible_from_left = 1;
		while($left >= 0) {
			$visible_from_left = 0 if $rows[$i][$left--] >= $rows[$i][$j];
		}
		
		$right = $j + 1;
		my $visible_from_right = 1;
		while($right < @{$rows[$i]}) {
			$visible_from_right = 0 if $rows[$i][$right++] >= $rows[$i][$j];
		}

		$visible++ if $visible_from_left || $visible_from_right || $visible_from_above || $visible_from_below;
	}
}
print "Trees visible: $visible\n";
