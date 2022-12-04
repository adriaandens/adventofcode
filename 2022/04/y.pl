my $total;
map {
	my ($a_start, $a_end, $b_start, $b_end) = /(\d+)-(\d+),(\d+)-(\d+)/;
	print "A gaat van $a_start tot $a_end\n";
	print "B gaat van $b_start tot $b_end\n";

	if(! ($a_end < $b_start || $b_end < $a_start)) {
		$total++;
	}
} <>;
print "Solution: $total\n";
