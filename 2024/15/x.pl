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
		$width = @row;
		$height++;
		push @map, \@row;
	} else {
		push @steps, split //;
	}
}
say "Width is $width and Height is $height";
say "Steps: @steps";

# current row, current column
my ($cr, $cc) = find_robot();
say "Robot loc: ($cr,$cc)";

foreach my $step (@steps) {
	take_step($cr, $cc, $step, 'robot');
	$map[$cr][$cc] = '@';
	print_map($step);
}

my $gps = 0;
for(my $i = 0; $i < $height; $i++) {
	for(my $j = 0; $j < $width; $j++) {
		$gps += 100 * $i + $j if $map[$i][$j] eq 'O';
	}
}
say "GPS: $gps";


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
	} elsif($map[$r][$c] eq '.' && $type eq 'box') {
		$map[$r][$c] = 'O'; # move the box
		return 1;
	} elsif($map[$r][$c] eq '#') { # we CANNOT move, this is a null operation
		# do nothing
		return 0;
	} elsif($map[$r][$c] eq 'O') { # There's a box... so we can only move if the box can move
		my $box_moved = huh($r+$rx, $c+$cx, $rx, $cx, $step, 'box');
		if($box_moved && $type eq 'robot') {
			$cr = $r; $cc = $c;
		} elsif($box_moved && $type eq 'box') {
			$map[$r][$c] = 'O';
		}
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
##################################################
#..#..OOO...O.OO..#....O.#.....O.##.........O....#
##..OO.OO.O..##...O....O.O#.O..O.#....O..O#...OOO#
#O..O.O....#....O.O...O.....#.#.O....#OO##.O.O.O.#
#O.O...O.OO.O.#OO...O...O..O.#OO.O..O....OO...OOO#
#O.#.OO.OO.O..O...OOO..#.O.O#O.#......#O...#.....#
#...#O...O.O.......O.OO...O....O..OO.O....O.OO..O#
#O#.O.OOO...O#O.........OO...OOO...#.......#..#..#
##.O......O..O...O.#........O...O..O......OO.OOOO#
#...O..O........O..O.O.O...............O...#.O.#.#
#O..OO.......O....O...#.O.O........O#.OO.O...O...#
#....OOO....O.......OO..OO.O...O..OO..OO..O..O.O.#
#OO.O....OOO.O.O....#.O..O.....O..#.O....O..O..O.#
#.....O...OOO.O....O..OO.OOO..#O#O...OO..O#.O.O.O#
#..........O...O......OO.O..OO.O.O...OO.O.#....O.#
#.O..O.....O.O.O.#OO.O...O....O.O..OOOO.O......O##
#O.O...#..#..#......#O.#....#..O#O.O..O.....O.O#O#
#O.OO.O...O..#...O.#......O..O..O#....OOO.O.OO...#
#O....#.OOO..O...O..#.O..O.O....O..#.....O..OO.O.#
#....OO.........OO.#.O..O...#.O...#.O..OO.O#...O.#
#..#.O.O##....O.........#O.O.....#.#......O.O....#
#.........OO#.O.........OOOO...OO#.O#..O..O.#.O#O#
#...O...O...O....O..O..#......O..O..O..O#O#....#.#
#O.....#..OO..O.....OOO.#..O..O..O..#O..O...OO.O.#
#..O...O...O....O.....O.@..OO....#.......OOO#O...#
#.OO.O..O....##...O....O#O..O.O....OO..O#.....O.##
#.O.......##.##..#OOOO..OO....#.O#.......O...OO..#
#....#.O..O..O....O....O.OO.O...#OO.....O...O....#
#O......O.....#.#O...O..O..O..O.......O......O.OO#
#.......O#.#.#....O..OO....O.O.OO......O.O..OO...#
#...#O..#....#...OO..O....O#..#...O...O...OO.O..O#
#.....#.O..#.O.#....O.O..O#.#..O..O.#....#....OO.#
#.#O#....O..O..#.OO...#.OO....O......O#OO.O.O....#
#O.O..O.OOOOO....#.O.....O..OOO#...O#O..O.O...#.O#
#.OOO.##O.O.#..O.OO.OO.OO.#O.O.OOO...O.....O.O...#
#.O..O...OO.O...#..O..O...#..O.OO....O.....O...#O#
#O.....#.OO.O..O..........#...O.O.O.....OOO....O.#
#..OO..O#.O.O#O.O#O.#.#O..O#..O...#....#.#.#..OOO#
#.#O....##...O#O...O#..OO...O....OOO.O..O.O.#.#.O#
#.O.O..O...O.....OOO.O......O....O#...O.O#.O#OO#.#
#.O.......O.......#.O..OO.....OO#..#..#.....O..O.#
##O...OO...O.....O.O...O...#...O.O....O.O#.O....O#
##....OO..#OO.#...#..OOO..##.O#.....O...O.#......#
#....O..O#.........O.............O..#OO...OO.OO..#
#O....O.OO#..O....O...O......OO......O..O.#O.O..O#
#.O.......O...OO.O......O.OOO......O..O....OO....#
#OO.O.O...O...O.O..O..O.......O.#..O..O...O..OO..#
#..O..O...O#....OO..........O.#OO......O..O.O....#
#O..OO#.O..O##..#....O...O.O..O......O....O.O..#.#
##################################################

^>v^^>vvvvv><vvv>vv>v^v<v<<<<><v>vvvvvv<^vv><v^v>><v<^><vv^^^<<<v>>v<<v^>v<<>v^^v>vv><^>><>v^>^^v<vv<<>vvv<^v<^vv><><vv<^^^v^><<vvv<<^>>^<<>^v>v^<^<^v>v>v>><v>vv^<^^>><<>^^v^<><^>^^<v^>><^v<><^v><<<v>^^>v^<^>>><^>^^^<<<v^><v<v>vv<^<v<^>v>>>vv<^<^>v<^><><<vv^v^<<^<>^>v<^v><vv><v>^^^^v^<><^^^^^v<vv<^<^^^^<v<vv<v<^vv<<^<v<<^^<<^><<<<vvvv<<>>^<<v<v^^>vv<^v^^^>><>^<^^><v^^vv^v<<^^^<<>v^>v>v<<^<>>>>><><v^<>^^><^<v>><<>><v^<v><<v<^v<<>vv<>^<>^>v>>^^^^v<<^vv><<<<^v^<>v<>v>v><>v<v<^vv^<^vvv>>^<><v^^>^>v<v>>v^>v^><^>^<^<>^>><<<<>^vv<<^>v>^<^><v<>>^>v<^<v^^>^><<v<^v^>>>>^v<><>vv<^>^^>vv<v^>vv^>v^^>^^v<>>v><^vvv<<<<><v<v^<^^^v^^<>>v<vv<<>v><>vvv^<^v^vv^>^>vv>>>^^<<<v<^><>v^^^<<>^<v<^>v>>>vv^<v<v^>^^vv<>v><<^^<>>v><><v<>vv^<^^vv>>^v^v<>^^<^>vvv<^>vv<^<^v>><^^^v><^>><^<^<<v<^<v<<^v>v<^v<^<<>^<<<><v^>>^^v>v<^<<>vv<v>^<vv<>v>v>v^vvv^<v<^<<>^<>v^^><^>v>v^^>>>>><<<<<<>^>><^<v^v<<v^^v>>^v<vvv><<<<vv>v<>v<>><<><^<v<>^><<^<vv>^><>vv^^>vv>>^vv^>^^v^<<v>>>^<v<<v>>vv^<>vvv^>^>>v^v^^^vv^vv^<vv^>v^^^<>v^<v<^>vv
<v>>v^^v<><><vv^<vv<>^<^>v>v>^>^v^^>v<><^v>^^^<v^v>^<<vvv>>^<<>v><^<^^^<v><<v<^^^><<vvv>v^><<^<<>^^>^><>><^v<<<v<>^^^v<^<<vv<^vv<v^<^^v>v>^<^>^>>>^<^vv^><>^^v^>vv^v>^<<<vv<^>^<<^>>^^>vv<^<v>^v<^<v<vvv>vv^<<^<>vv<<>^v<^<<<<^v<>^>v><vv<^v^^v>>>><vvv<vvvvv>vv<v^<^^^<^vv>v<^v^^^<<^<^v^<^<^><^>^<<<>v<>v>v<^vv>>>v><<vv^>v>^^^v>><<^>^v><^>^v^>^><v<>><^<><^vv^<^<><^^vv^^><v^^><<^>^>>v^^>^^vvvv<><<>^vvvv^vv<^>^><<v^<><v<vv^>^^<^<v^^>^vv^v^><<v^^><<><^<<^vv^^<>>>^^^vv>v^<^<vvv>^v>^^v>>>><><>v^vv>v>vv<vv^vvv>vv^<^^v<<>^v<><>vvv^>>>^v>><vv<>v^v<>>>>^<^^<v>>^>^>v^>>v<>v^^^v<^vvv<><><<^<v<>^>>>^v<v>>>>^^><<<<<^^<^<^^>^<>vv>^>vv>v>^<><vv>>^v>v^^<<^>><^vv>v>^>^>^<<^v>^v<^<<>>v^>^v>v>v>><<<^^<^^^<<><>><<^<^^v^v^>v^^><v>>v>^<v^v>>vv^><v>v><>>>>>>>^^v<^>>>v<<><v<><^<>^v<^^<<^<^^vv>^v^^vv<<^vvvv><<<v><^^^^>>^<<><<>>vv>^^<<^><<<v<^><^^^<<>v^^^<<<vv>v<v>^<v>vv>v><vvv>vv^v^v<<v^^<v<>^^<><<<><v<^^^<vv<v>v>>>>v<^v<^^^>>^>^^<>^<<>^v^^><>>><<<<v^v>^^v>v<>>v<v>>v^v^<^<^><^<v><^^vv<^^<>v<><v>^v><^^<<>^<>^<<>^v^vv<
><^^>><^<<<>>v<vv<>>^<<^<>v<<>>>^v>^<>v<^^>>v>^v>><^<<^><^<>v<>^v>><<<<<vv^v^>>>^^^>^<^>^>v^v<<v<>vv<^^<>>><vv>^><^^<<><>>^>v>^^>^<v<>^v>^><<^^>>vvv^<v^^>><><^<^>v^^v>>>>v^<>>v^^<v>^>><<>>>>>><<^^<><<vvv>vv^^v>v<^^vv>><>>^v<<>^v>^vv><^>^^vv>^v><>>>v^^<><^vvv>^^^<>v<>^v>>^vv<^<^<<><>vv<<^>>^^^<v><v<<><>^><>^v>^<>^<^>^>><^<>v^^<><^^<>v^<^v^<<<>v^<vv>>^>>^^^>>v>>>^^v><>>>><><^^<^v<<^v^^^<v>^v<><<v<v>>v^v><^<>>^<^v^^>>^>v<^<>>^^v>>vv^>^>^^><><v>^v<<^v^vv^vv^^>>>^^v><v>^<vv^><<<vvvvv>>^v><<<^><^<><<<>>^^^^>v>v^<^v^<v^<^vv<^^^v>>^v<^>v<^>>>^<^v^<<>vv^>><><v>v<v>>^>>>>v^<<>^><<^><^>^>><>^^v>><^^<^^vv><^v^<v<vvv><<v<>v^<><^>v<v^>>>vv^<<v^v<><<^v<><v>>v^v>^v^<v^<^^vv<<<>>>v<<<v^vv^v<><vv<><<>>^^<^>v><<v<^>vvv>^vv^vvv<<v^vv>^vv<>v<>v<v^<<<^vv>^^^^>^>>>><<<<^^<>>>^><^^><<<<<>v>^v><^><v<^<^v^><^^^<>>^^<vv<v^>>><^<>>^v>^<vv^v<^>>^<>>>v>>>>v^v^><vv^<<v<vv>^<v<>^^>v^>><>>^<<vvv^>^<>^<^<>>^^<<<<vv>>v>><vvvv>v^<^v<>^^v<<^v>>>^^<<>>vv><><>vv<^<v^<>^>vv>^<>vv>^vvv^v<>^<>vvv^v<vv<><^^v<vv<^>^><<v>><v>>^^^
<v<v><<<^^^^>v<^^>v>v>v>>>v><<^^<^<v^<^>>>^^v>^><^v>>><><v^v><><v<<><v<>vv<>v><<>^v>^v<<^<<^<vv^v><>v^>v<><<v^<v>^^<><<v^v<^<>^<><>>^v^^^v>vvv<v^v^^><^><^v<>>>^<^>v><^<^^^^vv><vvv>v>^><^^v>v^v^v>><>^<v^v>>^v<^<>>><><>vv><>^<^^^^v^<^<<<>^><^<>>v<>^>v<^<^<^<v>^^v>vv>vv<^<<^<<^>vv><v<><<<^v>><^><<>v^>v>v^<<vv<vv<>>^vv^>v<>v^<v>v>^v>>>^<^^v^<<>vvv<vv><>^<><^^^v>v^^<^v>>vv>v^v>v^v>^<^^<<^>>><^^vvv^^>>^>>><^v><^^<>^>v<>>^v<^^vv>v<^>v>^<vv^v^^^^v<v<>vv<<>v^v>>vvv^<>v^vv^^^>v<>>^<^<^v>vv^^><^^>v<>vv<^vv^<<vvv^>v^v<<^<vv>v><>^^<^>vv>>^>><vv>^>^<v<^^>v^>v^^<>v>^>vvvvv>>>>^^><>>^<>vv<v<^^>vvv^^<v^^<^<v^v<vv^<>>^<^>>^^<v^<v^<<<>><v<><vv<^^><^vv>vv>>v^>^><>>v<<v^vv<v>>>^^<v><<>><><>^v<<^>v^<^^<v^^^v>>^>^<>^>>^>>^<vv^^<<v><>^>vvv><v<><<<<^v>>>^^>><^^^vv^^><<^v>><^><<v^<v>>v><<v>^>^v<><<<<^v<vv>v<^^^<^<>^>>>^><<<^<>><v^^<<<<<v>^>vv^v^^>^>>v><^<<>>v<^>vv>>><^^>vv>>^>^><<^v>>vv<v>vvv<>vv>v<><>>^>><><v<>>>v^><>^v^><^^<^>v>vv^>>v>^^v^<<^^^<<<<<<>v^v^^v><><v<^>v^><<vv^<vv<<>>^><>v<v>v<v<^vvv<>^>^<<v^>>v<>
v>^<<^>v^v^>><vv<vv<><<v^vv><^<v<<^v>>>vvv>^<>vv>v<^><<>v^>v>v<^vv>^^v<vv>><<vvvvv<<v^v^<^<^>^v<vvv><><>^<<v<vv<^^^><^>^<v<v^>>^^^v>^>^<^^^<<vv^^^><^>v>>v>>v>>>^<v<^vv<^vv<>^><<^v^>^<><^>v<<>>v^>>vv<^^^^><^>v>>^>v<^>><^^vvv<v<v^v<<^^v^^>v<^v<vv^><<^<^v>^vvv>vv^>v<vv^^<<><v<<>>><v^<>^v<<<<<>v^>><>v>>^>^<^v<<<v<^>^<<^<<v>><><><>^>v^v<^^^<v^v>v>v>>v<>^^>^<<v^^<>>^<>^^><v>v^><<<>v<<<<^^^^^><>v<><v><>>vv^vvv>^<<^<>vv^>v>>><v>><<><>^<v<<v^>^^v>>^^<^>v><^<^<<v<v^<<>>v>vv<^>v>^<>^<^vv^^^^vvvv><<>^v>v<v<^^v^<><vv>^>^>>vvv<<v^v>^<^^>^>^v<>>^<v<v>v><>^>v^^>^<^<^<vvv^<<><v>^v<v^>>>>>^><^>v><>>^^>v>><^>^^vv<v>vv>^<^^vvv^>><v><^<^<<^<>v^<vvvvv<><<<^v^v^<v>>v^v>v<><v>^><v^v<^<<^<v<^^^><><<^<>v>^^^<v<<vv>><<v>^<v^<>v>>^^^^^><>vv^>>^^<>^v^^v><<<<^>v^<v<^><<v<>^<>^vv^<^<<<v^><v<<^<>v^^>>^<vv>^<<>^^<^>^v^><^<v^><><<^<v^v^^<^v><v<^^<v^^^^<v^>^<^<>><^>>^v><^<^v<^vv<<>^^v^v^<>v<<^vv><>^>^<v>^^^<v^<<^vv>>^<>^^^<v>^^^<v<><^>v^v^><<<^<^>^^v^>vv<^v^>>>vv>>^^^<v<v<^vvv^<^<>>>><>>^vv<>v^><>>^^<<v^<<>^<<>^vv^^^^^v
<^>^>v<^<vv^<v>^<^<^<^v>v<v^^^>>v^>^^^<>>^><>v^>>>>^vvv^vv<<<>vv<<v<>vv<>^v<v>^<^><^^vvv<v<^>v^<<v<<<v^<v<<><^>^^<<>>>><^v><>^>v>vv<v<>>^><v^^^^^v<<^vv<^^^<v>^<<<<<>><<^vv><<^^<><<v<<^v^<><v<vv<v^>^v>>^<<^<><<<^<><v^v^>v><>v^v^v>^v<<<v<>v><>><^v<v^v^v^<v>vv<>>vv^>v^>><<^<v>v^>vvv^>v>vvv>^<v>v<>v<^>^<><^<v^><><v>><v^v>v>v^<>>^vv<>^><^^<^^^<>v>v^^<<><^v>^<v>>v><v<<v><>v>^v>^<v^>vv<>^v^>>>>>v>^>vv^^<v<>v^<>vv^vv>v<^v>^^^vv>>^^>^><>^v>>>^^^v>^v^<^v<<<<<<^^<v<^^<>^v^^><><^vvv^^v^^^^>>vvv<v^><vvv^v<><<v^<<<vv><<v<^^^vv^v<>>v<v<><^v>><<<<^<<^>vv<v<vv>v^v^v^^><<<^v^^<vvv^^>^>vvv>>^v>v^v<^<^<^<<^<>^>^v>^vv^^v>^^v<^>v><>v><<<^<>^^>vv^^<^vv^>^>><>>v^^>>^v<v>^^<>>>>><<>>^^v<^>v^vvv>><<>^>>><v^>v<>><v>^^vv<>>^v<<<<<<v>^v>^<><^^<>^^v^^^<^^<>v<>vv^^>>vv>><<vv>><v^<>^>^^^v>^><^^v^<<^<>>>^<>>>>^^^^v^^>v>v>v^>v>^<<<^><>v>^^>vv<^^<^>vv^<^vvvv<v<^^^><v>><^<^<<>v^>v^<v>^^<>^>>><>>^<^^^^<<^><<>vv>v^v>^^<vv<><v><v>>>vvv<<>^v<<^^>^v>^^>v>>>^^<v<>>vv<^<vv>v^<^>^^^v>^^>>v^^v^v^>>^^^>><<^>^^v<^>>^vv^^v<<^<<<^<^<
vv^v<^vv>>v<>v<<v^v>>>>>vv<^v<<^>><v<<vvv<^^>>v>>^v<v<>>v^v<<>>^><vv^<^^^<^vv<>>>vv<^<<<^><>^^>><<>vvv^v<v<<^>^v>><^<v>^<<><>^^>>>>^^v<>^<^<v>v<vv<<^^>^^>>^v>>>>v>v<^<v>v>^>><<v^<>><<>^^<vv>v>^>^v<v><<v><>^^v<v<<>>v^^^<<><<<>vvv<v>v>>>>>>><vvvv><vv^v>>><<^<>><v^<v>vv<>v>^<<>><vv><<v>v>>><v<^<>>>>^^<>v<>^vv>>>>>^^vv><>v><<^<v<<^><v>^<<^^v<<><^>^^>v<<vv<<vv<^^^^<><^^^<^>^<>><^><^^<^><><^v<><v<^^v^>^^>>^vv>vv>v>^v<v^><^<<<^><^>>^>>>>v><>>^v<^<v><<v^><<^><>^vv<<>^<<^v<>^<v<<<<><>v>>><^v^<^^>>^^v^>v>>^vvvvv><<<<v><>vv<>^<v<>><<vv^<>>^vv^><v^<^v<<>^<v^>^^v>vv<v^v>><<^<>>^<><^<>^><<^^v>^^>v^^<^<v<><>vv>v<v^v<>v<^v^v^><v<vv>^^^v><^>><^<<<<^^><<vv>^<>>>^>>^v>>>^>><>^>>v^<^^>^v>vvv><^<v<<>vvv^<v^>>vvv<v>v<v^<<^<>v<v<><v^v<>>^^>>v>><^vvv>vvv<^<v^^v>><>>v>^<>>^<v<><>^<v^>v^<^v<<<<^v>>^<>>>^><><v>v>><>^^><vv><^v>><>^<v<<>v^<>^vv<<<>vvv><<>^<v^vvvvv<<^<vvv^^^^>^<<^><<^>>v<<<<^<<^^><^^v<^<^<>^>v^^^>v>^>><>><<v<^^<v<<v><^<^<>^^>>>><vv<>><<^>v<>>vv<v^^v>>>^>v^^<>^>>vv>v><>^^^><^><^^<<v<>^^vv>>^v^v<^^><
>>^v<v><^^<^><v>v<><vv>>><><^v><>v^<><<v^<><^>>><^<>^<^^^<^v^^v^^^<<^>v>^<^^^<^^<^^^><<<<><<^^<<v^<<<^v^><>^^v><><^v<^<^^^><<^v>v>^^^>^^v>>^v<>v<><>v<>^^<vv^<vv^>^^^v<><>v>v<><<<^v<><>>>>^^v^v><v><^<^v^vv<><v^>v^<v>^><<vvvv>^><<v^<<>^<v>^v^<^<^>v>><v<><v>^vv<^<vv<^^>v<v>>v^^><^<>v<v><^^<v<>>v^v^^v^^><^^><<>v^>^^>vv>v>v>><^vv<<<^<<>v<v^v>>v<<v<><<<^^^v^<<vvvv<^>v^<><>v^v^>>v^<><v>vvv^v>^vv>><>>>v^^v>^<^>><>v>>v<vv>><^v>>^^v^<<^v<><><^^<v<v<^^^^<<v^>><>^^<<<v^v^>^>vv><^>^^v>^>^<vvv<<^v^<><vvvv>><v>v^>vv><><<<<<<>v^<<^>^><<^<v<v>v<^v^<<><>^^<v^<<^<^vv>vv<v<v><v>v^^<>vv<^><<>v><<<v>^^<^v^>>>v^<v<vv>>>^v>>v<<vv<<<<>^>^^<v>>v><^vvv><<<><^>^^<><^^v^<^<>v>^>v><>>>^v<<^<v><^v^<><>>^<<>^v^v<^<^^<vv^>v<^v^v^><>><>vvv>^<^>><v>^v^vv>><<vv^>^^^^v>v<><><<><<>^>v><<v>^<^vv<>^v^^>v^^^>^>>>>>>^<^<>v^^>v><^<<^<vv^><^^^><<vvvv<^^^<^vvv>^>vv>>>vvv<<>v^<vv<v^^^<^v^v^><v>v<<vv<>^^>vv>>vvvvv<^><v>><v<v>^^^^<^v<^>>^^vv^>^>>v^<<vv^>v^v>^><v>^<^<<^vv>^^vv>>v^^^<v><v<>^>>><^^<<>^^^<v<^vv>vv^<>v><<<^^>^>^><<>v<><>
^<v<v>v>v<<>v><>>v^<>v<>v<<v^v<v>><^<^<v>><>><<v^^v^>^v^v<v^v^v^v^<^>vv>vv>vv>^^v>>v^^<vv<v^>>>vv<^v^>^v>v<v><<<<vv<><vv<v^<<<>v<>>v>>>^<<vv^vv^<v<v^><v<<^v^vvv^<<vv^<<>v<^>v^<<v<vv>v>>>>>v<vv<><v<<v<^<^<^v>v>^<v^<>v>v<<<v^<>>v><><>v<^^<v>><^v^<v^v<v><><>>v>^<>^^<<<v^>v>^><v<vvv^^v>^<>^<>^>^<v>^^^^^v>v>>>>v<><<vv^>^>>^>><vvv<v<<v>><<>>^vv>^v^<^>>>><<><<<<v<^^^>v<><vv>>v^^<v<v>v>><^>v>>>^v<<>vvv>>v><v<>>^><<^>v<>v<>^vv^>v^>vv><^<^^<v^><<v^^<^^^<^<^<><^^^v^^<v><^^>>vvvvv^v>vv^>^>^^><>^^><<<><<<v^^<<v^<<v^^<^><<^>v<<<>>^v>v^vv<^<v<>v<>^v<^^>v^^>^<<<^<><v>^^<>^>^<<<><v^>vvv<^><>vv>v><v<^^>>^v^^>^>>vvv<^<^<^vv<>><v^v^<v>^v^<v^><^<<>v><<v>^v^v>>^<vv^<>^vv>^>v>vvvvvv<^v^>vv>>^<><>>>><>^v<>>^vvv^^><<>><>^v<^><<>^v^>v>v^>>^^v^v^v<>v>>v<v^^<vvv>^><>>^^^^^^<>v>vvv>><>v>v<^<>v^v^<<^<>^^^<><<<^^>^^v<<>^v<^>>>v<>^>>v>v<<^^^><^>^v>>^v^v<><<^^^vv^v^vv^<>vv<v>^^v^^><v<^<><<^^^><v^<>^<<^<><^v^vv^v^>^<v<vv<>vv^v>>>v>v>^<vvvv^>><<<vv>v>^>><^<<vv^<>>^v^^<v<v>>vv>v>^v^>v><^^^^^<^^v>v^>^>vv^^<<><>>^v<<v<v>v<
<><<<vv<v<<<vvv^^>^vv>>v<^v>v^v>v<v>vvvvv<><^v<>><^<<v>^>v<^>><vv>^>^>^v<^<^<^^><><v<^>>v>v<<<v<><>>v<^v>><vvv^<>^^<v^>vv><^>v<vv<v^><v><><^v<^v>v><<>vvv>v<<<vv^>^<>^>>>>><^<><><<^>^><^>^^vv>^<<^<v<vv<>vv<<^>^vv^^v<>vv<v^vvv^^<v><<v>^>v<^<<^v>>^^<>^v^^^^v^v^><>vv>vv<v>^^v<^><>>><>vvv^><<>><>v>^^vv<<vv><<v<vvvv><>v>v^v^v>><^^>v>^^><^>vv^v>vv><v^v>>>^^<>v<>v^vvvvv^v<^><>^^vv^<v^vv>^v<^<<>v>>^v>v^v>^^>^v^^<<^>><v<><<^vv>>v^>vv><v<<vv^<<^<vv>>v<^>>>><<>vv<<>v^>>vv>^<v><^<>^><^<>>^^^<>^v<><v>v>v>^<^^>>v^v<^v>><<>>v^>>^<<v>v<v><^^>vv^>v^<<<^v^>^><<<<v^>>v^vv<<^>v<vv>>v^<vv^v>v<<<v^v^vvvv<v^^^v^vvvv^v>>v<^><<^^v<<<<<<v^^<^^v>^>>>vv^><<^v^^<><^>^<<<<^<<^<<vvv>^^^><v^>v<><<><<^^v^>v^><>v<<v><><>>><<v>vvv<^>v<v^><^v^>v^>vv^<>^<^v^^vv><^^>v><<v><>>v^<^<v>^>^>v<^vv>^><<>v>>>^>>^<v<>^^^<^^v>>>vv<^<<vv<>^v^^<^^<<>v>>>^vvv>^^<vv^<v^<>^vv>^<v^vv>^v<^><v^>v>>v>v<vv^<^<>><vv>^v<^<v<>v>v>>v^>>v>^<v<^<>v>v^v^>v><v>v^>^^>v<<v>>>^v^<v^^>>^^^>>^vv<<^<>^>><<<>>^^<^v^<<vvvv^^v^<<<<<^^<^<^<>^v>vvv<^v<<v>^<^v<vv
^^<vv>^^<>>^<v>>v><v>^v^^<<<>v>><^v^>>^>>><^>^v<>^<^vv><vv>v<v><^vv<^^<<v<^><vv^v<vv^v>^v^>>^>^^v^<>>v<<<<^<>v^>^vv^>^><v<v><v><>vvv<^<<>vv<vv<^>vv<v>vv><^v^v^^>v>v>^>^^<>>^vv^v<<v<>>>>^^>vv<<<<^^^><v>>^>>^<>>>>v>>^v<vvv^v<<>^^<^^>^>^v><v>^v>>^^^<<v<^vv^>v^<<v^v^<>v>>^v^^v>^v^>>v<>^<^^^>>^^^<^<><<^<v<<>>>v><>^^>>>^v^^<><^<>><v^^>vv<^>><<v^^^<>^<vv^><>>v<vv^^vvv<><><vv><^>^>><^>>v^vv<^v^>^v<>^vv<^<>^>v<>^^><<<>>v^^v^v<vv^^<<v^v^<>^^vvv<<v>^^>^vv<v^<>^^vv^^^^^>vv^^vv<^><v^<>>>^^^^><^^>^v<<>>>vv><<vv^>^<<v<v><<>^<>^<v>^v^^^>v<>^v>v><>^vv>v>^<v<<>v>>^<<>>vv>v>v>^v^^v^>vv>v<v<^v>>><<<>><<>^>>vv<><vv>^>vvv<^^><<^^^<v><^<v^>>>v^^>><><vv^^^v>vv><v<v^>^<^>v<>^v<vv>>v<^v>>><<<><v<<>^v<>>><vv<<<<>>v<^v^vv^^<<<v<>v<vvv<^<>^>^^><^v>>^vv>v>>>>>^><<<><vvvvv^<^<<^>><<<v^<<>v^<>>v<>^^><v^<^<v^v^<>>>>^v^v<v^v<v>^^v^>v>>v^<vv^^>^^^v<^<<^><v^^>^<v>>^v>^<^^<v^><v<^>^>^v>>^>^<>^vv^^>>>^<<<>^v<^<<v<>^^v>^>>^^^^<^^>^v><^><<v>v<v^v<^^^><v<<^>v<<^v^<^<<<v<>>v>>^<<>vv>v><<><>>><<v>>><>>vv^><^^<<v^v>vv<^><v^<<>vv
>v<^>^^>^vvv<^<v^<><v<^^><^<^>>^^>>>vv>vvv^^><v<^<<v>^<>>^>vvvv<v>v>^^vvvv>>><^>v<<^^^>v<v<>^<^^>^<<><<v>v<^<<>^<v^>^vv<^>vv>^v<>vv<v<^^>v>v^^<^^vv<^>>^v^><<<>v>><^>v>^^v^<<<v><>^<vv^<<<^^^<<v<>>><<>vvv><v>^v<vv><><^>vv^>v^<>v^<<^v^vv>^v^<^<>^<><>vv^^<^v>>^v<v<<^>v<<v^>>v^^^<^v>v<>>^<v^<<v>v^v^^<^^<^<vv^^v<<<><<v^>>v^<<<^>>v^<<^vv^v^<>^>^vvvv^v>v^<>v<^vv<^>>v<<<<<v>>v><^vv>vvvvvv><v<<<^^^<<^v>v>v<<v<^^v^^^>>v^v<<^<v<<^<><<><<<v^^>><^>><>^><>^vvv<^<^v>v>v>^>^v^><^>v><>^^>v^<v^^>^<v<v^^v<^<v^v<>^>vvvv<v><>>^<>^>^>^<vv<><vv>>>v><v^<^<^<><^^^>>^>>>>>v^v^v^<vvvv<>><>^>v^^>>v^<v<v^^><><v^v>>v<^v^v^v^^^>v<v<<v>^^^v>vvv^<^^^>v<v<^><>>^><>vv^<>>^^>><^v<^^^><vvv><^<><^<><vv>v>^<<<>^<>><^vvv^>^<><v<^v^>>^^^^^<<<><<<vv^v^v^><>>>>v<^>^vv>vvvv<^v<<^vvv>v^>vv<><<v<v<^v<>v>>v<v^v>^>>>^v<vv^>>^^<>vv>v^vv<<v^^<v^v>vvv^v^<>^<<<v>>vvvvv^><^>><^v><><<><><><<>^>^^<v^<v>^vv>vv>v<>vv<>>><v>>><^>vv<<>^v^<v>>>^v<<v>^<>^^vvv<^^v^vv^^<^vv^>>^v^v>>vvv^<^>><v><>^v^>>>v<<<v^>v^v^<^<<>^vv^^^>>vvv^^<v^>vvv>><v^vvv<vv<
^>^<><><<>^>^^v>^v^v^v<<><^<>>><^^<v<vv>v>^v<^^v<^vvvv<vv>^<^v^^>v<<<^v<>v>^v^^v^>v<>v>^^^<<>^vv><v<v^^<v>vv<>>>^<^^v^^>v<<><vvv>v><>v^<<<<vv><^>v^^<^<><>><<>><v^v^<<v>>>>^^>^^<<>^>^<>^><<^<<<<v^<^>v^^v><<>>^v^<<>><<<v><^>>^vv><>>v^v^^v><v<^^<<v^<v^v>^^^><>v^>>^>vv^v<v>v>^^v^>vv<>^><^v<>>^vvv>><>>v<>v>^vv<v<vv<^v>v><<>^v><<^^<<<<>^>><v^<>>^vv^^v>vv>^^<^^<^^><^>vvvv>>^<^v^^<>^v>^>>>^v^>>^v><v>>><<v<>>v^v>^vv<^<^v>v^^<><<<v>^<vvv<v>>><<>^<^<vv><^vv<<^<<>^>^v<<>^vv<>vv>v<vvv^^>^>v>v<v<v<>>><^^<<^>><^v^^<>>^^^v>^<v^^<<<v<^vvv>v^<>>><v<>^^v><>^^<^<>^<<v^v><<v>vv^<<<^^><v<><^<^^^><<v<v<<^><<>^<><>^^v^v>v^v>^<>^><>^^<vv^^vv<^^v^^<><<>v^<vvv<^>>v>>^>v<^^^<<<v<^<^><v><vv<v^>><v<^v^v>v^<^<>v^^v^<^^^>>v^>><^^<<v>>^><^>^v<vv^<v>v^vv<v>v^<<><>^<^<>>^v^v^^><v<v^>><<v^>>^v<v^>^v^>v^^>v^<<<<^v^<>v^>vvv^^>v>>>v^>^<vvv>^^<>v>v^vv<v<v<^>v<><><><<>><><>v^v>^^^<v^^>v>^<>^><><<><v>^v>><^<<vv<>vv>>v<<vv<>^^^>v^^v<vv>^v^v<v<><^<>>>^>v^^>^>^^^v>v>>v<<><>v^^<v<<<>^v<vv>^v<v<^><<<^<v>>^v<^>^>v<<>^^<^vv<<v>vvv>v^
<<v>^><>^>>>^^^vv>v^>>^<^<>^^<><<>>>>^^^^>^><v>v^v<<vv<vv>^^><<v<<<<<<v<>vvv<^v^<^^vv>v<^v^>^^<<>>^<<^v^^v><>>v<>v>>><<>^>><^>v>^<^v>>><vvv^v<v><>><^<<v^<^^^^v<v^><>v>><>vv>v>^<<^>>>v<>^v<<><^v<><vvv<>v^^>v^<vv<^>>v<^v<>v^^><<^vv^<<<>^v>^>^<<^^<v<><<<<^^<v<<^>v>^^^<<><>^vvv<v<^>^v^^vvv^^>^^<v><^><v>v^<<^^><^v<<^<^^<^^^^>>^v<>^v>v>>^v>v<<v^<><>^^vvv><^>><^^<><v<v>>><^<<v><<v><v^v^^v>><><^>>>^>v>v>><<>v^v><<v^^^<>>>vv^<>^^v^>>>>^<v><>><<<v>><<>>v^<^>v^^><v^^v<<<^<^>^v>^vv^>v>^v^v^<^><><^vvvvv><>v<^<vv^vv^><^v><v>v^>>vvv><<<^^v>^^<>^^>^v^v<^^^<v<<><>>^>v<>^<vvvvv^<v^<>v<^<^^<>^^<><v<>v^^><>v<v>>v><<v<^v>^>>^^vvv<<^>^v^<^<^vvv^^^<^<v>^v<>vv<<v^<v>>>^^>>v<v^<<^<v^^^v^^>><v<v<vv^v<<v<><^^v>^<<vv>>^^<<^^vvv>^>>^<<^vv^v>v<vv<^<^^<<<>^>v<v<>v<>^<vv<v>>v><vvvv<<>>>><>^>vv^^vv><<>><<^v^>>v<<><v^v>>^>^<v><><>>vv>v^><<^>^>><^^<v^^<vv<<><<v^<^^>^v<v>v^vv^^^<v>v^><>v^>v>v^v>><v>vv<>^>^<v<><v<>>v<>><<>^v^^^><><>>>^>vvv>^^<>v<v<v<^^^>>>>^>v>>v><<<^>>>^v<<^>>>>>><>>vv^v<<<>><^<^v^>vv<>v<>^^^^>><>><<>^v<
<v>v<vvv^vv^<v^^^^^^^<>v<<^vv>v>^v>>^v^vv<>v>^>>>^v^v>><<<><>^<^<>>^^^v<v>^vv>^<><>><>v><v^><<^vv<>vv>v><<>^^v<>^>v<^^^^>>>^>>^^^>>v><>vvvv>>^<<v>v^^v^<vv>v<<<>v^<<vv>><>vv^^>>>^^><v^^^v^^>^^v^^^v^^><<^^><<v^<<v>^v<<^^vv<<^>v<><>v<^v>>><<<^v>>^v>v>^>^v^vv^><<<^^^vv^v^v>><^>><^>^^>v<^<v^^^<v>^v<<>v<>>><v>>v<<<v<vv>v>>v<<>>v<vv^vv>vvv>v^>v<<^^<vv>>v<^^><v<vv><^v<^<>v^<<>>^>^<<<<v<>v>v>><<^v<<>vvvv^v^>v>^<^>^>v^v>^<>>v^^<v>vv>v<^>^^<vv^<<<><<vv>^<<^^v^v<>><vv<<^<vv^<><^^>v^<><>v<>v><^>^><<v^<<^^>v>v^^v^<vv>vv^^v^v<<vv^vv><^<><^>v<v^v><>>vv<^>>^v<<<>><>><^><v>vv<<>vv^^vv<^>><v^^><vvv^^<>>>>v^v><<^vvv^v<v>vv^vv<^^<^>>>^<><<<v>^<vv^^v^v><vvv>vv>>>><^<v<>^vv^^<>>v>^^<<^<^^>>>v<<<>^<>^v^>v<^<<>^v<>>v<vv<v<<vv^>^^<^<>>vv<<vv^v^>><^^<v^v>^v^<v^<>><<^<>^>><>v^^><vv<<v^>v^<<v^>^v<<v>><vv^vv><^^<<v>>>v^v^>^<<v>v^<^^v^<v><>><>v<v<>^<v>v^<<^>v<<v>>><>>^><<^<<v>^^<v>^>^><>>>^vv<<^v>vv<>^^<^vvv<>>>>v>v^<<><>>>>>>^vv<>v<v>><^<vv><>v<^v>^v^v<vv^<<><v>>vv<>^<<<v^v<^vv>v>^<^v<>><v<v>>>v>v^>v^>v<<>v<^<><^><
v<v<^v^<<v><vvv<<^^^<^v>>>^^^^<<<^v>^>^<^^>v^><>v<vv><v<<>^^^>vv^v^>^v<^<<<>v<v^vv<>>><^<<^<v^^<^^>>>v<<<^<^v>vv^>^v^vv>^^^^^v><^>v>^<<<<^<v>^^<<^<^><>vvv<>^v>vv>^v>^>>^<^>>^^>^v^><><vvv<<<^^><^>^^<v<<v<v^<^<vv^vvv<^>^^^<v^v^v<v^>^><^^^v<v^^<<<<v^<<<<^<<^<>v>v<<v><<>vvv<v>>><<><>^v>^v><^v^v^<<^>^>v<v<^^^<><v^>^^>v<v>v<>^^^v>^>>v^><^><^vv<^^^<vv<v^vvv>v<>v><<v^<v<>v>>v^<<v>^v^>^v^v<v>^^v<^<>><^>^>vvvv><v^^^v>>^v^>^<>v>^>^>^^<^<>>>v>^>><>><><<<>>>>vvv^<<>vv<v<<v<v^<^>>v>><><>^vv>>><<>^>>v^>^vv<v^<^^>>v<v>>vv<^<><<><<<><><^<>v<>^^<<><vv^<^>>v><<<>v^>v<v<<^<>^v<^>>^>>vvv<<vvv^<<^>>^^v><vvv^^<>>^v<>^<^v^vv>v<<v>v^^<^vv>vvv^><vv<>v^^<vv^>v<<>>^^<>^vv^^<><<<<<>v^^<><v><^>vv<^><>^>>^<^<^^<<><<>^v>vv<>><<>^<<>>^vv^v>v<v^^^v>^v^>v><v>^v><>^^^<v^<>v>>>^<<<^<>v<^>^v<>^vvv><>>vv^<^^<<v^v^<^^vv^<>>^<vvv^^^<vv><v<v><^^<^<^<<><<v<vv<^^^^<>v>^<v<vvv^^^<<v^>^v>>>^>^^^<v<^^>>>^<<<<<<^><v<^v<^v<^<>vv<>>vvvvv>^^<vv^><>^v^>^v^>^>v^>^^v>v^vvvvvv^<v><^^<<>vv><>vv<>vv<vv<v>^>^>v^>>><^<^<^^^<<>v><v<^^><<<vv>^><
><v<>><v>^^v^<>>^<v>><^<^<<v<v^><<><^>v^^^><<^vv^<<^^<<>v^<^v>v<v^<>v>^><^><<<^v>v<<v<<v>v>>>^><>v<><>v^>v^v>>^v<v^v^<<<<<vv>v<>v>^v<>^v<>>><><^><^>>^^v><^>^>>^^>v>>><^>vvv^<>v><v<<<>v<<^^<>v><<><^v<>>^<v>><vv<vv><>v<^vvv^<^v>^<^><^<v>v<^v^v^^vv^v><vv>^<^<^><<^<v>v<vv><v^^><^<<><<^^v^<v^><^^<><<^<>v>v>>^v<^^<v^v^vv<v>><^vv^v>>^<^^v<v<<>v<^v>^<^><^^>v<>^>v>>v>>>v^>^<vv<v>v^v^<^^<><<<<>^<^vvv>^<vv>v^^>^v^<<>^^>vv><<>>^v><>^v^<<<>v>>^<v>>>^<v>^v>>^<><v>vv^v>>^<><^^>v<v^^><>>^>^>^v><>><v<<>^v^<>><v<<^>><<>^^>>v<<><<^<^<^^<v<^<^v<><^v>v^^^v^<v^^^>v>>^v<^^^>^><vv^>>v<^>v>^^^^>^v^<<>v<^>^><^^^>^>v<^v>>^^>vv<v><<v><^^^v^>>^^>^<v>^>^v<>^<<^^<vv^>><>>>v<<^^>vv^^v><v^^>>v<v<^><vv<v<>^<^<v^v^<><^^<v<><><<vv<^<<><^^<^v^<>v>><vv^<><v<v^>>v^v<v<^v^<<<><v>>v>><vvv<<>^>^vv<><<v^v>^^><<><<v>vv<<<^vvv>v^<><^v<<^<v><<<>><<^>^vvv>vv^v>^^^>v^^>^v>>^^><^v><^v>>^><^>v<><<v><^v<<><<<^^^^>^>v>^^v^^v>>>v^^<<^^>v><^>^<>^^>vv>v^><^<^>^>>>^<v<><^vvv^<>vv<^^<v>><^>>v<v>vv^<v<v<><v><>v^><<^>v>>><<vv<<<v^<<>^vv>>^<^^<
<<v^^v^^vv>v>^<^>v><<v><^>^v>^v<v>v^v<>>v<>v><>^<<>>^<<<>>^><<<v><>^<vv<>^v<v<<<<>^^<vvvv^>^vvv^><<<><vvv<^^v>v<<<^<<v<><<<vv^<<^<^<v>>>^<>^>>^v>><><v<<>^<^^v^^>>>v>v>^^><>^<<vv>>>v^^v^>>>>>^>v<<>vv^>^>^^^<>>>><v<><><<^vv<v>^v>>^^>^<>>^^^v^><^<><>v>v<^<^<v<>v<><v><v^<vv><^^<>v>v>^^<>>^^><>>v^^<<<v<<>v^v<^<>>v<v>v^<^>>>v>vv<><<<<^><^<^^^<^^^^^^<^^>v<>v<v<>^<><>v>v^<>>>>v^vv>^vvv>vv>>v^>>>>vvvv>^^v^<<^^>>v>>v>^<>><<><v>>^<^v^<v>^<^v>^v^<v<<<>><<v>^>v^^^v^vv>>v<><<>^>v<>v<<>^^><v<vv<<>v><v>^v<v><v^<^^>v>v<^^<^>v^^<^v>>><<>>^^vvvv^vv^<>v><<<><>><>>v<>>>vv>vv<>vv<^>>^<<<><<<v>^>>>v<^<>^vv^^v><>v><>v^>v<^^<<v><^^<v>^v><<><<<>^>v<v<><v>>><>v^<^><^^v^v^^>v<>^^^^v^^v>>>v^<<^<<^vvv<<^vv>vv><<>^^v^vvv<^>>v^>^>v>>><>vv>v>>^^<vv^>v<v>^<<<v^<>^v>^v<v>^<v>vvv<>^v^^^<>v>^<vv^v<^<vvv^<<^>^<>>^>><^<><>>^><><v>^v<^<<v>><^vv><v<>^<><^>^<<>^<vv^v><><>^><>v>^<^<<<^>^<v^><<^<<<vv<<v><^v>^vvvvv<^<vv<vv<>^v<v<v<v^<v<^v>><v><^<<^^^^>^><<^<v^v^v<^v^vv^v<>^^^^v^<^<<><<<>><vv^^>^v<^v>>><^>>v>>><<v^<v^<vv^^<>^>^^^v
<v>>>^v<v^^^<^><^>v^vv^>>^v>vv^<>^^v^^vvv>><^<^><v>>vvv^>^^>vv<^v>^v><>^>>v<^vvv>v^v>^<^^>>v>>><<<<>v>^v><<^v^<v<>^^^<^v>^>v<>>v>vv^<^^>^>v^^v<<>>><^>v^^vv^>^v>vv<^><<^^vv<v>^v<>^v^<v<>^vv^v<^^vvv>^<>v><vvv><v^v^>>>^<<>v^vv>^v><v>^^><<>^><^>><>><>vvv^^v<v^^^v^^<v<<<>^^<v^>>>vv<v^><^>vvv^>><vv^vv^^>>^>>^<^>><<>^v>^<>vv>^v>><v^v^v>>><<vv^>>v<^^>vv>><>^^^>^<^<<v^vvv<>><^<<v<^v>v><v^^<<v^v>^v^<>^^<><>^v^<>v^v^vv>>>v<<^>>>>^<>^v<^<^^v><<>^v^v^^vv^<<^<>v>>^>>>>^^^>^^>vv>>^v^<v<>^><v>>>v^v>v>><^v^^^<^<^^<><>v<<<vv>>^v<v^>^^<>>><^v<^v>>^<^>><<^v<<v>v<><>v^><vvv>><>^<v>>>^^<<v^><>^>^><^v>v<v^v^<v>><v<v^^>^^>>><<<vv^^^>>^>>^^^^<<v^<<>v><>>v^^<<v><^^v><<>^>vv>>^<<^<^>>^>>v^>vv<>><^v<vvv^^v>^v>vv<^<>><v><<<<vv^>>^v<^<v^>^<><<^>>v<v^v<^^>v>vv>v<<>^^^v^^^>>><^<v^^<v><<^>><v><>^^<<^v^v<>^v<<v<>>><vvv>>^^v<^vv>v>v>>><><^^^v^<^^<^vv<^^><v^><<^^vvv^^>>^><>>^^<vv^^vvv>>^>^^>>><><v^<<>>>vv^vvvvv<<>^^<<vv<>^vvv^>v^^^^>v^vv<<<v^>^v^>^^<v>v<>^v<v><^>vv>^^^<><^v^>>^<>v^v<^>vv^^^>^<^<><<^>^>>v><<<vv>v>><<v^><v
^^<^v^<<v><<^<^<><^><>vv>^^^<v<>>v<><>^^^>^v>>><>>^<>v^^v<v^<<v<vv^^v<v>^>v<v^>v>^^^<>^<v>><^><vv>>>>>>>^v><v<^^^><<>>v<^<v<^<>v<vv<^<^^^^<^v<>v<v<^>v>v><>><^><>^<v<^>^^^^<^<>v^>>^^^>v^^><>>^>^>><<^><^>>^<v^^v^<><v<>v>>><<<>v<^^>v><<v^^v^<>>v>><v<^v>><>^^>>^^^<>><<>v<^^>^^^^>>>><<v><>>><<^<>>v>>^v^<><>><><^^v^vv^>^<^^<<^<<^^<v^>^<^v>^<^>^<>^<<<v^<>vv><<>^vv><<<>v><<^vv<^>vvv>^^^^>>^<<>v>>v^>v<^v^<><>^><<v>v><>^v>^<><>v<>>>v>>>^^^^v<^>>><><vv><^^<<<>^>>>v>^>^>^<>v<<v<<v<^<<><^^<vvvv>>v><v^v^v^vv^v><v>^><><>vv^v^<^vvv<><v>>v<v<<^^vv^>v^v>vvv^v>><<v^>v><>^v<>v>^^<v^v<v>vv^^>>>><^v<<<<v^v<v^<>>>vvvv^^<v^<vv<<v<v^><>>>><<vv<><>>>vv^^>>^>^<v<><^>^<vvvv^^>>^v^<^>^^<v<v>><v>vvv>^v>v><>v^v>>vv>><^<<v<>^v<^vv^^v>v^>v><><vv><^<<<v^<>>><vv^<>v><<v>^^<v<<<<^v^<^v><>v^<v><><>>^>vv>>^>v<v<>>^><vv^>>^^<<<><^^v>v>>>v^v>^vv^><><>>vv>>>vv><^^<>^>^vv<^^>^^>>>><<^<v>v><><^v>v^vvv>>>>v^>v>>>>>v^>^^v^<<vv^<<>>v<>>v<^v>^<vv>v^>vv<>^>>>^v<<vvv>>^<^^v^v<^>><vv<>>v>><>v<v>v>^<^^^>^><>vv>^<>^v>^<<v><>><<>>>v<^v^^
