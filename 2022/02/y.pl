map {
	s/(\w) (\w)/$a=ord($1)-64;$b=ord($2)-23-65/e;
	$t += ($b*3); # calculating win-draw-loose value
	$t += $a if $b == 1; # we need to draw
	$t += $a == 1 ? 2 : (($a == 2) ? 3 : 1) if $b == 2; # we need to win
	$t += $a == 1 ? 3 : (($a == 2) ? 1 : 2) if $b == 0; # we need to lose
} <>;
print $t;

__END__
a == rock == 1
b == paper == 2
c == scissors == 3
x == losing
y == draw
z == win

stable difference of 23 ascii values between the same value.
