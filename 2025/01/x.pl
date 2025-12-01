use v5.40; 
my $s = 50;
my $c = 0;
while(<>) {
	my ($d, $a) = /(\w)(\d+)/;
	say "$d - $a";
	if($d eq 'L') { 
		if($s - $a < 0) { 
			$s = ($s - $a) % 100;
			if($s == 0) { $c++ }
		} elsif($s - $a == 0) {
			$s = 0; $c++;
		} else {
			$s = $s - $a;
		}
		say "$d$a - new value: $s";
	} elsif($d eq 'R') {
		if($s + $a > 99) {
			$s = ($s + $a) % 100;
			if($s == 0) { $c++ }
		} elsif($s + $a == 0) {
			$c++;
		} else {
			$s = $s + $a;
		}
		say "$d$a - new value: $s";
	} else {
		die "invalid\n";
	}
}

print "Solution: $c\n";

__DATA__
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
