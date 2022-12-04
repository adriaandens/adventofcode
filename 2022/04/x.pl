my $total;
map {
	my ($a_start, $a_end, $b_start, $b_end) = /(\d+)-(\d+),(\d+)-(\d+)/;
	print "A gaat van $a_start tot $a_end\n";
	print "B gaat van $b_start tot $b_end\n";

	if($a_start <= $b_start && $a_end >= $b_end) {
		print "Elf A contains fully what B will do.\n";
		$total++;
	} elsif($b_start <= $a_start && $b_end >= $a_end) {
		print "Elf B contains fully what A will do.\n";
		$total++;
	}
} <>;
print "Solution: $total\n";
