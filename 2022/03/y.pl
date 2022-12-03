my $total;
my %items = ();
while(<>) {
	chomp;
	print "Line $.\n";

	my $a = $. % 3;
	print "a is $a\n";

	my %line = ();
	map { $line{$_} = 1 } split //;
	map { $items{$_} += $a + 1 } keys(%line);

	if($a == 0) {
		print "Final Elf of a group.\n";

		map { 
			
			if($items{$_} == 6) {
				print "This char appears in all three: $_\n";
				if(ord($_) >= ord('a')) {
					my $priority = ord($_) - ord('a') + 1;
					print "Priority is $priority\n";
					$total += $priority;
				} else {
					my $priority = ord($_) - ord('A') + 27;
					print "Priority is $priority\n";
					$total += $priority;
				}
			}
		} keys(%items);
		
		# CLEANUP
		%items = ();
	}
}
print "Solution: $total\n";


