use feature 'say';
use strict;
use warnings;

my %lookups = ();
while(<>) {
	chomp;
	/(\w+): (.*)/;
	$lookups{$1} = $2;
}

my $r = calc("root");
say "Solution: " . $r;

sub calc {
	my $key = shift;
	my $op = $lookups{$key};
	say "Operand received for $key: $op";
	my $result;
	if($op =~ /^(\d+)$/) {
		say "\tImmediately return number for $key: $1";
		return $1;
	} elsif($op =~ /^(\w+) (.) (\w+)$/) {
		my ($op1, $action, $op2) = ($1, $2, $3);
		my $operand1 = calc($op1);
		my $operand2 = calc($op2);
		say "\tFor key $key, we found operands $operand1 and $operand2";
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
	say "\tReturning: $result";
	return $result;
}
