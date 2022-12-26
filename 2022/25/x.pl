use feature 'say';
use Test::More;

run_tests();
#small_input();
done_testing();

open(F, '<', 'input.txt') or die "bluh";
my $sum = 0;
while(<F>) {
	chomp;
	$sum += x($_);
}
close(F);

say "Real input solution: $sum";
say a($sum);

# snafu to decimal
sub x {
	my $snafu = shift;
	my @chars = reverse split //, $snafu;

	my $base = 5;
	my $sum = 0;
	for(my $i = 0; $i < @chars; $i++) {
		my $val = ($base ** $i) * decval($chars[$i]);
		$sum += $val;
	}

	return $sum;
}

sub decval {
	my $x = shift;
	return 2 if $x eq '2';
	return 1 if $x eq '1';
	return 0 if $x eq '0';
	return -1 if $x eq '-';
	return -2 if $x eq '=';
}

sub snafuval {
	my $x = shift;
	return '2' if $x == 2;
	return '1' if $x == 1;
	return '0' if $x == 0;
	return '-' if $x == -1;
	return '=' if $x == -2;
}
# Decimal to snafu
sub a {
	my $dec = shift;
	my $base = 5;

	my $digit_count = how_many_digits_do_we_need($dec);

	# Now from highest to lowest number, we go and pick the correct digit.
	my $prefix = 0;
	my $prefix_snafu = "";
	my @intervals = get_intervals($digit_count);
	for(my $i = 0; $i < @intervals; $i++) {
		if($intervals[$i]->{min} <= $dec && $intervals[$i]->{max} >= $dec) {
			say "$intervals[$i]->{min} to $intervals[$i]->{max} is the correct interval";
			$prefix_snafu .= snafuval($i-2);
			$prefix = $intervals[$i]->{min};
		}
	}
	say "Prefix in SNAFU: $prefix_snafu";
	say "Minimum of interval in decimal is: $prefix";
	$digit_count--;

	while(--$digit_count > -1) { # Lower by one
		my @inties = get_normal_interval($digit_count);
		my $i = -2;
		foreach(@inties) {
			say "$_->{min} to $_->{max}";
			my $new_prefix = $prefix + $_->{min};
			if($new_prefix <= $dec && $prefix + $_->{max} >= $dec) {
				say "Found the interval again.";
				$prefix = $new_prefix;
				$prefix_snafu .= snafuval($i);
			}
			$i++;
		}
		#$digit_count--;
	}

	say "Sol: " . $prefix_snafu;
	$prefix_snafu;
}

# TODO: Dit maken, voor power 1, genereer [0,4][5,9][10,14][15,19][2à,24]
sub get_normal_interval {
	my $power = shift;
	say "get_normal_interval($power)";
	my $base = 5;
	my @intervals = ();

	my $prev_interval = 0;
	foreach my $x (0..4) {
		my $min = $prev_interval;
		my $max = $min + ($base ** $power) - 1;
		my %intie = ("min" => $min, "max" => $max);
		push(@intervals, \%intie);
		$prev_interval = $max + 1;
	}

	return @intervals;
}

sub get_intervals {
	$digits = shift;
	my $base = 5;
	my @intervals = ();

	foreach my $x (-2..2) {
		say "hey";
		my $y = ($base ** ($digits-1)) * $x;
		my $min = $y + min_for($digits-1);
		my $max = $y + max_for($digits-1);

		say "Digits $digits, first digit being $x gives [$min, $max]";

		my %intie = ("min" => $min, "max" => $max);
		push(@intervals, \%intie);
	}

	return @intervals;
}

sub min_for {
	my $digits = shift;
	my $base = 5;

	return -2 if $digits == 1;

	my $sum = 0;
	$digits--;
	$sum += ($base ** $digits) * -2;
	$sum += min_for($digits);
	
	say "min sum is $sum";

	return $sum;
}
sub max_for {
	my $digits = shift;
	my $base = 5;

	return 2 if $digits	== 1;

	my $sum = 0;
	$digits--;
	$sum += ($base ** $digits) * 2;
	$sum += max_for($digits);
	
	say "max sum is $sum";

	return $sum;
}

sub how_many_digits_do_we_need {
	my $dec = shift;
	my $base = 5;
	
	my $i = 0;
	my $not_big_enough = 1;
	while($not_big_enough) {
		my $max = ($base ** ($i+1)) - 1;
		# Normally it's [0, 4], [0, 24], [0, 124], ....

		# But here it's [-2,2], [-12, 12], [-62, 62], ...
		$max = $max / 2;
		my $min = -1 * $max;

		$i++;
		last if $min <= $dec && $max >= $dec;
	}

	say "Dec $dec needs $i digits";
	return $i;
}

sub run_tests {
	ok(x("1") == 1, "SNAFU 1 is 1");
	ok(x("2") == 2, "SNAFU 2 is 2");
	ok(x("1=") == 3, "SNAFU 1= is 3");
	ok(x("1-") == 4, "SNAFU 1- is 4");
	ok(x("10") == 5, "SNAFU 10 is 5");
	ok(x("11") == 6, "SNAFU 11 is 6");
	ok(x("12") == 7, "SNAFU 12 is 7");
	ok(x("1=11-2") == 2022, "SNAFU 1=11-2 is 2022");
	ok(x("1121-1110-1=0") == 314159265, "SNAFU is correct");

	ok(how_many_digits_do_we_need(2) == 1, "Dec 2 needs 1 SNAFU digit");
	ok(how_many_digits_do_we_need(3) == 2, "Dec 3 needs 2 SNAFU digits");
	ok(how_many_digits_do_we_need(20) == 3, "Dec 20 needs 3 SNAFU digits");

	ok(max_for(3) == 62, "Max for 3 digits is 62");
	ok(min_for(3) == -62, "Min for 3 digits is -62");
	ok(min_for(2) == -12, "Min for 2 digits is -12");
	ok(max_for(2) == 12, "Max for 2 digits is 12");

	#ok(a(1) eq '1', "Dec 1 is SNAFU 1");
	#ok(a(2) eq '2', "Dec 2 is SNAFU 2");
	#ok(a(3) eq '1=', "Dec 3 is SNAFU 1=");
	#ok(a(4) eq '1-', "Dec 4 is SNAFU 1-");
	#ok(a(5) eq '10', "Dec 5 is SNAFU 10");
	#ok(a(6) eq '11', "Dec 6 is SNAFU 11");
	#ok(a(7) eq '12', "Dec 7 is SNAFU 12");
	ok(a(15) eq '1=0', "Dec 15 is SNAFU 1=0");
	ok(a(20) eq '1-0', "Dec 20 is SNAFU 1-0");
	ok(a(2022) eq '1=11-2', "Dec 2022 is SNAFU 1=11-2");
}

sub small_input {
	my $input = <<HERE;
1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
HERE

	my $sum = 0;
	foreach(split /\n/, $input) {
		$sum += x($_);
	}
	ok($sum == 4890, "Small input decimal sum is correct");
	ok(a($sum) eq "2=-1=0", "Decimal sum in SNAFU is 2=-1=0");
}

__END__

It's not just base 5 but actually:
Rightmost digit: =-012: [-2,2]

If secondrightmost digit is =: 5**1 * -2 + [-2, 2] = [-12, -8]
If secondrightmost digit is -: 5**1 * -1 + [-2, 2] = [-7, -2]
If secondrightmost digit is 0: 5**1 * 0 + [-2, 2] = [-2, 2]
If secondrightmost digit is 1: 5**1 + [-2, 2] == [3, 7] 
If secondrightmost digit is 2: 5**2 + [-2, 2] == [8, 12] 


