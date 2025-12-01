use v5.40; 
my $s = 50;
my $c = 0;
my $mod = 0;
while(<>) {
	my ($d, $a) = /(\w)(\d+)/;
	$a = $d eq 'L' ? -1*$a : $a;
	$mod = 1 if $d eq 'L';
	if(($s + $a <= 0 && $s > 0) || ($s + $a >= 100)) {
		#say "\tAls we over 99 gaan OF onder 0 gaan moeten we bijtellen. Voor [-99,0] kom je echter 0 uit bij de counter ondanks dat je nul bent gepasseerd dus doen we een modifier van 1";
		$c += int(abs($s + $a) / 100) + $mod; # if ($s + $a <= 0 && $s > 0) || $s + $a >= 100;
	} elsif(($s + $a <= 0 && $s == 0)) {
		$c += int(abs($s + $a) / 100);
	} 
	$s = ($s + $a) % 100;
	$mod = 0;
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
