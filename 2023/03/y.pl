use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my @grid = ();

# Tests
my @data = <DATA>;
is(x(@data), 467835, "sample input gives 467835");
@grid = ();

done_testing();

# Code
sub x {
	my @lines = @_;

	my $grid_width = 0;
	my $grid_length = scalar(@lines);
	say "grid length $grid_length";
	foreach my $l (@lines) {
		chomp($l);
		my @line = split //, $l;
		$grid_width = scalar(@line);
		push @line, '.';
		unshift @line, '.';
		push @grid, \@line;
	}
	my $fake_line = '.' x ($grid_width + 2);
	my @fake = split //, $fake_line;
	push @grid, \@fake;
	unshift @grid, \@fake;

	# Walk the grid
	my @engine_parts = ();
	my %gears = ();
	my ($r, $c) = (1, 1);
	while($r <= $grid_length) {
		$c = 1; # Reset column

		my $inside_number = 0;
		my $symbol_found = 0;
		my $asterisk_found = 0;
		my %gears_found = ();
		my $number_value = '';
		while($c <= $grid_width) { # The bug!
			say "($r, $c) - " . $grid[$r][$c];
			my $v = $grid[$r][$c];
			if($v =~ /\d/) {
				$number_value .= $v;
				if($inside_number == 0) {
					$inside_number = 1;
					$symbol_found = 0;
				}
				if(symbol_adjacent($r, $c)) {
					$symbol_found = 1;				
				}
				if(asterisk_adjacent($r, $c)) {
					my $location = asterisk_adjacent($r, $c);
					say "Location of gear: $location";
					$gears_found{$location} = 1;
					$asterisk_found = 1;
				}
			} else { #elsif($c =~ /\./) {
				if($inside_number == 1) { # We are now passed the number
					$inside_number = 0;
					if($symbol_found == 1) {
						push @engine_parts, $number_value;
					}
					if($asterisk_found == 1) {
						foreach my $g (keys(%gears_found)) {
							if(!exists($gears{$g})) {
								my @vals = ($number_value);
								$gears{$g} = \@vals;
							} else {
								push @{$gears{$g}}, $number_value;
							}
						}
					}
					$number_value = '';
					$symbol_found = 0;
					%gears_found = ();
					$asterisk_found = 0;
				}
			}
			$c++;
		}
		# The BUG: if our number is all the way at the end, we need to still
		# make sure we add it to the engine parts
		if($inside_number == 1 && $symbol_found == 1) {
			push @engine_parts, $number_value;
			if($asterisk_found == 1) {
				foreach my $g (keys(%gears_found)) {
					if(!exists($gears{$g})) {
						my @vals = ($number_value);
						$gears{$g} = \@vals;
					} else {
						push @{$gears{$g}}, $number_value;
					}
				}
			}
		}

		$r++; # Go to next row
	}

	my @gear_locations = keys(%gears);
	say "Gears found: @gear_locations";

	my $sum = 0;
	foreach my $gl (@gear_locations) {
		my @numbahs = @{$gears{$gl}};
		if(scalar(@numbahs) == 2) {
			say "Gear $gl has 2 adjacent numbers";
			$sum += ($numbahs[0] * $numbahs[1]);
		}
	}
	return $sum;
}

sub symbol_adjacent {
	my ($r, $c) = @_;
	return 1 if $grid[$r-1][$c-1] !~ /[\d\.]/;
	return 1 if $grid[$r-1][$c] !~ /[\d\.]/;
	return 1 if $grid[$r-1][$c+1] !~ /[\d\.]/;
	return 1 if $grid[$r][$c-1] !~ /[\d\.]/;
	return 1 if $grid[$r][$c] !~ /[\d\.]/; # Actually not needed
	return 1 if $grid[$r][$c+1] !~ /[\d\.]/;
	return 1 if $grid[$r+1][$c-1] !~ /[\d\.]/;
	return 1 if $grid[$r+1][$c] !~ /[\d\.]/;
	return 1 if $grid[$r+1][$c+1] !~ /[\d\.]/;
}

sub asterisk_adjacent {
	my ($r, $c) = @_;
	return ($r-1) . "-" . ($c-1) if $grid[$r-1][$c-1] =~ /[\*]/;
	return ($r-1) . "-" . $c if $grid[$r-1][$c] =~ /[\*]/;
	return ($r-1) . "-" . ($c+1) if $grid[$r-1][$c+1] =~ /[\*]/;
	return $r . "-" . ($c-1) if $grid[$r][$c-1] =~ /[\*]/;
	return $r . "-" . $c if $grid[$r][$c] =~ /[\*]/; # Actually not needed
	return $r . "-" . ($c+1) if $grid[$r][$c+1] =~ /[\*]/;
	return ($r+1) . "-" . ($c-1) if $grid[$r+1][$c-1] =~ /[\*]/;
	return ($r+1) . "-" . $c if $grid[$r+1][$c] =~ /[\*]/;
	return ($r+1) . "-" . ($c+1) if $grid[$r+1][$c+1] =~ /[\*]/;
}

@grid = ();
@data = <STDIN>;
say "Solution: " . x(@data);


# Numbers after bugfix
# 76228368 too low
# 76504829 -> after update to bugfix part

__DATA__
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
