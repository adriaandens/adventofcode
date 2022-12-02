my $total;
map {
	s/(\w) (\w)/$a=ord($1);$b=ord($2)-23/e;

	# calculating win-draw-loose value
	$score = ($b - 65)*3;
	print "Second value is: $score\n";

	# 
	$a = $a - 64;
	if($score == 3) { # we need to draw
		$score += $a;
	} elsif($score == 6) {
		if($a == 1) { # they picked rock
			$score += 2; # we pick paper
		} elsif($a == 2) { # they picked paper
			$score += 3; # we pick scissors
		} else { # they picked scissors
			$score += 1; # we pick rock
		}
	} else { # we need to lose
		if($a == 1) { # they picked rock
			$score += 3; # we pick scissors
		} elsif($a == 2) { # they picked paper
			$score += 1; # we pick rock
		} else { # they picked scissors
			$score += 2; # we pick paper
		}
	}
	$total += $score;
} <>;
print "Solution: $total\n";

__END__
a == rock == 1
b == paper == 2
c == scissors == 3
x == losing
y == draw
z == win

stable difference of 23 ascii values between the same value.
