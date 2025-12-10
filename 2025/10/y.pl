use v5.40;

my $total = 0;
while(<DATA>) {
	chomp;
	say;
	my @changes = split / /;
	my $start_state = shift @changes;
	my $joltage = pop @changes;
	my $min = min_steps_to_start_state($joltage, @changes);
	say "\t$joltage can be reached in $min steps";
	$total += $min;
}
say "Solution: $total";

sub min_steps_to_start_state {
	my ($goal_state, @possible_changes) = @_;
	# Initially, we need to visit all nodes
	my @bfs_queue = @possible_changes;
	while(@bfs_queue) {
		my $visiting = shift @bfs_queue; # BFS is getting the first element
		if(state_reached($goal_state, $visiting)) {
			say "Found it: $visiting";
			return chain_length($visiting);
		} else {
			my @children = generate_children($visiting, @possible_changes);
			push @bfs_queue, @children;
		}
	}
}

sub generate_children {
	my ($visiting, @possible_changes) = @_;
	my @visited_nodes = split /->/, $visiting;
	my @children = ();
	foreach my $a (@possible_changes) {
		push @children, $visiting . '->' . $a;
	}
	return @children;
}

sub chain_length {
	my $s = shift;
	my @items = split /->/, $s;
	return scalar(@items);
}

sub state_reached {
	my ($goal_state, $visiting) = @_;
	say "\tjoltage: $goal_state, chain: $visiting";
	$goal_state =~ s/(\{|\})//g;
	my @goal = split /,/, $goal_state;
	my @state = ();
	my @visits = split /->/, $visiting;
	foreach(@visits) {
		s/\(|\)//g;
		foreach(split /,/) {
			$state[$_]++; # toggle on
		}
	}
	for(my $i = 0; $i < @goal; $i++) {
		if(!defined($state[$i]) || $goal[$i] != $state[$i]) {
			return 0;
		}
	}
	return 1;
}



__DATA__
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
