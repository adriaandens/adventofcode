use feature 'say';
use Test::More;

my %positions = ();
my @elfs = ();

run_parse_tests();
run_func_tests();
done_testing();

my $input = <<HERE;
..............
..............
.......#......
.....###.#....
...#...#.#....
....#...##....
...#.###......
...##.#.##....
....#..#......
..............
..............
..............
HERE
x($input);
foreach(@elfs) {
	say $_->{x} . ", " . $_->{y};
}
my $rectangle = rectangle_size();
say "Solution: " . ($rectangle - scalar(@elfs));

open(F, '<', 'input.txt') or die "bluh";
local $/ = undef;
$input = <F>;
x($input);
foreach(@elfs) {
	say $_->{x} . ", " . $_->{y};
}
$rectangle = rectangle_size();
say "Solution: " . ($rectangle - scalar(@elfs));

sub rectangle_size {
	my ($lowest_y, $highest_y, $lowest_x, $highest_x) = (100000, 0, 10000, 0);
	foreach(@elfs) {
		$highest_x = $_->{x} if $_->{x} > $highest_x;
		$lowest_x = $_->{x} if $_->{x} < $lowest_x;
		$highest_y = $_->{y} if $_->{y} > $highest_y;
		$lowest_y = $_->{y} if $_->{y} < $lowest_y;
	}
	say "Lowest x: $lowest_x, Highest x: $highest_x, Lowest y: $lowest_y, Highest y: $highest_y";
	return ($highest_x - $lowest_x + 1) * ($highest_y - $lowest_y + 1);
}

sub x {
	my $input = shift;
	@elfs = ();
	%positions = ();

	parse_input($input);
	my $has_moved = 1;
	my $round = 0;
	while($has_moved) {
		# Consider positions
		my %considerations = ();
		foreach(@elfs) {
			my $considered = consider_position($_, $round);
			$_->{considered_position} = $considered;
			if($considered) {
				$considerations{$considered}++;
			}
		}

		# Elfs that took a unique position can move
		my $moved_elfs = 0;
		foreach(@elfs) {
			if($_->{considered_position} && $considerations{$_->{considered_position}} == 1) {
				update_position($_);
				$moved_elfs++;
			}
			$_->{considered_position} = 0;
		}

		# Update has_moved
		$has_moved = 0 if $moved_elfs == 0;
		$round++;
		last if $round >= 10;
	}
}

sub update_position {
	my $elf = shift;
	$elf->{considered_position} =~ /(-?\d+)#(-?\d+)/;

	my $old_position = $elf->{x} . "#" . $elf->{y};
	delete $positions{$old_position};

	$elf->{x} = $1;
	$elf->{y} = $2;
	my $new_position = $elf->{x} . "#" . $elf->{y};
	$positions{$new_position} = 1;

}

sub consider_position {
	my $elf = shift;
	my $round = shift;

	# we don't move if there's no other elf around us
	my $nw = ($elf->{x} - 1) . "#" . ($elf->{y} - 1);
	my $n = $elf->{x} . "#" . ($elf->{y} - 1);
	my $ne = ($elf->{x} + 1) . "#" . ($elf->{y} - 1);
	my $sw = ($elf->{x} - 1) . "#" . ($elf->{y} + 1);
	my $s = $elf->{x} . "#" . ($elf->{y} + 1);
	my $se = ($elf->{x} + 1) . "#" . ($elf->{y} + 1);
	my $w = ($elf->{x} - 1) . "#" . $elf->{y};
	my $e = ($elf->{x} + 1) . "#" . $elf->{y};
	if(!$positions{$nw} && !$positions{$n} && !$positions{$ne} && !$positions{$sw} && !$positions{$s} && !$positions{$se} && !$positions{$w} && !$positions{$e}) {
		return 0; # We good, no need to move.
	}


	my @rounds = ("north", "south", "west", "east");
	while($round--) {
		my $v = shift @rounds;
		push(@rounds, $v);
	}

	foreach(@rounds) {
		if($_ eq "north") {
			my $nw = ($elf->{x} - 1) . "#" . ($elf->{y} - 1);
			my $n = $elf->{x} . "#" . ($elf->{y} - 1);
			my $ne = ($elf->{x} + 1) . "#" . ($elf->{y} - 1);

			if($positions{$nw} || $positions{$n} || $positions{$ne}) {
				say "there's some elf above us";
			} else {
				# We can move north.
				return $elf->{x} . "#" . ($elf->{y} - 1);
			}
		} elsif($_ eq "south") {
			my $sw = ($elf->{x} - 1) . "#" . ($elf->{y} + 1);
			my $s = $elf->{x} . "#" . ($elf->{y} + 1);
			my $se = ($elf->{x} + 1) . "#" . ($elf->{y} + 1);

			if($positions{$sw} || $positions{$s} || $positions{$se}) {
				say "there's some elf below us";
			} else {
				# We can move south.
				return $elf->{x} . "#" . ($elf->{y} + 1);
			}
		} elsif($_ eq "west") {
			my $nw = ($elf->{x} - 1) . "#" . ($elf->{y} - 1);
			my $w = ($elf->{x} - 1) . "#" . $elf->{y};
			my $sw = ($elf->{x} - 1) . "#" . ($elf->{y} + 1);

			if($positions{$sw} || $positions{$w} || $positions{$nw}) {
				say "there's some elf left of us";
			} else {
				# We can move west.
				return ($elf->{x} - 1) . "#" . $elf->{y};
			}
		} elsif($_ eq "east") {
			my $ne = ($elf->{x} + 1) . "#" . ($elf->{y} - 1);
			my $e = ($elf->{x} + 1) . "#" . $elf->{y};
			my $se = ($elf->{x} + 1) . "#" . ($elf->{y} + 1);

			if($positions{$se} || $positions{$e} || $positions{$ne}) {
				say "there's some elf right of us";
			} else {
				# We can move east.
				return ($elf->{x} + 1) . "#" . $elf->{y};
			}
		}
	}
	# we don't move
	my $pos = $elf->{x} . "#" . $elf{y};
	return 0;
}

sub parse_input {
	my $input = shift;
	my @lines = split /\n/, $input;
	for(my $i = 0; $i < @lines; $i++) {
		my @chars = split //, $lines[$i];
		for(my $j = 0; $j < @chars; $j++) {
			if($chars[$j] eq '#') {
				push(@elfs, create_elf($i, $j));
			}
		}
	}
}

sub create_elf {
	say "Creating elf with position (" . $_[1] . ", " . $_[0] . ")";
	my %elf = (
		"x" => $_[1], # The col is the x-value
		"y" => $_[0] # The row is the y-value
	);
	my $encoded = $_[1] . "#" . $_[0];
	$positions{$encoded} = 1;
	return \%elf;
}


sub run_func_tests {
	my $input = <<HERE;
....
.#..
....
HERE

	x($input);
	my $first_elf = $elfs[0];
	ok($first_elf->{x} == 1 && $first_elf->{y} == 1, "Elf did not move because all squares are free");

	$input = <<HERE;
.#..
.#..
....
HERE
	x($input);
	ok($elfs[0]->{x} == 1 && $elfs[0]->{y} == -1, "Top elf moved to (1, -1)");
	ok($elfs[1]->{x} == 1 && $elfs[1]->{y} == 2, "Bottom elf moved to (1, 2)");
}

sub run_parse_tests {
	my $input = <<HERE;
...###...
###...###
....#....
HERE

	x($input);
	ok(@elfs == 10, "Should find 10 Elfs");
	ok($positions{"3#0"} == 1, "Found elf at x-co (column) 3 and y-co 0 (row 0)");
	ok($positions{"4#0"} == 1, "Found elf at x-co (column) 4 and y-co 0 (row 0)");
	ok($positions{"6#1"} == 1, "Found elf at x-co (column) 6 and y-co 0 (row 0)");
}

__END__
Left top is (0, 0), bottom right is (8, 2)
...###... 
###...###
....#....
