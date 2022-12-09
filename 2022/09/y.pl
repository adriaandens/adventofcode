my $snake = create_snake(10);
my @positions = ();
while(<>) {
	chomp;
	my ($direction, $amount) = /(\w) (\d+)/;
	if($direction eq 'R') {
		print "== R $amount ==\n";
		while($amount--) {
			$snake->{head}->{c} += 1;
			move_tail();
		}
	}

	if($direction eq 'U') {
		print "== U $amount ==\n";
		while($amount--) {
			$snake->{head}->{r} -= 1;
			move_tail();
		}
	}

	if($direction eq 'L') {
		print "== L $amount ==\n";
		while($amount--) {
			$snake->{head}->{c} -= 1;
			move_tail();
		}
	}

	if($direction eq 'D') {
		print "== D $amount ==\n";
		while($amount--) {
			$snake->{head}->{r} += 1;
			move_tail();
		}
	}

	print_ll($snake);
}

print_ll($snake);

my %uniq = ();
foreach(@{$snake->{tail}->{pos}}) {
	$uniq{$_} = 1;
}
print "Total: " . keys(%uniq) . "\n";

sub move_tail {
	my $s = $snake->{head};
	while($s->{next}) {
		my $name = $s->{name};
		my $k = $s->{r};
		my $l = $s->{c};

		my $name_next = $s->{next}->{name};
		my $i = $s->{next}->{r};
		my $j = $s->{next}->{c};
	

		print "Position $name: ($k, $l) ; Position $name_next: ($i, $j)\n";
		if($k == $i && $l == $j) {
			print "\t$name and $name_next are in the same position\n";
			# we don't need to move the tail
		} elsif($k == $i && abs($j - $l) == 1) {
			print "\t$name is just one step away horizontally\n";
			# we don't need to move the tail
		} elsif($k == $i && $l - $j > 1) {
			print "\t$name is two steps away horizontally\n";
			$j++;
		} elsif($k == $i && $j - $l > 1) {
			print "\t$name is two steps away horizontally\n";
			$j--;
		} elsif($l == $j && abs($k - $i) == 1) {
			print "\t$name is one step away vertically\n";
			# we don't need to move the tail
		} elsif($l == $j && $k - $i > 1) {
			print "\t$name is two step away vertically\n";
			$i++;
		} elsif($l == $j && $i - $k > 1) {
			print "\t$name is two step away vertically\n";
			$i--;
		} else {
			print "\t$name is diagonally from tail\n";
			if(abs($k - $i) == 1 && abs($l - $j) == 1) {
				print "\t$name is diagonally one away from $name_next\n";
				# nothing to do yet
			} else {
				if(($k == $i - 1 && $l == $j - 2) || ($k == $i - 2 && $l == $j - 1) || ($k == $i - 2 && $l == $j - 2)) {
					# do (i-1,j-1)
					$i--; $j--;
				} elsif(($k == $i - 1 && $l == $j + 2) || ($k == $i - 2 && $l == $j + 1) || ($k == $i - 2 && $l == $j + 2)) {
					# do i-1, j+1
					$i--; $j++;
				} elsif(($k == $i + 1 && $l == $j - 2) || ($k == $i + 2 && $l == $j - 1) || ($k == $i + 2 && $l == $j - 2)) {
					# do i+1, j-1
					$i++; $j--;
				} elsif(($k == $i + 1 && $l == $j + 2) || ($k == $i + 2 && $l == $j + 1) || ($k == $i + 2 && $l == $j + 2)) {
					# do i+1, j+1
					$i++; $j++;
				} else {
					print "\tWEIRD\n";
					exit(1);
				}
			}
		}
		print "\t\tNew position $name_next: ($i, $j)\n";
		$s->{next}->{r} = $i;
		$s->{next}->{c} = $j;
		push(@{$s->{next}->{pos}}, "$i-$j");

		$s = $s->{next};
	}
}

sub create_snake {
	my $length = shift;
	my $snake = create_ll();
	foreach(0..$length-1) {
		my $name = "tail$_";
		$name = "head" if $_ == 0;
		my $item = create_item(0, 0, $name);
		add_item_to_tail_ll($snake, $item);
	}
	print_ll($snake);
	return $snake;
}

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
	my ($r, $c, $name) = @_; # row and col number
	my @pos = ();
	my %item = ( 'name' => $name, 'r' => $r, 'c' => $c, 'pos' => \@pos, 'prev' => undef, 'next' => undef );
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

sub print_ll {
	my $ll = shift;
	my $i = $ll->{head};
	while($i) {
		print "(" . $i->{r} . ", " . $i->{c} . ")->";
		$i = $i->{next};
	}
	print "\n";
}

__END__
Because we need to keep track of a longer snake, I created a Linked List datastructure that is effectively a snake in pointers.

We also need to cover extra possible positions in the logic.

Position before:
......
....H.
....1.
.432..
5.....  (5 covers 6, 7, 8, 9, s)

-> Head moves up 1
....H.
......
....1.
.432..
5.....  (5 covers 6, 7, 8, 9, s)

-> Tail 1 follows
....H.
....1.
......
.432..
5.....  (5 covers 6, 7, 8, 9, s)

-> Tail 2 follows
....H.
....1.
....2.
.43...
5.....  (5 covers 6, 7, 8, 9, s)

-> Tail 3 follows
....H.
....1.
...32.
.4....
5.....  (5 covers 6, 7, 8, 9, s)

-> Tail 4 follows
....H.
....1.
..432.
......
5.....  (5 covers 6, 7, 8, 9, s)

And then we get in a situation that we didn't have before.
If we take the grid from before:
#######
# . . #
#.H H.#
#  T  #
#.H H.#
# . . #
#######

We see that tail 4 moved to a position that was not possible in part 1.
So our grid becomes:
#######
#A. .B#
#.H H.#
#  T  #
#.H H.#
#C. .D#
#######

A, B, C and D are new positions and thus require a bit of extra logic to cover them. The solution is the same as in part 1, move the tail to the position where H was before.
