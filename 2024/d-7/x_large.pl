#my @sterren = ();
my %laatste_op_rij = (); # Hash die de laatste entry per rij bevat $laatste_op_rij{4} bevat laatste geziene coord van die rij
my %laatste_op_kol = (); # Zelfde maar voor kolom
#my @paren = (); # Bevat paren van sterren.
my %buren = ();
open(F, '<', 'input.txt') or die;
my $r = 0;
while(<F>) {
	my $c = 0;
	my @hemellijn = split //, $_;
	foreach(@hemellijn) {
		if($_ eq '*') { # Sterretje
			my @coord = ($r, $c);
			$buren{$r . ',' . $c} = []; # Jezelf lege buren geven
			if($laatste_op_rij{$r}) {
				my $buurman = $laatste_op_rij{$r};
				my %lijn = (ster1 => \@coord, ster2 => $buurman);
				#push @paren, \%lijn;
				push @{$buren{$buurman->[0] . ',' . $buurman->[1]}}, \@coord;
				push @{$buren{$r . ',' . $c}}, $buurman;
			}
			if($laatste_op_kol{$c}) {
				my $buurman = $laatste_op_kol{$c};
				my %lijn = (ster1 => \@coord, ster2 => $buurman);
				#push @paren, \%lijn;
				push @{$buren{$buurman->[0] . ',' . $buurman->[1]}}, \@coord; # Wij zijn de buurman
				push @{$buren{$r . ',' . $c}}, $buurman; # Buurman is onze buur
			}
			$laatste_op_rij{$r} = \@coord;
			$laatste_op_kol{$c} = \@coord;
		}
		$c++; # volgende kolom
	}

	$r++; # nieuwe rij
}
close(F);

#foreach(@paren) {
#	print '(' . $_->{ster1}[0] . ',' . $_->{ster1}[1] . ') <-> (' . $_->{ster2}[0] . ',' . $_->{ster2}[1] . ')' . $/;
#}

my $t = 0;
foreach(keys(%buren)) {
	my $c = scalar(@{$buren{$_}});
	if($c == 2) {
		$t += 1;
	} elsif($c == 3) {
		$t += 3;
	} elsif($c == 4) {
		$t += 6;
	}
}
print "Sol: $t\n";
