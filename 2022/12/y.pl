use feature 'say';
my @rows = ();
my @starts = (); # Start positions
my $end; # End position
while(<>) {
	chomp;
	my @cols = ();
	foreach(split //) {
		$node = create_node($. - 1, scalar(@cols), $_);
		if($_ eq 'S') {
			$node->{name} = 'a';
			push(@starts, $node);
		} elsif($_ eq 'E') {
			$end = $node;
			$end->{name} = 'z';
		} elsif($_ eq 'a') {
			push(@starts, $node);
		}
		push(@cols, $node);
	}
	$rows[$.-1] = \@cols;
}

say "End position: ($end->{r}, $end->{c})";

my $shortest = 10000;
foreach my $start (@starts) {
	$start->{distance} = 0; # Initial node gets distance 0
	while((my $current = get_next_node())) {
		my $result = dijkstra($current);
		if($result == 1) {
			#say "Dijkstra distance to E: " . $end->{distance};
			if($shortest > $end->{distance}) {
				$shortest = $end->{distance};
			}
		}
	}

	dijkstra_reset();
}
say "Shortest: $shortest";

sub dijkstra_reset {
	foreach my $r (@rows) {
		foreach my $c (@{$r}) {
			$c->{distance} = 100000;
			$c->{visited} = 0;
		}
	}
}

sub dijkstra {
	my $c = shift; # Our current node
	#say "Current node: " . $c->{r} . ", " . $c->{c};
	my @neighbours = get_unvisited_neighbours($c);
	foreach my $n (@neighbours) { # Step 3
		#say "\tUnvisited neighbour: " . $n->{r} . ", " . $n->{c};
		if($c->{distance} + 1 < $n->{distance}) {
			#say "\t\tYay, we found a shorter path";
			$n->{distance} = $c->{distance} + 1; # All distances are 1 in our field
		}
	}
	$c->{visited} = 1; # Step 4
	return 1 if $end->{visited}; # Step 5
	return 0;
}

sub get_next_node {
	my $smallest_distance = 100000;
	my $smallest_unvisited;
	foreach my $r (@rows) {
		foreach my $c (@{$r}) {
			if($c->{distance} < $smallest_distance && !$c->{visited}) {
				$smallest_distance = $c->{distance};
				$smallest_unvisited = $c;
			}
		}
	}
	return $smallest_unvisited;
}

sub get_unvisited_neighbours {
	my $node = shift;
	my @unvisited_neighbours = ();

	if($node->{r} > 0) { # We have a neighbour above us
		#say "we have an above";
		my $above = $rows[$node->{r} - 1]->[$node->{c}];
		if($above->{visited} == 0 && ord($above->{name}) <= ord($node->{name}) + 1) {
			push(@unvisited_neighbours, $above);
		}
	}

	if($node->{r} != scalar(@rows) - 1) { # We have a neighbour below us
		#say "we have an below";
		my $below = $rows[$node->{r} + 1]->[$node->{c}];
		if($below->{visited} == 0 && ord($below->{name}) <= ord($node->{name}) + 1) {
			push(@unvisited_neighbours, $below);
		}
	}

	if($node->{c} != @{$rows[0]} - 1) { # We have a neighbour right of us
		#say "we have a right";
		my $right = $rows[$node->{r}]->[$node->{c} + 1];
		if($right->{visited} == 0 && ord($right->{name}) <= ord($node->{name}) + 1) {
			push(@unvisited_neighbours, $right);
		}
	}

	if($node->{c} > 0) { # We have a neighbour left of us
		#say "we have a left";
		my $left = $rows[$node->{r}]->[$node->{c} - 1];
		if($left->{visited} == 0 && ord($left->{name}) <= ord($node->{name}) + 1) {
			push(@unvisited_neighbours, $left);
		}
	}

	return @unvisited_neighbours;
}

sub create_node {
	my ($a, $b, $name) = @_;
	my %item = ();
	$item{name} = $name;
	$item{r} = $a;
	$item{c} = $b;
	$item{visited} = 0; # Start with all nodes unvisited
	$item{distance} = 100000; # "Infinite"

	return \%item;
}
