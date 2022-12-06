while(<>) {
	chomp;
	my $i = 1;
	my @ring = ();
	foreach(split //) {
		shift @ring if @ring == 4;
		push @ring, $_;
		if(@ring == 4 && $ring[0] ne $ring[1] && $ring[0] ne $ring[2] && $ring[0] ne $ring[3] &&
			$ring[1] ne $ring[2] && $ring[1] ne $ring[3] &&
			$ring[2] ne $ring[3]) {
			print "Position $i\n";	
			last;
		}

		$i++;
	}
}

