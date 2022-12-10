my $register_x = 1;
my $cycles = 0;
my @register_values_after_cycle = ($register_x);
my @crt = ();
while(<>) {
	chomp;
	if($_ eq 'noop') {
		# it's a no operation
	} elsif(/^addx (-?\d+)/) {
		$cycles++; # we're busy doing things
		$register_values_after_cycle[$cycles] = $register_x;
		$register_x += $1;
	}
	$cycles++;
	$register_values_after_cycle[$cycles] = $register_x;
}

print "@register_values_after_cycle\n";

for(my $i = 1; $i < @register_values_after_cycle; $i++) {
	my $value_during_cycle_i = $register_values_after_cycle[$i-1];
	my $value_after_cycle_i = $register_values_after_cycle[$i];
	my $sprite_start = $value_during_cycle_i - 1;
	my $sprite_end = $value_during_cycle_i + 1;

	print "Sprite position [$sprite_start, $sprite_end]\n";
	print "During cycle $i: we draw a pixel in position " . ($i-1) . "\n";
	print "Register value during cycle $i: $value_during_cycle_i\n";
	#print "Register value after cycle $i: $value_after_cycle_i\n";
	if(($i-1) % 40 >= $sprite_start && ($i-1) % 40 <= $sprite_end) {
		$crt[$i-1] = '#';
	} else {
		$crt[$i-1] = '.';
	}
	foreach(@crt) {
		print $_;
	}	

	print "\n\n";
	#print "Value during cycle $i: " . $register_values_after_cycle[$i-1] . "\n";
}

my $j = 0;
while($j < @crt) {
	if($j % 40 == 0 && $j != 0) {
		print "\n";
	}
	print $crt[$j];
	$j++;
}



