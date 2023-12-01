
use feature 'say';
my $sum = 0;
while(<STDIN>) {
	my @numbers = grep { /\d/ } split //;
	my $n = $numbers[0] . $numbers[-1];
	say "Number is $n";
	$sum += $n;
}

say "Solution: $sum";
