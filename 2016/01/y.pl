use strict;
use warnings;



while(<DATA>) {
	print $_;
	# Our begin coordinates are always (0,0)
	my $xco = 0;
	my $yco = 0; 
	my %been_here = ('0#0' => 1);
	my $direction = "North";
	my @instructions = split /, /;
	A: foreach(@instructions) {
		my @visited = ();
		($direction, @visited) = move($xco, $yco, $direction, $_);
		for(my $i = 0; $i < scalar(@visited); $i += 2) {
			$xco = $visited[$i];
			$yco = $visited[$i+1];
			print "($xco, $yco) -> ";
			if(exists( $been_here{"$xco#$yco"} )) {
				last A;
			}
			$been_here{"$xco#$yco"} = 1;
		}
	}
	print "Sol: " . calculate_manhattan(0, 0, $xco, $yco) . $/;
}

sub move {
	my ($x, $y, $d, $m) = @_;
	my ($turn, $amount) = ($m =~ /(\w)(\d+)/);
	my $new_direction = '';
	my @positions = ();
	if($d eq 'North' && $turn eq 'R') {
		$new_direction = 'East';
		while($amount--) {
			$x++;
			push @positions, $x, $y;
		}
	} elsif($d eq 'North' && $turn eq 'L') {
		$new_direction = 'West';
		while($amount--) {
			$x--;
			push @positions, $x, $y;
		}
	} elsif($d eq 'South' && $turn eq 'R') {
		$new_direction = 'West';
		while($amount--) {
			$x--;
			push @positions, $x, $y;
		}
	} elsif($d eq 'South' && $turn eq 'L') {
		$new_direction = 'East';
		while($amount--) {
			$x++;
			push @positions, $x, $y;
		}
	} elsif($d eq 'East' && $turn eq 'R') {
		$new_direction = 'South';
		while($amount--) {
			$y--;
			push @positions, $x, $y;
		}
	} elsif($d eq 'East' && $turn eq 'L') {
		$new_direction = 'North';
		while($amount--) {
			$y++;
			push @positions, $x, $y;
		}
	} elsif($d eq 'West' && $turn eq 'R') {
		$new_direction = 'North';
		while($amount--) {
			$y++;
			push @positions, $x, $y;
		}
	} elsif($d eq 'West' && $turn eq 'L') {
		$new_direction = 'South';
		while($amount--) {
			$y--;
			push @positions, $x, $y;
		}
	}
	return ($new_direction, @positions);
}

sub calculate_manhattan {
	return abs($_[0] - $_[2]) + abs($_[1] - $_[3]);
}

__DATA__
R8, R4, R4, R8
R5, L2, L1, R1, R3, R3, L3, R3, R4, L2, R4, L4, R4, R3, L2, L1, L1, R2, R4, R4, L4, R3, L2, R1, L4, R1, R3, L5, L4, L5, R3, L3, L1, L1, R4, R2, R2, L1, L4, R191, R5, L2, R46, R3, L1, R74, L2, R2, R187, R3, R4, R1, L4, L4, L2, R4, L5, R4, R3, L2, L1, R3, R3, R3, R1, R1, L4, R4, R1, R5, R2, R1, R3, L4, L2, L2, R1, L3, R1, R3, L5, L3, R5, R3, R4, L1, R3, R2, R1, R2, L4, L1, L1, R3, L3, R4, L2, L4, L5, L5, L4, R2, R5, L4, R4, L2, R3, L4, L3, L5, R5, L4, L2, R3, R5, R5, L1, L4, R3, L1, R2, L5, L1, R4, L1, R5, R1, L4, L4, L4, R4, R3, L5, R1, L3, R4, R3, L2, L1, R1, R2, R2, R2, L1, L1, L2, L5, L3, L1
