my $crates = <>;
my @stacks = ();
while($crates  !~ /\d+\s*\d+/) {
	print "Crate stack: $crates";
	chomp($crates);

	my $i = 0; my $space_count = 0;
	my $stack_position = 0;
	my @str = split //, $crates;
	while($i < @str) {
		if($str[$i] eq ' ') {
			$space_count++;
			$i++;
		} elsif($str[$i] eq '[') {
			$crate_name = $str[$i+1];
			$stack_position += int($space_count / 4);
			print "Crate $crate_name should be put on stack $stack_position\n";
			push(@{$stacks[$stack_position]}, $crate_name);

			$i += 3; # <number><bracket><space>
			$space_count = 0;
			$stack_position++;
		}
	}	

	$crates = <>;
}

# Debug printing
foreach(@stacks) {
	print "Stack: @{$_}\n";
}

<>; # read empty line
while(<>) { # the commands
	print "Command: $_";
	my ($amount, $from, $to) = /move (\d+) from (\d+) to (\d+)/;
	print "Amount: $amount, from: $from, to: $to\n";

	my @top_crates = splice @{$stacks[$from-1]}, 0, $amount;
	print "Moving @top_crates\n";
	unshift(@{$stacks[$to-1]}, @top_crates);
}

foreach(@stacks) {
	print shift(@{$_});
}

