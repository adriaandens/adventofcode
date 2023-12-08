use strict;
use warnings;
use Test::More;
use feature 'say';
use ntheory qw(lcm);

# Global vars before any call in the tests
my $debug = 0;
my @pattern = ();
my %map = ();
my @nodes = ();

# Tests
parse_input(<DATA>);
is($pattern[0], 'L', "L is first step");
is($pattern[1], 'R', "R is second step");

is($map{"11A"}->{L}, "11B", "11A's left is 11B");
is($map{"11Z"}->{R}, "XXX", "11Z's right is XXX");

is(x(), 6, "We reach all Z in 6 steps");
done_testing();

# Code
sub resett {
	@pattern = ();
	%map = ();
	@nodes = ();
}

sub parse_input {
	my @lines = @_;
	my $steps = $lines[0];
	chomp($steps);
	@pattern = split //, $steps;

	foreach(2..scalar(@lines)-1) {
		my ($node, $left, $right) = $lines[$_] =~ /(\w+)\s+=\s+\((\w+),\s+(\w+)\)/;
		my %n = ("L" => $left, "R" => $right);
		push @nodes, $node if $node =~ /A$/;
		$map{$node} = \%n;	
	}
}

sub all_z {
	my $not_z = 0;

	foreach(@nodes) {
		$not_z = 1 if($_ !~ /Z$/);		
	}

	return 1 if ! $not_z;
	return 0;
}

# Least Common Multiple
sub x {
	my $steps = 0;

	my @steps_needed = ();
	my $i = 0;
	foreach(@nodes) {
		my $current_node = $_;
		my $steps_for_this_node = 0;
		while($current_node !~ /Z$/) {
			say "Current node is $current_node";
			my $left_or_right = $pattern[$steps_for_this_node % scalar(@pattern)];
			say "We are at step $steps_for_this_node, so take $left_or_right";
			my $take = $map{$current_node}->{$left_or_right};
			$current_node = $take;
			$steps_for_this_node++;
		}

		$steps_needed[$i] = $steps_for_this_node;
		$i++;
	}

	say "Steps needed for each start node: @steps_needed";
	my $s = lcm(@steps_needed);

	# This was the naive way were we just kept going until all of them become Z at the same time.
	#while(!all_z()) {
	#	my $left_or_right = $pattern[$steps % scalar(@pattern)];
	#	foreach(0..$#nodes) {
	#		#say "Current node is " . $nodes[$_];
	#		#say "We are at step $steps, so take $left_or_right";
	#		my $take = $map{$nodes[$_]}->{$left_or_right};
	#		$nodes[$_] = $take;
	#	}
	#	$steps++;
	#}

	return $s;
}

exit(0) if $debug == 1;
resett();
parse_input(<STDIN>);
say "Solution: " . x();

# Numbers

__DATA__
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
