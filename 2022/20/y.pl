use feature 'say';

# Array that contains the new/current position of the number
# $current_post[0] contains the value where this number now is in the current array
my $i = 0;
my $ll = create_ll();
my $magic_zero;
while(<>) {
	chomp;
	my $item = create_item($_ * 811589153);
	add_item_to_tail_ll($ll, $item);
	push(@original_position, $item);
	if($_ == '0') {
		say "magic hehe";
		$magic_zero = $item;
	}
}

print_ll($ll);

for(my $z = 0; $z < 10; $z++) {
	for(my $i = 0; $i < @original_position; $i++) {
		# We get the item in original order since we use pointers to the LL where the updates happen.
		my $item = $original_position[$i];
		say "$i: $item->{value}";

		my $val = $item->{value} % (scalar(@original_position) - 1);
		say "\tneed to move $val times";
		# We need to move some positions forward or backward which means walking the chain
		if($val > 0) { # move forward on the chain, wrap back to head if needed.
			my $correct_position = $item;
			my $have_unlinked = 0;
			while($val--) {
				if($correct_position->{next} == undef) {
					$correct_position = $ll->{head};
				} else {
					$correct_position = $correct_position->{next};
				}
				if(! $have_unlinked) {
					unlink_item($ll, $item);
					$have_unlinked = 1;
				}
			}
			insert_item_after($ll, $correct_position, $item);
		} elsif($val < 0) {
			my $correct_position = $item;
			$val--; # because our function is called "insert_item_after" we need to go one further.
			my $have_unlinked = 0;
			while($val++) {
				if($correct_position->{prev} == undef) {
					$correct_position = $ll->{tail};
				} else {
					$correct_position = $correct_position->{prev};
				}
				if(! $have_unlinked) {
					unlink_item($ll, $item);
					$have_unlinked = 1;
				}
			}
			unlink_item($ll, $item);
			insert_item_after($ll, $correct_position, $item);

		} else { say "it's zero so do nothing" }
	}
}

# Now everything is reshuffled, we get the 1000th, 2000th and 3000th item after zero.
my $sum = 0;
my $j = $magic_zero;
for(my $i = 1; $i <= 3000; $i++) {
	if($j->{next} == undef) {
		$j = $ll->{head};
	} else {
		$j= $j->{next};
	}
	if($i == 1000 || $i == 2000 || $i == 3000) {
		say "Special item is: $j->{value}";
		$sum += $j->{value};
	}
}
say "Solution: $sum";


sub create_ll {
	my %ll = (
		'size' => 0,
		'head' => undef,
		'tail' => undef,
		'direction' => 'prev' # Means that the Top is in the front and you need to call 'next' on the items to go lower and find N°10.000
	);
	return \%ll;
}

sub create_item {
	my $value = shift;
	my %item = ( 'value' => $value, 'prev' => undef, 'next' => undef );
	return \%item;
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

sub unlink_item {
	my $ll = shift;
	my $item = shift;
	my $prev = $item->{prev};
	my $next = $item->{next};
	$item->{next} = undef;
	$item->{prev} = undef; # Clearing any links

	if($prev && $next) {
		$prev->{next} = $next;
		$next->{prev} = $prev;
	} elsif(!$prev && $next) {
		$ll->{head} = $next;
		$next->{prev} = undef;
	} elsif(!$next && $prev) {
		$prev->{next} = undef;
		$ll->{tail} = $prev;
	}

	$ll->{size}--;
}

sub insert_item_after {
	my ($ll, $item, $new_item) = @_;
	if($item->{next} == undef) { # Need to update tail
		$ll->{tail} = $new_item;
		$item->{next} = $new_item;
		$new_item->{prev} = $item;
	} else {
		my $next = $item->{next};
		$next->{prev} = $new_item;
		$item->{next} = $new_item;
		$new_item->{prev} = $item;
		$new_item->{next} = $next;
	}

	$ll->{size}++;
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

sub print_ll {
	my $ll = shift;
	my $i = $ll->{head};
	while($i) {
		print $i->{value} . '->';
		$i = $i->{next};
	}
	print "\n";
}
