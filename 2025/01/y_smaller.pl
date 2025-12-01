$s = 50;
while(<>) {
	/(\w)(\d+)/;
	$a = $1 eq 'L' ? -1*$2 : $2;
	my $mod = 1 if $1 eq 'L' && $s > 0;
	$c += int(abs($s + $a) / 100) + $mod if $s + $a <= 0 || $s + $a >= 100;
	$s = ($s + $a) % 100;
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

