use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests

# Tests
my @data = <DATA>;
is(x($data[0]), 8, "Four winning numbers give 8");
is(x($data[1]), 2, "Game two gives 2");
is(x($data[2]), 2, "Game 3 gives 2");
is(x($data[3]), 1, "Game 4 gives 1");
is(x($data[4]), 0, "Game 5 gives 0");
is(x($data[5]), 0, "Game 6 gives 0");
is(x('Card 7: 1 2 3 4 5 | 5 4 3 2 1'), 16, "Game 7 gives 16");

done_testing();

# Code
sub x {
	$_ = shift;
	my ($card_number, $winning, $ours) = m/Card\s+(\d+): ([^\|]+) \| (.*)$/;
	my @winning_numbers = $winning =~ m/(\d+)/g;
	say "Winning numbers: @winning_numbers";
	my %w = ();
	$w{$_} = 1 foreach @winning_numbers;
	my @our_numbers = $ours =~ m/(\d+)/g;
	say "Our numbers: @our_numbers";
	my $good_numbers = grep { $w{$_} } @our_numbers;
	say "We have $good_numbers good numbers";
	
	return 0 if $good_numbers == 0;
	return 2**($good_numbers-1);
}

@data = <STDIN>;
my $sum = 0;
foreach(@data) {
	$sum += x($_);
}
say "Solution: " . $sum;


# Numbers
#11595: wrong :(

__DATA__
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
