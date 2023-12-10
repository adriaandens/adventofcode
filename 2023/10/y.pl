use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my $debug = 0;
my @data = ();
my @map = ();
my @insides = ();
my @insides2 = ();
my $direction = '';
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

say "Map 1";
print_map(@insides);
say "Map 2";
print_map(@insides2);

@insides = fill_up_insides(@insides);
@insides2 = fill_up_insides(@insides2);

say "Map 1";
print_map(@insides);
say "Map 2";
print_map(@insides2);

say "Insides 1 has " . count_i(@insides) . " of Is";
say "Insides 1 has " . count_i(@insides2) . " of Is";

my $complex_loop = <<'HERE';
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
HERE
resett();
make_grid(split /\n/, $complex_loop);
find_s();
update_map_with_lengths_from_s($s_row, $s_col);
say "Map 1";
print_map(@insides);
say "Map 2";
print_map(@insides2);

@insides = fill_up_insides(@insides);
@insides2 = fill_up_insides(@insides2);

say "Map 1";
print_map(@insides);
say "Map 2";
print_map(@insides2);

say "Insides 1 has " . count_i(@insides) . " of Is";
say "Insides 1 has " . count_i(@insides2) . " of Is";

done_testing();
# Code
sub resett {
	@data = ();
	@map = ();
	@insides = ();
	@insides2 = ();
	$s_row = -1;
	$s_col = -1;
	$distance = 1;
}

sub make_grid {
	my $width = 0;
	my $height = 0;
	foreach (@_) {
		chomp;
		my @row = split //, $_;
		unshift @row, '.';
		push @row, '.';
		$width = scalar(@row);
		push @map, \@row;
		$height++;
	}
	my @first_row = split //, ('.' x $width);
	my @last_row = split //, ('.' x $width);
	unshift @map, \@first_row;
	push @map, \@last_row;
	foreach(0..$height+2) {
		my @r = split //, ('.' x $width);
		push @insides, \@r;
		my @s = split //, ('.' x $width);
		push @insides2, \@s;
	}
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
		# Bug: If I just wrote the distance value, I got '7' in a square that is also a valid symbol and that would screw things, so just make it a string...
		$map[$r][$c] = 'C';
		$insides[$r][$c] = 'C';
		$insides2[$r][$c] = 'C';
		# Bug: This used to be above the 'C' updates but that leaves an I where there shouldn't be, we need to make sure the last one in the chain is also correctly tagged with Chain.
		last if $good_neighbour == -1;
		$insides[$r-1][$c] = 'I' if $direction eq 'right' && $insides[$r-1][$c] ne 'C';
		$insides2[$r+1][$c] = 'I' if $direction eq 'right' && $insides2[$r+1][$c] ne 'C';
		$insides[$r+1][$c] = 'I' if $direction eq 'left' && $insides[$r+1][$c] ne 'C';
		$insides2[$r-1][$c] = 'I' if $direction eq 'left' && $insides2[$r-1][$c] ne 'C';
		$insides[$r][$c-1] = 'I' if $direction eq 'up' && $insides[$r][$c-1] ne 'C';
		$insides2[$r][$c+1] = 'I' if $direction eq 'up' && $insides2[$r][$c+1] ne 'C';
		$insides[$r][$c+1] = 'I' if $direction eq 'down' && $insides[$r][$c+1] ne 'C';
		$insides2[$r][$c-1] = 'I' if $direction eq 'down' && $insides2[$r][$c-1] ne 'C';
		$r = $good_neighbour->{row};
		$c = $good_neighbour->{col};
		$distance++;
	}
	say "We finished updating";
	return $distance;
}

sub print_map {
	local $" = '';
	foreach my $r (@_) {
		say "@{$r}";
	}
}

sub in {
	my ($el, @l) = @_;
	return 1 if grep { $el eq $_ } @l;
	return 0;
}

sub find_good_neighbour {
	my ($r, $c) = @_;
	my $current_pipe = $map[$r][$c];
	#say "Current pipe is $current_pipe";

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
		$direction = 'up';
	} elsif($current_pipe eq '|' && in($bot_pipe, @vert_bot)) {
		$good_neighbour{row} = $r+1;
		$good_neighbour{col} = $c;
		$direction = 'down';
	} elsif($current_pipe eq 'F' && in($bot_pipe, @vert_bot)) {
		$good_neighbour{row} = $r+1;
		$good_neighbour{col} = $c;
		$direction = 'down';
	} elsif($current_pipe eq 'F' && in($right_pipe, @hor_right)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c+1;
		$direction = 'right';
	} elsif($current_pipe eq '7' && in($left_pipe, @hor_left)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c-1;
		$direction = 'left';
	} elsif($current_pipe eq '7' && in($bot_pipe, @vert_bot)) {
		$good_neighbour{row} = $r+1;
		$good_neighbour{col} = $c;
		$direction = 'down';
	} elsif($current_pipe eq 'L' && in($top_pipe, @vert_top)) {
		$good_neighbour{row} = $r-1;
		$good_neighbour{col} = $c;
		$direction = 'up';
	} elsif($current_pipe eq 'L' && in($right_pipe, @hor_right)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c+1;
		$direction = 'down';
	} elsif($current_pipe eq 'J' && in($top_pipe, @vert_top)) {
		$good_neighbour{row} = $r-1;
		$good_neighbour{col} = $c;
		$direction = 'up';
	} elsif($current_pipe eq 'J' && in($left_pipe, @hor_left)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c-1;
		$direction = 'left';
	} elsif($current_pipe eq '-' && in($left_pipe, @hor_left)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c-1;
		$direction = 'left';
	} elsif($current_pipe eq '-' && in($right_pipe, @hor_right)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c+1;
		$direction = 'right';
	} elsif($current_pipe eq 'S' && in($right_pipe, @hor_right)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c+1;
		$direction = 'right';
	} elsif($current_pipe eq 'S' && in($left_pipe, @hor_left)) {
		$good_neighbour{row} = $r;
		$good_neighbour{col} = $c-1;
		$direction = 'left';
	} elsif($current_pipe eq 'S' && in($top_pipe, @vert_top)) {
		$good_neighbour{row} = $r-1;
		$good_neighbour{col} = $c;
		$direction = 'up';
	} elsif($current_pipe eq 'S' && in($bot_pipe, @vert_bot)) {
		$good_neighbour{row} = $r+1;
		$good_neighbour{col} = $c;
		$direction = 'down';
	} else {
		return -1; # We have looped
	}

	return \%good_neighbour;
}

sub fill_up_insides {
	my $changed = 1;
	while($changed) {
		$changed = 0;
		for(my $r = 1; $r < scalar(@_)-1; $r++) {
			for(my $c = 1; $c < scalar(@{$_[0]})-1; $c++) {
				if($_[$r][$c] eq 'I') {
					say "($r, $c) is an I";
					if($_[$r-1][$c] eq '.') {
						$_[$r-1][$c] = 'I';
						$changed = 1;
					} elsif($_[$r+1][$c] eq '.') {
						$_[$r+1][$c] = 'I';
						$changed = 1;
					} elsif($_[$r][$c-1] eq '.') {
						$_[$r][$c-1] = 'I';
						$changed = 1;
					} elsif($_[$r][$c+1] eq '.') {
						$_[$r][$c+1] = 'I';
						$changed = 1;
					#} elsif($_[$r-1][$c-1] eq '.') {
					#	$_[$r-1][$c-1] = 'I';
					#	$changed = 1;
					#} elsif($_[$r-1][$c+1] eq '.') {
					#	$_[$r-1][$c+1] = 'I';
					#	$changed = 1;
					#} elsif($_[$r+1][$c-1] eq '.') {
					#	$_[$r+1][$c-1] = 'I';
					#	$changed = 1;
					#} elsif($_[$r+1][$c+1] eq '.') {
					#	$_[$r+1][$c+1] = 'I';
					#	$changed = 1;
					}
				}
			}
		}
	}
	return @_;
}

sub count_i {
	my $t = 0;
	for(my $r = 0; $r < scalar(@_); $r++) {
		for(my $c = 0; $c < scalar(@{$_[0]}); $c++) {
			if($_[$r][$c] eq 'I') {
				$t++;
			}
		}
	}
	return $t;
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
@insides = fill_up_insides(@insides);
@insides2 = fill_up_insides(@insides2);

say "Map 1";
print_map(@insides);
say "Map 2";
print_map(@insides2);

say "Insides 1 has " . count_i(@insides) . " of Is";
say "Insides 1 has " . count_i(@insides2) . " of Is";

# Numbers
# 313: too low

__DATA__
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
