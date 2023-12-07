use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my $debug = 1;

my %types = (
	"five of a kind" => [],
	"four of a kind" => [],
	"full house" => [],
	"three of a kind" => [],
	"two pair" => [],
	"one pair" => [],
	"high card" => []
);
my @sorted = ();
my %order = (
	"A" => 14,
	"K" => 13,
	"Q" => 12,
	"J" => 11,
	"T" => 10,
	"9" => 9,
	"8" => 8,
	"7" => 7,
	"6" => 6,
	"5" => 5,
	"4" => 4,
	"3" => 3,
	"2" => 2
);

# Tests
my @data = <DATA>;
is(gettype($data[0]), "one pair", "32T3K has one pair (33)");
is(gettype("AAAAA 123"), "five of a kind", "AAAAA is five of a kind");
is(gettype("AA8AA 123"), "four of a kind", "AA8AA is four of a kind");
is(gettype("23332 123"), "full house", "23332 is a full house");
is(gettype("TTT98 123"), "three of a kind", "TTT98 is a three of a kind");
is(gettype("23432 123"), "two pair", "23432 is a two pair");
is(gettype("A23A4 123"), "one pair", "A23A4 is a one pair");
is(gettype("23456 123"), "high card", "23456 is a high card"); 

my $type = gettype($data[0]);
push @{$types{$type}}, $data[0];
is(scalar(@{$types{"one pair"}}), 1, "One pair array has now one element");
push @{$types{gettype($data[1])}}, $data[1];
push @{$types{gettype($data[2])}}, $data[2];
push @{$types{gettype($data[3])}}, $data[3];
push @{$types{gettype($data[4])}}, $data[4];
is(scalar(@{$types{"one pair"}}), 1, "One pair array has now one element");
is(scalar(@{$types{"two pair"}}), 2, "Two pair array has now two elements");
is(scalar(@{$types{"three of a kind"}}), 2, "Three of a kind has two elements");

push @sorted, sort_and_rank($types{"high card"});
push @sorted, sort_and_rank($types{"one pair"});
push @sorted, sort_and_rank($types{"two pair"});
push @sorted, sort_and_rank($types{"three of a kind"});
push @sorted, sort_and_rank($types{"full house"});
push @sorted, sort_and_rank($types{"four of a kind"});
push @sorted, sort_and_rank($types{"five of a kind"});

is($sorted[0], 765, "Lowest rank is 765");
is($sorted[1], 220, "Second lowest rank is 220");
is($sorted[2], 28, "Third lowest rank is 28");
is($sorted[3], 684, "Fourth lowest rank is 684");
is($sorted[4], 483, "Fifth lowest rank is 483");

done_testing();

# Code
sub resett {
	@data = ();
	@sorted = ();
	%types = (
		"five of a kind" => [],
		"four of a kind" => [],
		"full house" => [],
		"three of a kind" => [],
		"two pair" => [],
		"one pair" => [],
		"high card" => []
	);
}

sub sort_and_rank {
	$_ = shift;
	my @inputs = @{$_};
	my @input_sorted = sort sorter @inputs;
	my @ranks = map { / (\d+)/; $1 } @input_sorted;
	return @ranks;
}

sub sorter {
	my ($a_cardstr) = $a =~ m/^(\w+)/;
	my ($b_cardstr) = $b =~ m/^(\w+)/;

	return 0 if $a_cardstr eq $b_cardstr;

	my @acards = split //, $a_cardstr;
	my @bcards = split //, $b_cardstr;
	foreach(0..4) {
		next if $acards[$_] eq $bcards[$_];
		my $numa = $order{$acards[$_]};
		my $numb = $order{$bcards[$_]};
		return 1 if $numa > $numb;
		return -1 if $numa < $numb;
	}
}

sub gettype {
	my $line = shift;
	my ($cardstr, $bet) = $line =~ m/(\w+) (\d+)/;
	
	my @cards = split //, $cardstr;
	my %groups = ();
	map { $groups{$_}++ } @cards;
	
	return "five of a kind" if keys(%groups) == 1;
	if(keys(%groups) == 2) { # Either full house or 4 of a kind
		my $fourofakind = 0;
		foreach(keys(%groups)) {
			if($groups{$_} == 4) {
				$fourofakind = 1;
			}
		}
		return "four of a kind" if $fourofakind;
		return "full house";
	}
	if(keys(%groups) == 3) { # Either three of a kind or two pair
		my $threeofakind = 0;
		foreach(keys(%groups)) {
			if($groups{$_} == 3) {
				$threeofakind = 1;
			}
		}
		return "three of a kind" if $threeofakind;
		return "two pair";
	}
	return "one pair" if keys(%groups) == 4;
	return "high card";
}

sub x {
	foreach(@_) {
		push @{$types{gettype($_)}}, $_;
	}
	
	push @sorted, sort_and_rank($types{"high card"});
	push @sorted, sort_and_rank($types{"one pair"});
	push @sorted, sort_and_rank($types{"two pair"});
	push @sorted, sort_and_rank($types{"three of a kind"});
	push @sorted, sort_and_rank($types{"full house"});
	push @sorted, sort_and_rank($types{"four of a kind"});
	push @sorted, sort_and_rank($types{"five of a kind"});

	say "@sorted";
	my $i = 1;
	my $total = 0;
	foreach(@sorted) {
		$total += $_ * $i;
		$i++;
	}
	return $total;
}

exit(0) if $debug == 0;
resett();
@data = <STDIN>;
say "Solution: " . x(@data);

# Numbers

__DATA__
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
