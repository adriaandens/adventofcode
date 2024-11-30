use strict;
use warnings;
while(<DATA>) {
	# Our begin coordinates are always (0,0)
	my $xco = 0;
	my $yco = 0; 
	my $direction = "North";
	my @instructions = split /, /;
	foreach(@instructions) {
		print "Instr $_\n";
		($xco, $yco, $direction) = move($xco, $yco, $direction, $_);
	}
	print "Sol: " . calculate_manhattan(0, 0, $xco, $yco) . $/;
}

sub move {
	my ($x, $y, $d, $m) = @_;
	my ($turn, $amount) = ($m =~ /(\w)(\d+)/);
	my $new_direction = '';
	$x += $amount if $d eq 'North' && $turn eq 'R';
	$new_direction = 'East' if $d eq 'North' && $turn eq 'R';
	$x -= $amount if $d eq 'North' && $turn eq 'L';
	$new_direction = 'West' if $d eq 'North' && $turn eq 'L';

	$x -= $amount if $d eq 'South' && $turn eq 'R';
	$new_direction = 'West' if $d eq 'South' && $turn eq 'R';
	$x += $amount if $d eq 'South' && $turn eq 'L';
	$new_direction = 'East' if $d eq 'South' && $turn eq 'L';

	$y -= $amount if $d eq 'East' && $turn eq 'R';
	$new_direction = 'South' if $d eq 'East' && $turn eq 'R';
	$y += $amount if $d eq 'East' && $turn eq 'L';
	$new_direction = 'North' if $d eq 'East' && $turn eq 'L';

	$y += $amount if $d eq 'West' && $turn eq 'R';
	$new_direction = 'North' if $d eq 'West' && $turn eq 'R';
	$y -= $amount if $d eq 'West' && $turn eq 'L';
	$new_direction = 'South' if $d eq 'West' && $turn eq 'L';
	return ($x, $y, $new_direction);
}

sub calculate_manhattan {
	return abs($_[0] - $_[2]) + abs($_[1] - $_[3]);
}

__DATA__
R2, L3
R2, R2, R2
R5, L5, R5, R3
R5, L2, L1, R1, R3, R3, L3, R3, R4, L2, R4, L4, R4, R3, L2, L1, L1, R2, R4, R4, L4, R3, L2, R1, L4, R1, R3, L5, L4, L5, R3, L3, L1, L1, R4, R2, R2, L1, L4, R191, R5, L2, R46, R3, L1, R74, L2, R2, R187, R3, R4, R1, L4, L4, L2, R4, L5, R4, R3, L2, L1, R3, R3, R3, R1, R1, L4, R4, R1, R5, R2, R1, R3, L4, L2, L2, R1, L3, R1, R3, L5, L3, R5, R3, R4, L1, R3, R2, R1, R2, L4, L1, L1, R3, L3, R4, L2, L4, L5, L5, L4, R2, R5, L4, R4, L2, R3, L4, L3, L5, R5, L4, L2, R3, R5, R5, L1, L4, R3, L1, R2, L5, L1, R4, L1, R5, R1, L4, L4, L4, R4, R3, L5, R1, L3, R4, R3, L2, L1, R1, R2, R2, R2, L1, L1, L2, L5, L3, L1
