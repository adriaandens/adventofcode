while(<>) {
	chomp; $a = $. % 3; %l = ();
	map { $l{$_} = 1 } /./g;
	map { $i{$_} += $a + 1 } keys(%l);
	map { $t += ord($_) >= ord('a') ? ord($_) - ord('a') + 1 : ord($_) - ord('A') + 27 if $i{$_} == 6 } keys(%i) if $a == 0;
	%i = () if $a == 0;
}
print $t;


