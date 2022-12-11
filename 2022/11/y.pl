use feature qq/say/;
use bigint;
use Math::Prime::Util ':all';
use Data::Dumper;

my $round = 10000;
my $lcm = 1;
my @dividers = ();
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
			push(@items, create_item($_));
		}
		$monkey->{items} = \@items;
	} elsif(/Operation: (.*)/) {
		my $op = $1;
		#$op =~ s/new/\$new/g;
		#$op =~ s/old/\$old/g;
		$monkey->{operation} = $op;

	} elsif(/Test: divisible by (\d+)/) {
		$monkey->{test} = $1;
		$lcm *= $1;
		push(@dividers, $1);
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
	}
	print_monkeys();
}

sub monkey_round {
	my $m = shift;
	while ((my $item = shift(@{$m->{items}}))) {
		# Inspect
		$m->{count}++;
		my $worry = operate($m->{operation}, $item); # operates on the item scalar itself

		# do test
		if(!test_div($worry, int($m->{test}))) { # false
			push(@{$monkeys[$m->{iffalse}]->{items}}, $worry);
		} else {
			push(@{$monkeys[$m->{iftrue}]->{items}}, $worry);
		}
	}
}

sub test_div {
	my ($item, $divider) = @_;
	my $divisable = 0;
	foreach my $factor (@{$item}) {
		if($factor == $divider) {
			$divisable = 1;
			last;
		}
	}
	return $divisable;
}

sub operate {
	my ($operation, $old) = @_;
	$operation =~ /new = old (.) (\w+)/;
	if($1 eq '*' && $2 eq 'old') {
		# This is just duplicating the prime factors
		my @new = ();
		foreach(@{$old}) {
			push(@new, $_);
		}
		push(@{$old}, @new);
	} elsif($1 eq '+') { #EXPENSIVE OPERATION HERE
		# 1) Taking the prime factors and making the number
		my $val = 1;
		foreach(@{$old}) {
			$val *= $_;
		}
		
		# 2) Doing the operation from the input.
		$val += $2;

		# 3) Keep the value size under control, see README.
		$val = $val % $lcm;

		# 4) Factoring again.
		my @factors = factor($val);
		$old = \@factors;
	} elsif($1 eq '*') {
		# Just add the factors of the value with which we multiply
		push(@{$old}, factor($2));
	} else {
		die "Weird\n";
	}
	return $old;
}

sub print_monkeys {
	foreach(@monkeys) {
		say $_->{name} . " inspected items " . $_->{count} . " times";
	}
}

sub create_item {
	my $i = shift;
	my %item = ();
	my @factors = factor($i);
	$item->{factors} = \@factors;
}

sub create_monkey {
	my %monkey = ();
	$monkey{count} = 0;
	return \%monkey;
}
