use v5.44;

say "hallo";
my @indices_accessed = ();

my @alfabet = qw/A B C D E F G H I J K L M N O P Q R S T U V W X Y Z/;
my $pos = 0;
my @letters = ();
while(<>) {
	chomp;
	say "got: $_";
	$pos += $_;
	say "New position: $pos";

	# We want to access something at index $_
	# get all indices smaller or equal than that index
	my @lte_indices = grep { $_ <= $pos } @indices_accessed;
	say "Smoller indices: @lte_indices";
	my $count = scalar(@lte_indices);
	say "Which are $count indices";

	# We are currently at $pos in an infinite string of A..Z
	# Let's figure out what the current char is
	my $letter_index = ($pos + $count) % 26;
	say "LETTER: $alfabet[$letter_index]";
	push @letters, $alfabet[$letter_index];
	
	foreach my $i (0..$#indices_accessed) {
		$indices_accessed[$i]-- if($indices_accessed[$i] > $pos)
	}

	push @indices_accessed, $pos;
	say "New indices array: @indices_accessed";

	say "";
}

say join('', @letters);
