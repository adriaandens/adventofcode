use feature 'say';

my %blocks = ();
while(<>) {
	chomp;
	$blocks{$_} = 1;
}

my $no_neighbour = 0;
foreach my $b (keys(%blocks)) {
	# A block has 6 sides so six potential neighbours. We'll check each neighbour. if we don't find the neighbour, the side is free and has to be counted.
	
	$no_neighbour++ if !check_neighbour($b, -1, 0, 0); # left on the x-axis
	$no_neighbour++ if !check_neighbour($b, 1, 0, 0); # right on the x-axis
	$no_neighbour++ if !check_neighbour($b, 0, -1, 0); # below on the y-axis
	$no_neighbour++ if !check_neighbour($b, 0, 1, 0); # on top of the y-axis
	$no_neighbour++ if !check_neighbour($b, 0, 0, -1); # before on the z-axis
	$no_neighbour++ if !check_neighbour($b, 0, 0, 1); # after on the z-axis
}
say "Solution: " . $no_neighbour;

sub check_neighbour {
	my ($b, $x, $y, $z) = @_;
	my @b_coordinates = split /,/, $b;
	my $neighbour_x = $b_coordinates[0] + $x;
	my $neighbour_y = $b_coordinates[1] + $y;
	my $neighbour_z = $b_coordinates[2] + $z;

	my $neighbour = "$neighbour_x,$neighbour_y,$neighbour_z";
	if(exists($blocks{$neighbour})) {
		return 1;
	}
	return 0;
}
