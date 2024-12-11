use v5.36;

$_ = <DATA>;
chomp;
my @numbers = (m/(\d+)/g);

my $sum = 0;
my %memo = ();
my $depth = 2;
foreach(@numbers) {
	say "N: $_";
	my $subtotal = brr($_, 1);
	$sum += $subtotal;
}
say "Sol: $sum";

sub brr {
	my ($n, $depth) = @_;
	my $total = 0;
	if($depth == 26) {
		return 1;
	} else { # we'll need to brr
		if($n == 0) {
				$total += brr(1, $depth+1);
				say "Change 0 to 1";
		} elsif(length($n) % 2 == 0) {
			my @digits = split //, $n;
			my @first = splice @digits, 0, @digits / 2;
			my $n1 = join('', @first);
			my $n2 = join('', @digits);
			$n1 += 0; $n2 += 0;
			say "Split $n in $n1 and $n2";
			$total += brr($n1, $depth+1);
			$total += brr($n2, $depth+1);
		} else {
			say "No rule matched, so multiply $n by 2024: " . $n*2024;
			$total += brr($n * 2024, $depth + 1);
		}
	}
	return $total;
}

__DATA__
5178527 8525 22 376299 3 69312 0 275
