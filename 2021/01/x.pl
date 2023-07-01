use feature 'say';

my $increases = 0;
chomp(my $prev_measurement = <>);
while((my $measurement = <>)) {
	chomp($measurement);
	$increases++ if $measurement > $prev_measurement;
	$prev_measurement = $measurement;
}

say "Solution: " . $increases;
