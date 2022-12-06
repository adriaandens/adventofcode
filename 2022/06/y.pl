my $size = 14;
while(<>) {
	chomp;
	my $i = 1;
	my @ring = ();
	foreach(split //) {
		shift @ring if @ring == $size;
		push @ring, $_;
		if(@ring == $size && check($size, @ring)) {
			print "Position $i\n";	
			last;
		}

		$i++;
	}
}

sub check {
	my ($size, @ring) = @_;
	my %checker = ();

	$checker{$_} = 1 foreach(@ring);

	return 1 if keys(%checker) == $size;
	return 0;
}
