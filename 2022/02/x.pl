my $total;
map {
	s/(\w) (\w)/$a=ord($1);$b=ord($2)-23/e;

	# Value of my chose
	my $score = $b - 64;

	# Checking whether it was a win, draw, loss
	if($b == $a + 1 || $b - $a == -2) { # you win
		$score += 6;
	} elsif($a == $b) {
		$score += 3;
	}
	$total += $score;
} <>;
print "Solution: $total\n";

__END__
a == x == rock == 1
b == y == paper == 2
c == z == scissors == 3

stable difference of 23 ascii values between the same value.
