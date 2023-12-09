use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my $debug = 0;
my @data = ();


# Tests
@data = <DATA>;
is(round($data[0]), 18, "First round is 18");
is(round($data[1]), 28, "Second round is 28");
is(round($data[2]), 68, "Third round is 68");

is(x(@data), 114, "Total is 114");
done_testing();

# Code
sub resett {
	@data = ();
}

sub not_zeroes {
	my $arr = shift;
	my $not_zero = 0;
	foreach(@{$arr}) {
		if($_ != 0) {
			$not_zero = 1;
			last;
		}
	}
	return $not_zero;
}

sub round {
	my $line = shift;
	my @numbers = split /\s+/, $line;
	my @rows = ();
	push @rows, \@numbers;
	my $current_row = $rows[0];
	while(not_zeroes($current_row)) {
		my @new_row = ();
		foreach my $i (0..scalar(@{$current_row})-2) {
			my $difference = ${$current_row}[$i+1] - ${$current_row}[$i];
			push @new_row, $difference;
		}
	
		say "New row: @new_row" if $debug;
		push @rows, \@new_row;
		$current_row = \@new_row;
	}

	# Add new values
	push @{$rows[$#rows]}, 0;
	say "Rows is " . scalar(@rows) . " in size" if $debug;
	my $i = scalar(@rows) - 1;
	while($i != 0) {
		my $current_line = $rows[$i];
		my $size = scalar(@{$current_line});
		my $last_value_current_line = ${$current_line}[$size-1];

		my $prev_line = $rows[$i-1];
		my $prev_size = scalar(@{$prev_line});
		my $last_value_prev_line = ${$prev_line}[$prev_size-1];

		say "\tPrev value is $last_value_prev_line, current_line is $last_value_current_line" if $debug;
		my $sum = $last_value_prev_line + $last_value_current_line;
		say "\tSum of those is $sum";
		
		push @{$prev_line}, $sum;
		$i--;
	}

	my $first_line = $rows[0];
	my $new_last_value = ${$first_line}[scalar(@{$first_line})-1];
	return $new_last_value;

}

sub x {
	my $sum = 0;
	foreach(@_) {
		$sum += round($_);
	}
	return $sum;
}

exit(0) if $debug == 1;
resett();
@data = <STDIN>;
say "Solution: " . x(@data);

# Numbers

__DATA__
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
