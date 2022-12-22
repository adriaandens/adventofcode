use feature 'say';
use strict;
use warnings;

use Test::More;

my @grid = ();
my @path = ();
my $direction;
my $r_co;
my $c_co;

run_parse_tests();
run_func_tests();
run_go_tests();
done_testing();

local $/ = undef;
open(F, '<', 'input.txt');
x(<F>);
say "Solution: " . calc($direction, $r_co, $c_co);

sub x {
	my $input = shift;
	# Resetting
	@grid = ();
	@path = ();
	$direction = "EAST";
	parse_grid($input);
	parse_path($input);

	($r_co, $c_co) = find_top_left_position();
	foreach(@path) {
		# do the action 
		if(/^\d+$/) {
			($r_co, $c_co) = go($direction, $_, $r_co, $c_co);
			say "Current position: $r_co, $c_co";
		} elsif($_ eq 'R') {
			$direction = rotate_clockwise($direction);
		} elsif($_ eq 'L') {
			$direction = rotate_counterclockwise($direction);
		} else {
			die "Weird 2\n";
		}
	}
}

sub calc {
	my ($d, $r, $c) = @_;
	$d = 0 if $d eq "EAST";
	$d = 1 if $d eq "SOUTH";
	$d = 2 if $d eq "WEST";
	$d = 2 if $d eq "NORTH";
	return ($r+1)*1000 + ($c+1)*4 + $d;
}

sub go {
	my ($d, $i, $r_co, $c_co) = @_;
	#say "Move $i positions $d, starting from row $r_co and col $c_co";

	if($d eq "EAST") {
		while($i > 0 && $grid[$r_co][$c_co+1] ne '#') {
			$c_co++; # Move a column to the right
			if(!defined($grid[$r_co][$c_co]) || $grid[$r_co][$c_co] eq ' ') {
				my $new_co = find_left_position($r_co);
				$c_co = $new_co if($new_co != -1); 
			}
			$i--;
		}
	} elsif($d eq "WEST") {
		while($i > 0 && $grid[$r_co][$c_co-1] ne '#') {
			$c_co--; # Move a column to the left
			if(!defined($grid[$r_co][$c_co]) || $grid[$r_co][$c_co] eq ' ') {
				my $new_co = find_right_position($r_co);
				$c_co = $new_co if($new_co != -1); 
			}
			$i--;
		}
			
	} elsif($d eq "SOUTH") {
		while($i > 0 && $grid[$r_co+1][$c_co] ne '#') {
			$r_co++; # Move a row down
			if($r_co > scalar(@grid) || !defined($grid[$r_co][$c_co]) || $grid[$r_co][$c_co] eq ' ') {
				my $new_co = find_top_position($c_co);
				$r_co = $new_co if($new_co != -1); 
			}
			$i--;
		}
	} elsif($d eq "NORTH") {
		while($i > 0 && $grid[$r_co-1][$c_co] ne '#') {
			$r_co--; # Move a row up
			if($r_co < 0 || !defined($grid[$r_co][$c_co]) || $grid[$r_co][$c_co] eq ' ') {
				my $new_co = find_bottom_position($c_co);
				$r_co = $new_co if($new_co != -1); 
			}
			$i--;
		}

	} else { die "Weird 3\n"; }
	return ($r_co, $c_co);
}

sub rotate_clockwise {
	my $d = shift;
	return "SOUTH" if $d eq "EAST";
	return "WEST" if $d eq "SOUTH";
	return "NORTH" if $d eq "WEST";
	return "EAST" if $d eq "NORTH";
}

sub rotate_counterclockwise {
	my $d = shift;
	return "NORTH" if $d eq "EAST";
	return "EAST" if $d eq "SOUTH";
	return "SOUTH" if $d eq "WEST";
	return "WEST" if $d eq "NORTH";
}

sub find_bottom_position {
	my $c_co = shift;
	for(my $i = scalar(@grid) - 1; $i > -1; $i--) {
		return -1 if $grid[$i][$c_co] eq '#'; 
		if($grid[$i][$c_co] eq '.') {
			return $i;
		}
	}
	return -1;
}

sub find_top_position {
	my $c_co = shift;
	for(my $i = 0; $i < @grid; $i++) {
		return -1 if $grid[$i][$c_co] eq '#'; 
		if($grid[$i][$c_co] eq '.') {
			return $i;
		}
	}
	return -1;
}

sub find_right_position {
	my $r_co = shift;
	for(my $i = scalar(@{$grid[$r_co]}) - 1; $i > -1 ; $i--) {
		return -1 if $grid[$r_co][$i] eq '#'; 
		if($grid[$r_co][$i] eq '.') {
			return $i;
		}
	}
	return -1;
}

sub find_left_position {
	my $r_co = shift;
	for(my $i = 0; $i < @{$grid[$r_co]}; $i++) {
		return -1 if $grid[$r_co][$i] eq '#'; 
		if($grid[$r_co][$i] eq '.') {
			return $i;
		}
	}
	return -1;
}

sub find_top_left_position {
	for(my $i = 0; $i < @grid; $i++) {
		my $c_co = find_left_position($i);
		if($c_co > -1) {
			return ($i, $c_co);
		}
	}
}

sub parse_grid {
	my $row = 0;
	foreach(split /\n/, $_[0]) {
		last if ! length; # empty line between grid and path means we stop

		my $i = 0;
		foreach(split //) {
			$grid[$row][$i++] = $_;
		}
		$row++;
	}
}

sub parse_path {
	my $seen_empty_line = 0;
	foreach(split /\n/, $_[0]) {
		if(! length) {
			$seen_empty_line = 1;
			next;
		}
		if($seen_empty_line) {
			while(length) {
				if(/^(\d+)/) {
					push(@path, $1);
					s/^\d+//;
				} elsif(/^([RL])/) {
					push(@path, $1);
					s/^.//;
				} else {
					die "Weird 1\n";
				}
			}
		}
	}
	say "path: @path";
}

sub run_go_tests {
	my $input = <<HERE;
        ...#
  . . . . ##

1R
HERE
	x($input);
	ok($r_co == 0 && $c_co == 9, "Moved one position to the east");
	ok($direction eq "SOUTH", "Rotated clockwise to SOUTH");

	$input = <<HERE;
        ...#
  . . . . ##

10R
HERE
	x($input);
	ok($r_co == 0 && $c_co == 10, "We are stopped by a wall on our way");
	ok($direction eq "SOUTH", "Rotated clockwise to SOUTH");

	$input = <<HERE;
        ....
  . . . . ##

6R
HERE
	x($input);
	say "$r_co, $c_co";
	ok($r_co == 0 && $c_co == 10, "We wrap around back to the beginning.");
	ok($direction eq "SOUTH", "Rotated clockwise to SOUTH");

	$input = <<HERE;
        ....
  . . . ..##
..........
..........

5R5L
HERE
	x($input);
	say "$r_co, $c_co";
	ok($r_co == 1 && $c_co == 9, "We go 5 to the east (== 1 to the east) and then 5 down (== 1 down after wrapping)");
	ok($direction eq "EAST", "Rotated clockwise to SOUTH then counterclockwise back to EAST");

	$input = <<HERE;
        ....
  . . . ..##
..........
..........

RR2
HERE
	x($input);
	say "$r_co, $c_co";
	ok($r_co == 0 && $c_co == 10, "Going two west == two east");
	ok($direction eq "WEST", "Rotating from east 2x clockwise");

	$input = <<HERE;
        ....
  . . . ..##
..........
..........

RR3R2
HERE
	x($input);
	say "$r_co, $c_co";
	ok($r_co == 2 && $c_co == 9, "3 west and 2 north");
	ok($direction eq "NORTH", "Rotating from east 3x clockwise");

	$input = <<HERE;
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
HERE
	x($input);
	say "$r_co, $c_co";
	ok($r_co == 5 && $c_co == 7, "small input position");
	ok($direction eq "EAST", "small input direction");
	ok(calc($direction, $r_co, $c_co) == 6032, "small input sum");
}

sub run_func_tests {
	my $input = <<HERE;
        ...#
. . . . . ##

1R2L3R50L
HERE

	x($input);
	my ($r_co, $col_co) = find_top_left_position();
	ok($r_co == 0 && $col_co == 8, "Found top left position");

	$input = <<HERE;
        ####
  . . . . ##

1R2L3R50L
HERE

	x($input);
	($r_co, $col_co) = find_top_left_position();
	ok($r_co == 1 && $col_co == 2, "Finding top left when it's not on the first line");
	
	ok(rotate_clockwise("EAST") eq "SOUTH", "Rotating east clockwise becomes south");
	ok(rotate_clockwise("SOUTH") eq "WEST", "Rotating south clockwise becomes west");
	ok(rotate_clockwise("WEST") eq "NORTH", "Rotating west clockwise becomes north");
	ok(rotate_clockwise("NORTH") eq "EAST", "Rotating north clockwise becomes east");
	ok(rotate_counterclockwise("EAST") eq "NORTH", "Rotating east counterclockwise becomes north");
	ok(rotate_counterclockwise("SOUTH") eq "EAST", "Rotating south counterclockwise becomes east");
	ok(rotate_counterclockwise("WEST") eq "SOUTH", "Rotating west counterclockwise becomes south");
	ok(rotate_counterclockwise("NORTH") eq "WEST", "Rotating north counterclockwise becomes west");
}


sub run_parse_tests {
	#
	my $input = <<HERE;
        ...#
. . . . . ##

1R2L3R50L
HERE

	x($input);
	foreach my $r (@grid) {
		foreach(@{$r}) {
			print;
		}
		print "\n";
	}
	ok($path[1] eq 'R', "R is a single action to be done");
	ok($path[6] == 50, "Multiple digits are 1 logical number");
	ok($grid[0][4] eq ' ', "This is a space in the grid...");
	ok($grid[0][8] eq '.', "This is a dot in the grid...");
	ok($grid[0][11] eq '#', "This is an obstacle in the grid...");
	ok($grid[1][11] eq '#', "Multiple rows are supported.");
}

__END__

cols:
0123456789
    ...#   <--- row[0]
   ....... <--- row[1]
   ....... <--- row[2]

Only trick that I found, which was also in the sample input is that you don't move when wrapping if you hit a wall before you hit a dot; which is logical if you think about it.

..#..
..A..
.....
.....

R10

-> You should end up here:
..#..
.....
.....
..A..

Since the top column is a wall, you can't wrap around and just stay put.
