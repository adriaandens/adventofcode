use v5.40; 
my $s = 50;
my $c = 0;
while(<>) {
	my ($d, $a) = /(\w)(\d+)/;
	say "$d - $a";
	if($d eq 'L') { 
		if($s - $a < 0) { 
			my $t = int(abs($s - $a) / 100) + 1;
			say "\tpoints at C $t times"; $c += $t;
			if($s == 0) { $c--; } #je stond al op 0 en ging naar -5, dan heb je eigenlijk niet langs nul geweest
			$s = ($s - $a) % 100;
			#if($s == 0 && $t > 1) {
			#	say "\tIt ends on 0 so c + 1"; $c++; say "\t\tC is now $c";
			#}
		} elsif($s - $a == 0) {
			$s = 0; $c++;
		} else {
			$s = $s - $a;
		}
		say "$d$a - new value: $s";
	} elsif($d eq 'R') {
		if($s + $a > 99) {
			my $t = int(($s + $a) / 100);
			say "\tpoints at C $t times"; $c += $t;
			$s = ($s + $a) % 100;
			#if($s == 0 && $t > 1) { 
			#	say "\tIt ends on 0 so c+1"; $c++; say "\t\tC is now $c";
			#}
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
