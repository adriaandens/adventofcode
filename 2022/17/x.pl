use feature 'say';

my @blocks = ("####", ".#.\n###\n.#.", "..#\n..#\n###", "#\n#\n#\n#", "##\n##");
my @rows = ();
my @pattern = split //, <>;
pop @pattern; # Pop off the newline
my $amount_of_rocks = 2022;

my $i = 0; my $j = 0;
while($i < $amount_of_rocks) {
	my $vertical_position = height_of_highest_rock() + 3;
	my $horizontal_position = 2;
	my $block = create_block($blocks[$i % 5], $vertical_position);
	my @lines = @{$block->{lines}};
	say "Block $i - hor=$block->{horizontal}, vert=$block->{vertical}, lines=@lines";
	
	my $collision = 0;
	while(! $collision) {
		# Pushed by jet
		my $jet_push = $pattern[$j % scalar(@pattern)];
		say "Jet push $jet_push";
		if($jet_push eq '>') { # We go right
			# Can we move to the right or are we against a wall or other block?
			if(can_move_right($block)) {
				$block->{horizontal}++;
			}
		} else { # We go left
			# Can we move to the left or are we against a wall or other block?
			if(can_move_left($block)) {
				$block->{horizontal}--;
			}
		}

		# Falling down
		if(can_move_down($block)) {
			$block->{vertical}--;
		} else {
			map_block($block);
			$collision = 1;
		}

		$j++;
	}

	#print_tetris();
	$i++;
}
say "Solution: " . height_of_highest_rock();

sub print_tetris {
	foreach(reverse @rows) {
		print '|';
		my @a = @{$_};
		foreach(@{$_}) {
			print '.' if($_ ne '#');
			print '#' if($_ eq '#');
		}
		print "|\n";
	}
}


sub map_block {
	my $block = shift;
	say "Block end position - hor=$block->{horizontal}, vert=$block->{vertical}";
	my $i = 0;
	foreach(@{$block->{lines}}) {
		my @block_line = split //, $_;
		my $hor = $block->{horizontal};
		#foreach my $j (@block_line) {
		for(my $j = 0; $j < @block_line; $j++) {
			if($block_line[$j] eq '#') {
				$rows[$block->{vertical} + $i][$hor + $j] = '#';
			}
		}
		$i++;
	}
}

sub can_move_down {
	my $b = shift;
	my $can_move = 1;
	my $hor_pos = $b->{horizontal};
	return 0 if $b->{vertical} == 0;

	my $i = 0;
	foreach(@{$b->{lines}}) {
		my @line = @{$rows[$b->{vertical} - 1 + $i]}; # The line in the grid below
		my @block_line = split //, $_;
		for(my $j = 0; $j < @block_line; $j++) {
			if(($line[$hor_pos+$j] eq '#' && $block_line[$j] eq '#')) {
				$can_move = 0;
			}
		}

		$i++;
	}
	return $can_move;
}

sub can_move_right {
	my $b = shift;
	my $can_move = 1;
	my $hor_pos = $b->{horizontal};
	return 0 if $hor_pos + $b->{max_width} >= 7;

	my $i = 0;
	foreach(@{$b->{lines}}) {
		my @line = @{$rows[$b->{vertical} + $i]};
		my @block_line = split //, $_;
		for(my $j = 0; $j < @block_line; $j++) {
			if(($line[$hor_pos+$j+1] eq '#' && $block_line[$j] eq '#')) {
				$can_move = 0;
			}
		}
		$i++;
	}

	return $can_move;
}

sub can_move_left {
	my $b = shift;
	my $can_move = 1;
	my $hor_pos = $b->{horizontal};
	return 0 if $hor_pos <= 0; # Can't go beyond 0 horizontally

	my $i = 0;
	foreach(@{$b->{lines}}) {
		my @line = @{$rows[$b->{vertical} + $i]};
		my @block_line = split //, $_;
		for(my $j = 0; $j < @block_line; $j++) {
			if(($line[$hor_pos+$j-1] eq '#' && $block_line[$j] eq '#')) {
				$can_move = 0;
			}
		}
		$i++;
	}

	return $can_move;
}

sub height_of_highest_rock {
	my $i = 1;
	$max = 0;
	foreach my $r (@rows) {
		foreach(@{$r}) {
			$max = $i if($_ eq '#' && $i > $max);
		}
		$i++;
	}
	return $max;
}

sub create_block {
	my ($str, $vert) = @_;
	my @lines = reverse split /\n/, $str;
	my $max_width = 0;
	foreach(@lines) { $max_width = length if length > $max_width; }
	my %block = (
		"lines" => \@lines,
		"vertical" => $vert,
		"horizontal" => 2,
		"max_width" => $max_width
	);
	return \%block;
}

__END__

|.......| <-- $rows[3]
|.......| <-- $rows[2]
|.......| <-- $rows[1]
|.......| <-- $rows[0]
+-------+ 

1)
block = ####, then vert = 3 and hor = 2, at creation.
This will always be save since we start always 2 above the heighest rock

Fixed a problem where I wasn't checking enough, now I check each and every line instead for going down, the bottom line, for going left the leftmost column, ....
Case where this logic failed:
|...#...|
|..###..|
|...#...|
|....#..|
|....#..|
|....#..|
---------

If we only check the bottom line of the falling block, we find that we can drop 2 more rows whilst if we are checking all the lines, we'll notice we'll have to stop after dropping just 1 time.

Same problem for left and right:
