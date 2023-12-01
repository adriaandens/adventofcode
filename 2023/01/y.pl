
use feature 'say';
my $sum = 0;
my %mappie = (
	"one" => 1,
	"two" => 2,
	"three" => 3,
	"four" => 4,
	"five" => 5,
	"six" => 6,
	"seven" => 7,
	"eight" => 8,
	"nine" => 9,
	"eighthree" => 3,
	"eightwo" => 2,
	"twone" => 1,
	"fiveight" => 8,
	"nineight" => 8
);
while(<STDIN>) {
	my $i = 0;
	my @substrs = ();
	while($i < length($_) - 5) {
		my $s = substr $_, $i, 5;
		push @substrs, $s;
		$i++;
	}
	push @substrs, $_ if length($_) < 6;

	say "Substrings: @substrs";

	my @numbers = ();

	foreach(@substrs) {
		push @numbers, m/(\d|one|two|three|four|five|six|seven|eight|nine)/g;
	}

	

	say "LINE $. - @numbers" if @numbers < 2;
	my $n = lookup($numbers[0]) . lookup($numbers[-1]);
	#$n = lookup($numbers[0]) if @numbers < 2;
	die "$. @numbers" if !$n;
	say "Number is $n";
	$sum += $n;
}

say "Solution: $sum";

sub lookup {
	say "lookup $_[0]";
	return $_[0] if $_[0] =~ /\d/;
	return $mappie{$_[0]};
}
