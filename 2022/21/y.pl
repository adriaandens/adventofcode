use feature 'say';
use strict;
use warnings;

my %lookups = ();
while(<>) {
	chomp;
	/(\w+): (.*)/;
	$lookups{$1} = $2;
}

# If we change the operation to "-" then we should get result 0 if both sides are equal.
my $res = $lookups{root};
$res =~ s/\+/\-/;
$lookups{root} = $res;


# Depending on the delta you get a different result but all these numbers generate a root==0 at the end (if calc() is assumed correct!)
$lookups{humn} = 3740214169964; # wrong
$lookups{humn} = 3740214169963; # unknown
$lookups{humn} = 3740214169962; # unknown
$lookups{humn} = 3740214169961; # correct

# The real codez
my $rounds = 0;
my $i = 1;
my $delta = 10000000000;
my $positive = 1;
$lookups{humn} = $i;
my $r = calc("root");
while($r) {
	say "humn=$i gave $r";
	if($positive) {
		if($r < 0) {
			$delta /= 10;		
			$positive = 0;
		} else {
			$i += $delta;
		}
	} else {
		if($r > 0) {
			$delta /= 10;
			$positive = 1;
		} else {
			$i -= $delta;
		}
	}
	$lookups{humn} = $i;
	$r = calc("root");
	$rounds++;
}
say "Solution: $i ($rounds rounds needed)";

sub calc {
	my $key = shift;
	my $op = $lookups{$key};
	my $result;
	if($op =~ /^(\d+)$/) {
		return $1;
	} elsif($op =~ /^(\w+) (.) (\w+)$/) {
		my ($op1, $action, $op2) = ($1, $2, $3);
		my $operand1 = calc($op1);
		my $operand2 = calc($op2);
		if($action eq '+') {
			$result = $operand1 + $operand2;
		} elsif($action eq '*') {
			$result = int($operand1) * int($operand2);
		} elsif($action eq '-') {
			$result = $operand1 - $operand2;
		} elsif($action eq '/') {
			$result = $operand1 / $operand2;
		} else {
			die "Weird\n";
		}
	} else {
		die "Weeeird\n";
	}
	return $result;
}
