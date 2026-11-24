while(<>) {
	chomp;
	$p += $_;
	push @l, ('A'..'Z')[($p + grep{ $_ <= $p } @a) % 26];
	map { $a[$_] > $p ? $a[$_]-- : 1 } 0..$#a;
	push @a, $p;
}
print join('', @l);
