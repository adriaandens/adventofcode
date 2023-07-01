use feature 'say';


my $increases = 0;
my $prev_window = -1;
my @window = ();

while(<>) {
	chomp($_);

	# Add a new entry to end of the window
	push(@window, $_);
	
	if(@window == 4 && prev_window != -1) { # Our window is big enough
		shift @window; # shift first entry in the window, out of it.
		my $sum = 0;
		map { $sum += $_ } @window;
		$increases++ if $sum > $prev_window;
		$prev_window = $sum;
	} elsif(@window == 3) { # We are the first window
		my $sum = 0;
		map { $sum += $_ } @window;
		$prev_window = $sum;
	}
}


say "Solution: " . $increases;
