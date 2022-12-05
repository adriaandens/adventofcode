my $crates = <>;
while($crates !~ /\d+\s*\d+/) {
	chomp($crates);
	my $stack_position = 0;
	my @str = split //, $crates;

	while($stack_position*4+1 < @str) {
		if( $str[$stack_position*4+1] ne ' ' ) {
			if(!defined($stacks[$stack_position])) {
				$stacks[$stack_position] = create_ll();
			}
			add_item_to_tail_ll($stacks[$stack_position], create_item($str[$stack_position*4+1]));
		}

		$stack_position++;
	}

	$crates = <>;
}
print "Done reading the visual picture.\n";
#foreach(@stacks) {
#	print_ll($_);
#}

<>; # read empty line
while(<>) { # the commands
	print "We are on line $.\n" if $. % 1000 == 0;
	my ($amount, $from, $to) = /move (\d+) from (\d+) to (\d+)/;
	migrate_top_elements($amount, $stacks[$from-1], $stacks[$to-1]);
}

foreach(@stacks) {
	print $_->{head}->{value};
}

print "\n";

exit;

### Implementing a linked list in pure Perl (I suffer from NIH syndrome)

# TODO: Implementing tail correctly in every function, most noteably if all elements are removed from an LL (check boundary logic, updates needed, ...)
# We need this for the input to be entered in the LL (you go from top to bottom in the input so you need to keep adding the tail, not the head)

sub create_ll {
	my %ll = (
		'size' => 0,
		'head' => undef,
		'tail' => undef,
		'direction' => 'prev' # Means that the Top is in the front and you need to call 'next' on the items to go lower and find N°10.000
	);
	return \%ll;
}

sub create_ll_with_items {
	my ($head, $tail, $size) = @_;
	$ll = create_ll();
	$ll->{head} = $head;
	$ll->{head} = $tail;
	$ll->{size} = $size;

	return $ll;
}

sub create_item {
	my $value = shift;
	my %item = ( 'value' => $value, 'prev' => undef, 'next' => undef );
	return \%item;
}

sub add_item_to_top_ll {
	my $ll = shift;
	my $item = shift;
	$current_head = $ll->{head}; # Getting the current head of the LL
	# TODO: Implement direction below, it's different depending on it...
	$item->{next} = $current_head; # Updating the new head with the current head as the next element
	$current_head->{prev} = $item; # Updating the old head with the new head as the prev element
	$ll->{head} = $item; # Setting item as the new head :-)
	$ll->{tail} = $item if $ll->{size} == 0;
	$ll->{size} = $ll->{size} + 1; # Updating size of Linked List chain
}

sub add_item_to_tail_ll {
	my $ll = shift;
	my $item = shift;
	if($ll->{size} > 0) { # There's an existing tail
		$current_tail = $ll->{tail}; # Getting the current tail of the LL
		# TODO: Implement direction below, it's different depending on it...
		$item->{prev} = $current_tail; # Updating the new tail with the current tail as the prev element
		$current_tail->{next} = $item; # Updating the old tail with the new tail as the next element
	} else {
		$ll->{head} = $item;
	}
	$ll->{tail} = $item;
	$ll->{size} = $ll->{size} + 1; # Updating size of Linked List chain

}

sub add_items_to_top_ll {
	my ($first, $size, $last, $ll) = @_;
	my $current_head = $ll->{head};
	$current_head->{prev} = $last;
	$last->{next} = $current_head;
	$ll->{head} = $first;
	$ll->{tail} = $last if $ll->{size} == 0;
	$ll->{size} = $ll->{size} + $size;
}

sub remove_top_elements_from_ll {
	my $ll = shift;
	my $amount_to_remove = shift;

	die "Cannot remove more items than we have in the LL\n" if $amount_to_remove > $ll->{size};

	$ll->{size} = $ll->{size} - $amount_to_remove; # Updating size since we modify $amount_to_remove below...

	my $element = $ll->{head};
	while($amount_to_remove > 1) {
		$element = $element->{next};
		$amount_to_remove--;
	} # $element is now the item in the LL where we need to break ties.

	#print "Found last item in LL to remove: " . $element->{value} . "\n";

	# Updating LL
	$ll->{head} = $element->{next}; # We have a new head
	$element->{next}->{prev} = undef; # The new head doesn't have a prev.
	$ll->{tail} = undef if $ll->{size} == 0; # In case we emptied the LL.

	# Updating the last element of our new LL to say it has no followers.
	$element->{next} = undef;

	return $element;
}

sub migrate_top_elements {
	my ($amount, $ll_from, $ll_to) = @_;

	my $head = $ll_from->{head};
	my $tail = remove_top_elements_from_ll($ll_from, $amount);

	add_items_to_top_ll($head, $amount, $tail, $ll_to);
}

sub print_ll {
	my $ll = shift;
	my $i = $ll->{head};
	while($i) {
		print $i->{value} . '->';
		$i = $i->{next};
	}
	print "\n";
}

# Tests
my $ll_one = create_ll();
add_item_to_top_ll($ll_one, create_item('A'));
add_item_to_top_ll($ll_one, create_item('B'));
add_item_to_top_ll($ll_one, create_item('C'));
add_item_to_top_ll($ll_one, create_item('D'));
add_item_to_tail_ll($ll_one, create_item('Before A'));
print_ll($ll_one);
print "Size of LL one is: " . $ll_one->{size} . "\n";
print "Tail of LL one is: " . $ll_one->{tail}->{value} . "\n";

my $ll_two = create_ll();
add_item_to_top_ll($ll_two, create_item('X'));
print_ll($ll_two);
print "Size of LL two is: " . $ll_two->{size} . "\n";
print "Tail of LL two is: " . $ll_two->{tail}->{value} . "\n";

print "\nMigrate a few elements\n";
migrate_top_elements(2, $ll_one, $ll_two);
print_ll($ll_one);
print "Size of LL one is: " . $ll_one->{size} . "\n";
print "Tail of LL one is: " . $ll_one->{tail}->{value} . "\n";
print_ll($ll_two);
print "Size of LL two is: " . $ll_two->{size} . "\n";
print "Tail of LL two is: " . $ll_two->{tail}->{value} . "\n";
