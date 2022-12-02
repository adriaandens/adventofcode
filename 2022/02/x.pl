map {
	s/(\w) (\w)/$a=ord($1);$b=ord($2)-23/e;
	$t += $b - 64; # my choice
	$t += 6 if $b == $a + 1 || $b - $a == -2; # we win
	$t += 3 if $a == $b; # we have a draw
} <>;
print $t;

__END__
a == x == rock == 1
b == y == paper == 2
c == z == scissors == 3

stable difference of 23 ascii values between the same value.
