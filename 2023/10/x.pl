use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my $debug = 0;
my @data = ();
my @map = ();
my $s_row = -1;
my $s_col = -1;
my $distance = 1;


# Tests
make_grid(<DATA>);

is($map[1][1], '-', 'First one is -');
is($map[2][2], 'S', 'Start is at (1, 1)');

find_s();
is($s_row, 2, 'S is on row 1');
is($s_col, 2, 'S is on col 1');

update_map_with_lengths_from_s($s_row, $s_col);
say "Distance is $distance";
is($distance / 2, 4, "Furthest point is 4");

my $complex_loop = <<'HERE';
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
HERE
resett();
make_grid(split /\n/, $complex_loop);
find_s();
is($s_row, 3, "S is on row 3");
is($s_col, 1, "S is on col 1");
update_map_with_lengths_from_s($s_row, $s_col);
say "Distance is $distance";



done_testing();
# Code
sub resett {
	@data = ();
	@map = ();
	$s_row = -1;
	$s_col = -1;
	$distance = 1;
}

sub make_grid {
	my $width = 0;
	foreach (@_) {
		chomp;
		my @row = split //, $_;
		unshift @row, '.';
		push @row, '.';
		$width = scalar(@row);
		push @map, \@row;
	}
	my @first_row = split //, ('.' x $width);
	my @last_row = split //, ('.' x $width);
	unshift @map, \@first_row;
	push @map, \@last_row;
}

sub find_s {
	my $i = 0;
	foreach my $r (@map) {
		my $j = 0;
		foreach my $c (@{$r}) {
			if($c eq 'S') {
				$s_row = $i;
				$s_col = $j;
			}
			$j++;
		}
		$i++;
	}
}

sub update_map_with_lengths_from_s {
	my ($r, $c) = @_;
	while($distance < 2 || $r != $s_row || $c != $s_col) {
		my $good_neighbour = find_good_neighbour($r, $c);
		last if $good_neighbour == -1;
		say "Good neighbour is ($good_neighbour->{row}, $good_neighbour->{col})";
		# Bug: If I just wrote the distance value, I got '7' in a square that is also a valid symbol and that would screw things, so just make it a string...
		$map[$r][$c] = 'distance ' . $distance;
		$r = $good_neighbour->{row};
		$c = $good_neighbour->{col};
		$distance++;
	}
	say "We finished updating";
	return $distance;
}

sub in {
	my ($el, @l) = @_;
	return 1 if grep { $el eq $_ } @l;
	return 0;
}

sub find_good_neighbour {
	my ($r, $c) = @_;
	my $current_pipe = $map[$r][$c];
	say "Current pipe is $current_pipe";

	# Good neighbours
	my @vert_top = ('|', 'F', '7');
	my @vert_bot = ('|', 'L', 'J');
	my @hor_left = ('-', 'F', 'L');
	my @hor_right = ('-', 'J', '7');


	my %good_neighbour = ("row" => -1, "col" => -1);
	my $top_pipe = $map[$r-1][$c];
	my $bot_pipe = $map[$r+1][$c];
	my $left_pipe = $map[$r][$c-1];
	my $right_pipe = $map[$r][$c+1];
	if($current_pipe eq '|' && in($top_pipe, @vert_top)) {
		$good_neighbour{row} = $r-1;
		$good_neighbour{col} = $c;
	} elsif($current_pipe eq '|' && in($bot_pipe, @vert_bot)) {
		$good_neighbour{row} = $r+1;
		$good_neighbour{col} = $c;
	} elsif($current_pipe eq 'F' && in($bot_pipe, @vert_bot)) {
		$good_neighbour{row} = $r+1;
		$good_neighbour{col} = $c;
	} elsif($current_pipe eq 'F' && in($right_pipe, @hor_right)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c+1;
	} elsif($current_pipe eq '7' && in($left_pipe, @hor_left)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c-1;
	} elsif($current_pipe eq '7' && in($bot_pipe, @vert_bot)) {
		$good_neighbour{row} = $r+1;
		$good_neighbour{col} = $c;
	} elsif($current_pipe eq 'L' && in($top_pipe, @vert_top)) {
		$good_neighbour{row} = $r-1;
		$good_neighbour{col} = $c;
	} elsif($current_pipe eq 'L' && in($right_pipe, @hor_right)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c+1;
	} elsif($current_pipe eq 'J' && in($top_pipe, @vert_top)) {
		$good_neighbour{row} = $r-1;
		$good_neighbour{col} = $c;
	} elsif($current_pipe eq 'J' && in($left_pipe, @hor_left)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c-1;
	} elsif($current_pipe eq '-' && in($left_pipe, @hor_left)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c-1;
	} elsif($current_pipe eq '-' && in($right_pipe, @hor_right)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c+1;
	} elsif($current_pipe eq 'S' && in($right_pipe, @hor_right)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c+1;
	} elsif($current_pipe eq 'S' && in($left_pipe, @hor_left)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c-1;
	} elsif($current_pipe eq 'S' && in($top_pipe, @vert_top)) {
		$good_neighbour{row} = $r-1;
		$good_neighbour{col} = $c;
	} elsif($current_pipe eq 'S' && in($bot_pipe, @vert_bot)) {
		$good_neighbour{row} = $r+1;
		$good_neighbour{col} = $c;
	} else {
		return -1; # We have looped
	}

	return \%good_neighbour;
}

sub x {
	my $sum = 0;
	foreach(@_) {
		$sum += round($_);
	}
	return $sum;
}

exit(0) if $debug == 1;
resett();
make_grid(<STDIN>);
find_s();
update_map_with_lengths_from_s($s_row, $s_col);
say "Distance is $distance";
say "Solution: " . ($distance / 2);

# Numbers

__DATA__
-L|F7
7S-7|
L|7||
-L-J|
L|-JF
