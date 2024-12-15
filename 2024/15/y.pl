use v5.36;

my @map = ();
my @steps = ();
my $bool = 0;
my $width = 0;
my $height = 0;
while(<DATA>) {
	chomp;
	$bool = 1 if m/^\s*$/;
	if(!$bool) {
		my @row = split //;
		my @wide_row = ();
		foreach(@row) {
			if($_ eq '@') {
				push @wide_row, '@', '.';
			} elsif($_ eq '.') {
				push @wide_row, '.', '.';
			} elsif($_ eq 'O') {
				push @wide_row, '[', ']';
			} elsif($_ eq '#') {
				push @wide_row, '#', '#';
			} else { die "weeeeird"; }
		}
		$width = @wide_row;
		$height++;
		push @map, \@wide_row;
	} else {
		push @steps, split //;
	}
}
say "Width is $width and Height is $height";
say "Steps: @steps";

# current row, current column
my ($cr, $cc) = find_robot();
say "Robot loc: ($cr,$cc)";

say "Initial map:";
print_map(' ');
foreach my $step (@steps) {
	take_step($cr, $cc, $step, 'robot');
	$map[$cr][$cc] = '@';
	print_map($step);
}

#my $gps = 0;
#for(my $i = 0; $i < $height; $i++) {
#	for(my $j = 0; $j < $width; $j++) {
#		$gps += 100 * $i + $j if $map[$i][$j] eq 'O';
#	}
#}
#say "GPS: $gps";


sub print_map {
	say 'Move: ' . $_[0];
	foreach my $r (@map) { say @{$r} }
	say ' ';
}

sub take_step {
	my ($r, $c, $step, $type) = @_;
	if($step eq '^') {
		$map[$r][$c] = '.' if huh($r - 1, $c, -1, 0, $step, $type); # if returning 1, the original position is nulled
	} elsif($step eq '>') {
		$map[$r][$c] = '.' if huh($r , $c + 1, 0, 1, $step, $type);
	} elsif($step eq 'v') {
		$map[$r][$c] = '.' if huh($r + 1, $c, 1, 0, $step, $type);
	} elsif($step eq '<') {
		$map[$r][$c] = '.' if huh($r, $c - 1, 0, -1, $step, $type);
	} else {
		die "weird";
	}
}

sub huh {
	my ($r, $c, $rx, $cx, $step, $type) = @_;
	if($map[$r][$c] eq '.' && $type eq 'robot') { # we can move to it
		$cr = $r;
		$cc = $c;
		return 1; # tell caller, we updated so they can '.' the OG location
	#} elsif($map[$r][$c] eq '.' && $type eq 'box') {
		## TODO: no longer true for O
		#$map[$r][$c] = 'O'; # move the box
		#return 1;
	} elsif($map[$r][$c] eq '#') { # we CANNOT move, this is a null operation
		# do nothing
		return 0;
	} elsif($map[$r][$c] eq '[') { # There's a box... so we can only move if the box can move
		my $box_moved = move_box($r+$rx, $c+$cx,$c+$cx+1, $rx, $cx, $step);
		if($box_moved && $type eq 'robot') {
			$cr = $r; $cc = $c;
		#} elsif($box_moved && $type eq 'box') {
		#	$map[$r][$c] = 'O';
		}
		return $box_moved;
	} elsif($map[$r][$c] eq ']') {
		my $box_moved = move_box($r+$rx, $c+$cx, $c+$cx-1, $rx, $cx, $step);
		if($box_moved && $type eq 'robot') {
			$cr = $r; $cc = $c;
		}
		return $box_moved;
	}
}

sub move_box {
	my ($r, $c, $c2, $rx, $cx, $step) = @_;
	if($map[$r][$c] eq '.' && $map[$r][$c2] eq '.') { # we can move the box
		$map[$r][$c] = '[';
		$map[$r][$c2] = ']';
		return 1;
	} elsif($map[$r][$c] eq '#' || $map[$r][$c2] eq '#') { # there's a wall
		return 0; # cannot move box
	} elsif($map[$r][$c] eq '[' || $map[$r][$c] eq ']' || $map[$r][$c2] eq '[' || $map[$r][$c2] eq ']') { # another box is in the way, can only move if that one moves
		my $box_moved = move_box($r+$rx, $c+$cx, $c2+$cx, $rx, $cx, $step);
		if($box_moved) {
			$map[$r][$c] = '['; $map[$r][$c2] = ']'; # TODO: not sure if holds if ']'
			
		}
		return $box_moved;
	}
}

sub find_robot {
	for(my $i = 0; $i < $height; $i++) {
		for(my $j = 0; $j < $width; $j++) {
			return ($i, $j) if $map[$i][$j] eq '@';
		}
	}
	return (-1, -1);
}

__DATA__
#######
#...#.#
#.....#
#..OO@#
#..O..#
#.....#
#######

<vv<<^^<<^^
