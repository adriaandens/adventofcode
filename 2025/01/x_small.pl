$s = 50;
while(<>) {
	/(\w)(\d+)/;
	$s = ($s + ($1 eq 'L' ? -1*$2 : $2)) % 100;
	$c++ if $s == 0;
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
