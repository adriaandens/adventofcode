map {
	%b = (); $i=0; chomp; $l = y///c; # Initializing some vars
	foreach(/./g) { 
		$b{$_} = 0 if $i < $l / 2;
		$t += ord($_) >= ord('a') ? ord($_) - ord('a') + 1 : ord($_) - ord('A') + 27 if defined($b{$_}) && $i >= $l / 2;
		last if defined($b{$_}) && $i >= $l / 2;
		$i++;
	}
} <>;
print $t;

__END__
Needed to use a foreach for the inner loop because map {} does not support the "last" keyword. And there were cases were the same letter would appear more than once in the second part, causing double counting of priorities.

Golf techniques:
* y///c is the same as length($_)
* /./g is the same of split //
