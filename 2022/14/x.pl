use feature 'say';

# TODO: For nicer drawing, keep track of left most item and right most item such that we only print where rocks are.
my $leftmost_rock = 500;
my $rightmost_rock = 500;
my $lowest_rock = 0;
my @map = ();
while(<>) {
	chomp;
	my @parts = split / -> /;
	say "@parts";
	draw_paths(@parts);
}
draw_map();
my $falls_down_forever = 0;
my $sand_units = 0;
while(!$falls_down_forever) {
	$sand_units++;
	$falls_down_forever = 1 if pour_sand(500, 0);
}
say "Solution: " . ($sand_units - 1);

# Returns 1 if it falls into the void, otherwise 0
sub pour_sand {
	my ($c, $r) = @_;
	say "Sand at row $r and col $c";
	if($r > $lowest_rock || $c < $leftmost_rock || $c > $rightmost_rock) {
		say "\tWe're into the abyss!!!";
		return 1;
	}

	# Start falling
	if($map[$r+1][$c] ne 'o' && $map[$r+1][$c] ne '#') {
		say "\tThere is nothing below is, move down";
		return pour_sand($c, $r+1);
	} elsif($map[$r+1][$c-1] ne 'o' && $map[$r+1][$c-1] ne '#') {
		say "\tThere was something below us, but nothing below on the left";
		return pour_sand($c-1, $r+1);
	} elsif($map[$r+1][$c+1] ne 'o' && $map[$r+1][$c+1] ne '#') {
		say "\tThere was something below us and on the left so go right";
		return pour_sand($c+1, $r+1);
	} else {
		say "\tThere is something below, left, right of us so we just put it here";
		$map[$r][$c] = 'o';
		draw_map();
	}
	
	return 0;
}

sub draw_map {
	say "Draw the map!";
	say "Leftmost is $leftmost_rock";
	say "Rightmost is $rightmost_rock";
	foreach my $row (@map) {
		#if(!@{$row}) {
			for(my $i = $leftmost_rock; $i <= $rightmost_rock; $i++) {
				#print ".";
				print '.' if($row->[$i] ne '#' && $row->[$i] ne 'o');
				print '#' if($row->[$i] eq '#');
				print 'o' if($row->[$i] eq 'o');
			}
			print "\n";
			next;
		#}
		for(my $i = 0; $i < @{$row}; $i++) {
			if($i >= $leftmost_rock && $i <= $rightmost_rock) {
				print '.' if($row->[$i] ne '#' && $row->[$i] ne 'o');
				print '#' if($row->[$i] eq '#');
				print 'o' if($row->[$i] eq 'o');
			}
		}
		print "\n";
	}
	say "Stopped drawing";
}

# Updates the @map
sub draw_paths {
	for(my $i = 0; $i < @_ - 1; $i++) {
		my @part1 = split /,/, $_[$i];
		my @part2 = split /,/, $_[$i+1];
		update_limits(@part1);
		update_limits(@part2);
		draw_vertical(\@part1, \@part2) if $part1[0] == $part2[0];
		draw_horizontal(\@part1, \@part2) if $part1[0] != $part2[0];
	}
}

sub draw_horizontal {
	my ($a, $b) = @_;
	say "Draw horizontal line";
	if($a->[0] < $b->[0]) {
		foreach(my $i = $a->[0]; $i <= $b->[0]; $i++) {
			say "\tmap[$a->[1]][$i] (i is $i)";
			$map[$a->[1]][$i] = '#';
		}
	} else {
		foreach(my $i = $a->[0]; $i >= $b->[0]; $i--) {
			say "\tmap[$a->[1]][$i] (i is $i)";
			$map[$a->[1]][$i] = '#';
		}
	}
}

sub draw_vertical {
	my ($a, $b) = @_;
	say "Draw vertical line";

	if($a->[1] > $b->[1]) {
		foreach(my $i = $b->[1]; $i <= $a->[1]; $i++) {
			say "\tmap[$i][$a->[0]]";
			$map[$i][$a->[0]] = '#';
		}
	} else {	
		foreach(my $i = $a->[1]; $i <= $b->[1]; $i++) {
			say "\tmap[$i][$a->[0]]";
			$map[$i][$a->[0]] = '#';
		}
	}
}

sub update_limits {
	my ($x, $y) = @_;
	$lowest_rock = $y if($y > $lowest_rock);
	$leftmost_rock = $x if($x < $leftmost_rock);
	$rightmost_rock = $x if($x > $rightmost_rock);
}

__END__
733 <- answer too low
