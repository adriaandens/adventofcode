use feature 'say';

my $hor = 0;
my $depth = 0;

while(<>) {
	/(\w+) (\d+)/;
	
	if($1 eq 'forward') {
		$hor += $2;
	} elsif($1 eq 'down') {
		$depth += $2;
	} elsif($1 eq 'up') {
		$depth -= $2;
	} else {
		die "Should not happen.\n";
	}
}

say "Solution: " . $hor*$depth;
