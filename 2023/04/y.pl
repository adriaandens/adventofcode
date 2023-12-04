use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my $amount_of_original_cards = 6;
my %memoization = ();
my %cards = ();


# Tests
my @data = <DATA>;
is(z(@data), 30, "We get 30 cards");

done_testing();

# Code
sub z {
	$cards{$_} = 1 foreach 1..$amount_of_original_cards;
	my $total = 0;
	my $i = 1;
	foreach my $og_card (@_) {
		my $good = x($og_card);
		say "Card $i has $good good numbers";
		say "I have $cards{$i} of card $i";

		$total += $cards{$i};

		# X good numbers means card i+1 .. i+x
		foreach($i+1..$i+$good) {
			$cards{$_} += $cards{$i};
		}		

		$i++;
	}

	return $total;
}

sub x {
	$_ = shift;
	my ($card_number, $winning, $ours) = m/Card\s+(\d+): ([^\|]+) \| (.*)$/;
	return $memoization{$card_number} if exists($memoization{$card_number});

	my @winning_numbers = $winning =~ m/(\d+)/g;
	my %w = ();
	$w{$_} = 1 foreach @winning_numbers;
	my @our_numbers = $ours =~ m/(\d+)/g;
	my $good_numbers = grep { $w{$_} } @our_numbers;

	$memoization{$card_number} = $good_numbers;
	
	return $good_numbers;
}

@data = <STDIN>;
$amount_of_original_cards = 199;
%memoization = ();
%cards = ();
say "Solution: " . z(@data);


# Numbers
# 5387984 wrong -> didn't reset my global vars :')

__DATA__
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
