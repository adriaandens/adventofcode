use feature qq/say/;

my $round = 20;
my @monkeys = ();
my $monkey = create_monkey();
while(<>) {
	chomp;
	if(!length) {
		push(@monkeys, $monkey);
		$monkey = create_monkey();
	}

	if(/^Monkey (\d+)/) {
		$monkey->{name} = 'Monkey ' . $1;
	} elsif(/Starting items: (.*)/) {
		my @items = ();
		foreach(split( /, /, $1)) {
			push(@items, $_);
		}
		$monkey->{items} = \@items;
	} elsif(/Operation: (.*)/) {
		my $op = $1;
		$op =~ s/new/\$new/g;
		$op =~ s/old/\$old/g;
		$monkey->{operation} = $op;

	} elsif(/Test: divisible by (\d+)/) {
		$monkey->{test} = $1;
	} elsif(/If true: throw to monkey (\d+)/) {
		$monkey->{iftrue} = $1;
	} elsif(/If false: throw to monkey (\d+)/) {
		$monkey->{iffalse} = $1;
	}
}
push(@monkeys, $monkey);
say "== Monkeys ==";
print_monkeys();

say "\n== Round $round ==";
while($round--) {
	play_round();
	say "\n== Round $round ==";
}
my @counts = sort { $b <=> $a } map { $_->{count} } @monkeys;
say "Monkey business: " . $counts[0]*$counts[1];

sub play_round {
	foreach my $m (@monkeys) {
		monkey_round($m);
		print_monkeys();
	}
}

sub monkey_round {
	my $m = shift;
	say $m->{name};
	while ((my $item = shift(@{$m->{items}}))) {
		say "\tInspecting $item";
		# Inspect
		$m->{count}++;
		my $old = $item;
		my $new = 0;
		eval($m->{operation});
		print "\t\tWorry level is: $new\n";

		# do test
		my $worry = int($new / 3);
		if($worry % $m->{test}) { # false
			say "\t\tWorry level dropped to $worry";
			say "\t\tIt's NOT divisble so we throw to monkey $m->{iffalse}";
			push(@{$monkeys[$m->{iffalse}]->{items}}, $worry);
		} else {
			say "\t\tWorry level dropped to $worry";
			say "\t\tIt's divisble so we throw to monkey $m->{iftrue}";
			push(@{$monkeys[$m->{iftrue}]->{items}}, $worry);
		}
	}
}

sub print_monkeys {
	foreach(@monkeys) {
		say $_->{name} . ": " . "@{$_->{items}}";
		say "\tOperation: " . $_->{operation};
		say "\tTest: " . $_->{test};
		say "\tiftrue: " . $_->{iftrue};
		say "\tiffalse: " . $_->{iffalse};
		say "\tCount: " . $_->{count};
	}
}

sub create_monkey {
	my %monkey = ();
	$monkey{count} = 0;
	return \%monkey;
}
