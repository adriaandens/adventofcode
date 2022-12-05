my $crates = <>;
while($crates !~ /\d+\s*\d+/) {
	chomp($crates);
	my $stack_position = 0;
	my @str = split //, $crates;

	while($stack_position*4+1 < @str) {
		push(@{$stacks[$stack_position]}, $str[$stack_position*4+1]) if $str[$stack_position*4+1] ne ' ';
		$stack_position++;
	}

	$crates = <>;
}

<>;
while(<>) {
	my ($amount, $from, $to) = /move (\d+) from (\d+) to (\d+)/;
	unshift(@{$stacks[$to-1]}, shift(@{$stacks[$from-1]})) while $amount--;
}
print shift @{$_} foreach @stacks;
