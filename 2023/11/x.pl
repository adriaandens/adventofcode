use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my $debug = 0;
my @coordinates = ();
my $rowcount = 0;
my $colcount = 0;

# Tests
make_grid(<DATA>);
is($rowcount, 10, "10 rows");
is($colcount, 10, "10 cols");
say "Coordinates: " . print_co(@coordinates);
expand_universe();
say "Coordinates: " . print_co(@coordinates);

say "Total distance: " . total_distance(@coordinates);

done_testing();
# Code
sub resett {
	@coordinates = ();
}

sub make_grid {
	my $r = 0;
	foreach (@_) {
		chomp;
		my @row = split //, $_;
		my $c = 0;
		foreach my $i (@row) {
			if($i eq '#') {
				my %co = ("row" => $r, "col" => $c);
				push @coordinates, \%co;
			}
			$c++;
		}
		$colcount = $c;
		$r++;
	}
	$rowcount = $r;
}

sub expand_universe {
	my %cols_with_galaxies = ();
	my $prev_co = undef;
	my $increase_row = 0;
	foreach my $co (@coordinates) {
		$cols_with_galaxies{$co->{col}}++;

		# Bug: the prev_co has already received the increase, so to check if 
		# we had an empty row, we need to compare it with the original row number.
		if(defined($prev_co) && $prev_co->{row} - $increase_row < $co->{row} - 1) {
			say "we missed a row!";
			say print_co($prev_co);
			$increase_row++;
		}
		if($increase_row) {
			$co->{row} += $increase_row;
		}
		$prev_co = $co;
	}

	if(keys(%cols_with_galaxies) != $colcount) { # There are cols without galaxies
		my $i = 0;
		my $increase_col = 0;
		while($i < $colcount) {
			if(!$cols_with_galaxies{$i}) {
				say "On col $i, there is no galaxy";
				foreach my $co (@coordinates) {
					# Bug: Same bug as for rows, but for cols, compare with OG coordinates
					if($co->{col} - $increase_col > $i) {
						$co->{col}++;
					}
				}
				$increase_col++;
			}
			$i++;
		}
	}
}

sub total_distance {
	my $distance = 0;
	for(my $i = 0; $i < scalar(@coordinates); $i++) {
		for(my $j = $i+1; $j < scalar(@coordinates); $j++) {
			$distance += calculate_manhattan($coordinates[$i], $coordinates[$j]);
		}
	}
	return $distance;
}

sub in {
	my ($el, @l) = @_;
	return 1 if grep { $el eq $_ } @l;
	return 0;
}

sub print_co {
	my $s = '';
	foreach my $co (@_) {
		$s .= "(" . $co->{row} . ", " . $co->{col} . "), ";
	}
	return $s;
}

sub calculate_manhattan {
	my ($co1, $co2) = @_;
	return abs($co1->{row} - $co2->{row}) + abs($co1->{col} - $co2->{col});
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
expand_universe();
say "Total distance: " . total_distance(@coordinates);

# Numbers

__DATA__
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
