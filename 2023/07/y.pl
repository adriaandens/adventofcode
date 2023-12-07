use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my $debug = 0;

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
	"T" => 10,
	"9" => 9,
	"8" => 8,
	"7" => 7,
	"6" => 6,
	"5" => 5,
	"4" => 4,
	"3" => 3,
	"2" => 2,
	"J" => 1
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

is(gettype("JAAAA 123"), "five of a kind", "Joker becomes an A");
is(gettype("JJAAA 123"), "five of a kind", "Joker becomes an A, giving AAAAA");
is(gettype("AAAAK 123"), "four of a kind", "No joker");
is(gettype("JJJJA 123"), "five of a kind", "Joker is the four of a kind");
is(gettype("JJJAA 123"), "five of a kind", "Joker becomes an A");
is(gettype("AAAKK 123"), "full house", "No joker, it stays a full house");

is(gettype("JJJAK 123"), "four of a kind", "Joker becomes an A");
is(gettype("AAAKJ 123"), "four of a kind", "Joker becomes an A");
is(gettype("AAAKT 123"), "three of a kind", "No joker");
is(gettype("AAJJK 123"), "four of a kind", "Joker becomes an A");
is(gettype("AAKKJ 123"), "full house", "Joker becomes an A");
is(gettype("AAKKT 123"), "two pair", "No joker");

is(gettype("AAT9J 123"), "three of a kind", "One joker gives a three of a kind");
is(gettype("JJAT9 123"), "three of a kind", "JJAT9 -> AAAT9");
is(gettype("AAQT9 123"), "one pair", "no joker");

is(gettype("AKT9J 123"), "one pair", "joker becomes a A");

my $type = gettype($data[0]);
push @{$types{$type}}, $data[0];
is(scalar(@{$types{"one pair"}}), 1, "One pair array has now one element");
push @{$types{gettype($data[1])}}, $data[1];
push @{$types{gettype($data[2])}}, $data[2];
push @{$types{gettype($data[3])}}, $data[3];
push @{$types{gettype($data[4])}}, $data[4];
is(scalar(@{$types{"one pair"}}), 1, "One pair array has now one element");
is(scalar(@{$types{"two pair"}}), 1, "Two pair array has only one element");
is(scalar(@{$types{"four of a kind"}}), 3, "Four of a kind has three elements");

push @sorted, sort_and_rank($types{"high card"});
push @sorted, sort_and_rank($types{"one pair"});
push @sorted, sort_and_rank($types{"two pair"});
push @sorted, sort_and_rank($types{"three of a kind"});
push @sorted, sort_and_rank($types{"full house"});
push @sorted, sort_and_rank($types{"four of a kind"});
push @sorted, sort_and_rank($types{"five of a kind"});

is($sorted[0], 765, "Lowest rank is 765");
is($sorted[1], 28, "Second lowest rank is 28");
is($sorted[2], 684, "Third lowest rank is 684");
is($sorted[3], 483, "Fourth lowest rank is 483");
is($sorted[4], 220, "Fifth lowest rank is 220");

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
		my $joker = 0;
		foreach(keys(%groups)) {
			if($groups{$_} == 4) {
				$fourofakind = 1;
			}
			if($_ eq "J") {
				$joker = $groups{$_};
			}
		}
		if($fourofakind && $joker) {
			return "five of a kind"; # Upgraded bc of joker
		} elsif($fourofakind) {
			return "four of a kind";
		} elsif($joker) {
			# We have 3 of one, and 2 of another, with one being the joker
			return "five of a kind"; 
		} else {
			return "full house";
		}
		die "Unreachable ????";
	}
	if(keys(%groups) == 3) { # Either three of a kind or two pair
		my $threeofakind = 0;
		my $joker = 0;
		foreach(keys(%groups)) {
			if($groups{$_} == 3) {
				$threeofakind = 1;
			}
			if($_ eq "J") {
				$joker = $groups{$_}; # Set to amount of jokers, either 1 or 2...
			}
		}

		if($threeofakind && $joker == 3) {
			return "four of a kind";
		} elsif($threeofakind && $joker == 1) {
			return "four of a kind";
		} elsif($threeofakind) {
			return "three of a kind";
		} elsif($joker == 2) { # Two pair, and the joker is one
			return "four of a kind"; #the joker can also be 1 pair (JJAA1)
		} elsif($joker == 1) { # The joker was not in the pair
			return "full house"; # AAKKJ becomes AAKKA, a full house
		} else {
			return "two pair";
		}
		die "Unreachable ??";
	}
	if(keys(%groups) == 4) {
		my $joker = 0;
		foreach(keys(%groups)) {
			if($_ eq "J") {
				$joker = $groups{$_};
			}
		}

		if($joker == 2) { # The joker is the pair
			return "three of a kind";
		} elsif($joker == 1) { # The joker is not the pair
			return "three of a kind";
		} else {
			return "one pair";
		}

		die "Unreachable ?";
	}

	my $joker = 0;
	foreach(keys(%groups)) {
		if($_ eq "J") {
			$joker = $groups{$_};
		}
	}
	return "one pair" if $joker;

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

exit(0) if $debug == 1;
resett();
@data = <STDIN>;
say "Solution: " . x(@data);

# Numbers
# 245203398: too low -> made a few mistakes, so added tests for each case and fixed all the bugs (i made 4 logical bugs)
# 245576185: correct

__DATA__
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
