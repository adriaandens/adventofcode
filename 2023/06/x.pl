use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my $debug = 0;
my @time = ();
my @distance = ();

# Tests
my $times = <DATA>;
my $distances = <DATA>;
@time = parse_line($times);
@distance = parse_line($distances);

is(scalar(@time), 3, "3 times in small input");
is($time[1], 15, "The second time is 15");
is(scalar(@distance), 3, "3 distances in small input");
is($distance[2], 200, "The third distance is 200");

is(round($time[0], $distance[0]), 4, "Four ways of winning");
is(x(), 288, "Solution is 288");
done_testing();

# Code
sub resett {
	@time = ();
	@distance = ();
}

sub parse_line {
	$_ = shift;
	say "Line: $_";
	my @numbers = m/(\d+)/g;
	return @numbers;
}

sub round {
	my ($total_time, $record) = @_;

	my $wins = 0;
	foreach my $time_holding (0..$total_time) {
		my $speed = $time_holding * 1;
		say "Speed is $speed";
		my $time_left = $total_time - $time_holding;
		my $distance_covered = $time_left * $speed;
		say "Distance covered at $speed during $time_left milliseconds is $distance_covered millimeters";

		$wins++ if $distance_covered > $record;
	}
	
	return $wins;
}

sub x {
	my @numbers = ();
	foreach my $i (0..scalar(@time)-1) {
		my $wins = round($time[$i], $distance[$i]);
		push @numbers, $wins;
	}
	my $total = 1;
	$total *= $_ foreach @numbers;

	return $total;
}

exit(0) if $debug == 1;
resett();
$times = <STDIN>;
$distances = <STDIN>;
@time = parse_line($times);
@distance = parse_line($distances);
say "Solution: " . x();

# Numbers

__DATA__
Time:      7  15   30
Distance:  9  40  200
