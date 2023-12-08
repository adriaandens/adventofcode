use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my $debug = 0;
my @pattern = ();
my %map = ();

# Tests
parse_input(<DATA>);
is($pattern[0], 'R', "R is first step");
is($pattern[1], 'L', "L is second step");

is($map{AAA}->{L}, "BBB", "AAA's left is BBB");
is($map{CCC}->{R}, "GGG", "CCC's right is GGG");

is(x(), 2, "We reach Z in 2 steps");
done_testing();

# Code
sub resett {
	@pattern = ();
	%map = ();
}

sub parse_input {
	my @lines = @_;
	my $steps = $lines[0];
	chomp($steps);
	@pattern = split //, $steps;

	foreach(2..scalar(@lines)-1) {
		my ($node, $left, $right) = $lines[$_] =~ /(\w+)\s+=\s+\((\w+),\s+(\w+)\)/;
		my %n = ("L" => $left, "R" => $right);
		$map{$node} = \%n;	
	}
}

sub x {
	my $steps = 0;
	my $current_node = 'AAA';
	while($current_node ne 'ZZZ') {
		say "Current node is $current_node";
		my $left_or_right = $pattern[$steps % scalar(@pattern)];
		say "We are at step $steps, so take $left_or_right";
		my $take = $map{$current_node}->{$left_or_right};
		$current_node = $take;
		$steps++;
	}

	return $steps;
}

exit(0) if $debug == 1;
resett();
parse_input(<STDIN>);
say "Solution: " . x();

# Numbers

__DATA__
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
