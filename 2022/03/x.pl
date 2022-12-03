my $total;
map {
	my %items = ();
	chomp;
	my $length = y///c;
	print "String has length: $length\n";
	my $i = 0;
	foreach(split //) { 
		if($i < $length / 2) {
			print "$_ belongs to the first part\n";
			$items{$_} = 0;
		} else {
			print "$_ belongs to the second part\n";
			if(defined($items{$_})) {
				print "$_ is the double item.\n";
				if(ord($_) >= ord('a')) {
					my $priority = ord($_) - ord('a') + 1;
					print "Priority is $priority\n";
					$total += $priority;
				} else {
					my $priority = ord($_) - ord('A') + 27;
					print "Priority is $priority\n";
					$total += $priority;
				}
				last;
			}
		}
		$i++;
	}
} <>;
print "Solution: $total\n";

__END__
Needed to use a foreach for the inner loop because map {} does not support the "last" keyword. And there were cases were the same letter would appear more than once in the second part, causing double counting of priorities.
