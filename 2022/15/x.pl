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

#foreach(keys(%rows)) {
#	say "Key: $_";
#}

say "Solution: " . lookup(10);
say "Solution: " . lookup(2000000);


sub lookup {
	my $y_co = shift;
	my @row = @{$rows{$y_co}};
	my %bips = ();

	for(my $i = 0; $i < @row; $i++) {
		$row[$i] =~ /(-?\d+)<->(-?\d+)/;
		my $from = $1; my $to = $2;
		for(my $j = $from; $j <= $to; $j++) {
			$bips{$j} = 1;
		}
	}

	# Don't count positions where we have a beacon.
	foreach(@{$beacons_per_row{$y_co}}) {
		my $x_co = $_;
		delete $bips{$x_co};
	}
	my @k = keys(%bips);
	say "@k";
	return scalar(keys(%bips));
	
	#my $unique_positions = 0;
	#for(my $i = 0; $i < @row; $i++) {
	#	say "Range: " . $row[$i];
	#	$row[$i] =~ /(-?\d+)<->(-?\d+)/;
	#	my $from = $1; my $to = $2;
	#	
	#	for(my $j = 0; $j < @row; $j++) {
	#		next if $i == $j; # Same range
	#		$row[$j] =~ /(-?\d+)<->(-?\d+)/;
	#		my $from2 = $1; my $to2 = $2;

	#		if($from2 <= $from && $to <= $to2) { # Range 2 fully encompasses range 1
	#			$unique_positions = 0;
	#		} elsif($from < $from2 && $to <= $to2) { # Range 1 has a part in front that is unique
	#		
	#		}
	#	}

	#}

}

# Wikipedia: "the distance between two points is the sum of the absolute differences of their Cartesian coordinates"
sub calculate_manhattan {
	return abs($_[0] - $_[2]) + abs($_[1] - $_[3]);
}
