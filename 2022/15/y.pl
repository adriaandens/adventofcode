use feature 'say';

my %rows = ();
my %beacons_per_row = ();
while(<>) {
	chomp;
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

		#push(@{$rows{$row_number}}, "$min<->$max");
		update_range($row_number, "$min<->$max");

		$row_number = $2 + $i; # We also need to go down
		#push(@{$rows{$row_number}}, "$min<->$max");
		update_range($row_number, "$min<->$max");
	}
}

foreach(keys(%rows)) {
	my %row = %{$rows{$_}};
	my @keys = keys(%row);
	if($_ >= 0 && $_ <= 4000000) {
		if(@keys == 2) {
			say "Row: $_ contains @keys";
			my @range1 = split /<->/, $keys[0];
			my @range2 = split /<->/, $keys[1];
			if($range1[1] < $range2[0]) {
				my $x_co = $range1[1] + 1;
				say "Found at: x=$x_co , y=$_";
			} else {
				my $x_co = $range2[1] + 1;
				say "Found at: x=$x_co , y=$_";
			}
		}
	}
}

sub update_range {
	my ($row_number, $new_range) = @_;
	$new_range =~ /(-?\d+)<->(-?\d+)/;
	my ($from, $to) = ($1, $2);
	# If we don't have a range yet, just add it as the range

	my $matched_ranges = 0;
	my @ranges = ();
	# If we do have one or more ranges, check whether
	foreach(keys(%{$rows{$row_number}})) {
		/(-?\d+)<->(-?\d+)/;
		my $from2 = $1; my $to2 = $2;

		# it's fully encompassed by an existing range -> no change
		if($from2 <= $from && $to <= $to2) { # Range 2 fully encompasses range 1
			#say "The new range: $new_range is already fully encompassed, nothing to do!";
			return; # Nothing to do!
		}

		if($from <= $from2 && $to >= $to2) { # We encompass the existing range fully
			delete $rows{$row_number}->{$_};
			next;
		}

		# It connects, for example the existing range stops at 2, this range start at 3
		if($to == $from2 - 1 || $from == $to2 + 1) {
			$matched_ranges++;
			push(@ranges, $_);
		} elsif($from < $from2 && $to >= $from2) { # there's a bit before
			$matched_ranges++;
			push(@ranges, $_);
		} elsif($to > $to2 && $from <= $to2) { # there's a bit behind
			$matched_ranges++;
			push(@ranges, $_);
		}
	}

	# Check counter value
	if($matched_ranges == 0) { # it's fully disjoint
		#say "The new range: $new_range is fully disjoint!";
		$rows{$row_number}->{$new_range} = 1;
	} elsif($matched_ranges == 2) {
		#say "The new range: $new_range connects 2 old ranges: @ranges";
		my $stretched_range;
		my @range1 = split /<->/, $ranges[0];
		my @range2 = split /<->/, $ranges[1];
		if($range1[1] < $range2[0]) {
			$stretched_range = $range1[0] . '<->' . $range2[1];
		} else {
			$stretched_range = $range2[0] . '<->' . $range1[1];
		}
		$rows{$row_number}->{$stretched_range} = 1;
		delete $rows{$row_number}->{$ranges[0]};
		delete $rows{$row_number}->{$ranges[1]};
	} elsif($matched_ranges == 1) {
		#say "The new range: $new_range extends an old range: @ranges";
		my @range = split /<->/, $ranges[0];
		if($to == $range[0] - 1) { # it connects at the front
			#say "\tit connects at the front";
			delete $rows{$row_number}->{$ranges[0]};
			$rows{$row_number}->{$from . '<->' . $range[1]} = 1;
		} elsif($from == $range[1] + 1) { # it connects at the end
			#say "\tit connects at the end";
			delete $rows{$row_number}->{$ranges[0]};
			$rows{$row_number}->{$range[0] . '<->' . $to} = 1;
		} elsif($from < $range[0] && $to >= $range[0]) { # there's a bit before
			#say "\tthere's at least a bit before";
			#$rows{$row_number}->{$from . '<->' . $range[1]} = 1;
			if($to <= $range[1]) {
				$rows{$row_number}->{$from . '<->' . $range[1]} = 1;
			} else {
				#say "\t\tNew range fully encompasses old range";
				$rows{$row_number}->{$from . '<->' . $to} = 1;
			}

			delete $rows{$row_number}->{$ranges[0]};
		} elsif($to > $range[1] && $from <= $range[1]) { # there's a bit behind
			#say "\tthere's at least a bit after";
			if($from >= $range[0]) {
				$rows{$row_number}->{$range[0] . '<->' . $to} = 1;
			} else {
				#say "\t\tNew range fully encompasses old range";
				$rows{$row_number}->{$from . '<->' . $to} = 1;
			}
			delete $rows{$row_number}->{$ranges[0]};
		} else {
			die "Weird 2\n";
		}

	} else {
		die "Weird 1\nnew range: $new_range, matched ranges: @ranges\n";
		# This means we have a big ass range that spans at least 2
		foreach(@ranges) {
			my @range = split /<->/, $_;
			if($from <= $range[0] && $to >= $range[1]) {
				say "\tDeleting $_\n";
				delete $rows{$row_number}->{$_};
			}
		}


	}
		# if 2: bridges two ranges that can be merged because of this new range
			# check counter of matching ranges
		# if 1: extends a range because of partial overlap (in the front or back)
			# It connects like existing range stops at 2, this range start at 3

	#my @keys = keys(%{$rows{$row_number}});
	#say "\t\tNew keys: @keys";
}

sub lookup {
	my $y_co = shift;
	my @row = @{$rows{$y_co}};
	
	my @consolidated_ranges = ();
	for(my $i = 0; $i < @row; $i++) {
		say "Range: " . $row[$i];
		$row[$i] =~ /(-?\d+)<->(-?\d+)/;
		my $from = $1; my $to = $2;
		

		my @unique_ranges = ();
		my $not_unique = 0;
		for(my $j = 0; $j < @row; $j++) {
			next if $i == $j; # Same range
			$row[$j] =~ /(-?\d+)<->(-?\d+)/;
			my $from2 = $1; my $to2 = $2;

			if($from2 <= $from && $to <= $to2) { # Range 2 fully encompasses range 1
				$not_unique = 1;
				last; # Don't add it to unique ranges.
			} elsif($from < $from2 && $to <= $to2) { # Range 1 has a part in front that is unique
				
			}
		}

	}

}

# Wikipedia: "the distance between two points is the sum of the absolute differences of their Cartesian coordinates"
sub calculate_manhattan {
	return abs($_[0] - $_[2]) + abs($_[1] - $_[3]);
}
