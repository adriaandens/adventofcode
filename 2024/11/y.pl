use v5.36;

$_ = <DATA>;
chomp;
my @numbers = (m/(\d+)/g);

my $sum = 0;
my %memo = ();
my $global_depth = 75;
$sum += brr($_, 0) foreach @numbers;
say "Sol: $sum";

sub brr {
	my ($n, $depth) = @_;
	my $total = 0;
	if($depth == $global_depth) {
		return 1;
	} else { # we'll need to brr
		return $memo{$n . "#" . $depth} if $memo{$n . "#" . $depth};
		if($n == 0) {
			$total += brr(1, $depth+1);
			$memo{$n . "#" . $depth} = $total;
		} elsif(length($n) % 2 == 0) {
			my @digits = split //, $n;
			$total += brr(join('', splice @digits, 0, @digits /2) + 0, $depth+1) + brr(join('', @digits) + 0, $depth+1);
			$memo{$n . "#" . $depth} = $total;
		} else {
			$total += brr($n * 2024, $depth + 1);
			$memo{$n . "#" . $depth} = $total;
		}
	}
	return $total;
}

__DATA__
5178527 8525 22 376299 3 69312 0 275
