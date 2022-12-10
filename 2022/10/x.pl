my $register_x = 1;
my $cycles = 0;
my @register_values_after_cycle = qq($register_x);
while(<>) {
	chomp;
	if($_ eq 'noop') {
		# it's a no operation
	} elsif(/^addx (-?\d+)/) {
		print "ADDX $1\n";
		$cycles++; # we're busy doing things
		$register_values_after_cycle[$cycles] = $register_x;
		$register_x += $1;
	}
	$cycles++;
	$register_values_after_cycle[$cycles] = $register_x;
}

print "@register_values_after_cycle\n";

my $i = 20;
my $sum = 0;
while($i < @register_values_after_cycle) {
	print "Value during cycle $i: " . $register_values_after_cycle[$i-1] . "\n";
	$sum += $i * $register_values_after_cycle[$i-1];
	$i += 40;
}
print "Solution: $sum\n";
