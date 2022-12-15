use feature 'say';

my %rows = ();
my %beacons_per_row = ();
while(<>) {
	/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/;
	say "$1, $2, $3, $4: " . ($3+5) . " / " . ($3-5);
	my $distance = calculate_manhattan($1, $2, $3, $4);
	say "\tManhattan distance between sensor and beacon: $distance";

	push(@{$beacons_per_row{$4}}, $3);

	# We'll just update the rows with ranges that are covered
	for(my $i = 0; $i < $distance; $i++) {
		my $row_number = $2 - $i;
		my $min = $1 - ($distance - $i);
		my $max = $1 + ($distance - $i);
		push(@{$rows{$row_number}}, "$min<->$max");

		$row_number = $2 + $i; # We also need to go down
		push(@{$rows{$row_number}}, "$min<->$max");
	}
}

say "Solution: " . lookup(10);
say "Solution: " . lookup(2000000);


sub lookup {
	my $y_co = shift;
	my @row = @{$rows{$y_co}};
	my %bips = ();

	# For every position in our range, we set the "bit" of the x-co in the %bips hashmap. It'll result in all unique positions to be covered in %bips.
	for(my $i = 0; $i < @row; $i++) {
		$row[$i] =~ /(-?\d+)<->(-?\d+)/;
		my $from = $1; my $to = $2;
		for(my $j = $from; $j <= $to; $j++) {
			$bips{$j} = 1;
		}
	}

	# Don't count positions where we have a beacon.
	# Beacons are always inside a range because our ranges come from the manhattan distance between a sensor and a beacon. So there's no case where we have a beacon outside of our ranges. (Otherwise %bips might not contain the beacon bip.
	foreach(@{$beacons_per_row{$y_co}}) {
		my $x_co = $_;
		delete $bips{$x_co};
	}
	return scalar(keys(%bips));
}

# Wikipedia: "the distance between two points is the sum of the absolute differences of their Cartesian coordinates"
sub calculate_manhattan {
	return abs($_[0] - $_[2]) + abs($_[1] - $_[3]);
}
