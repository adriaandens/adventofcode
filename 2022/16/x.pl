use strict;
use warnings;
use feature 'say';

my %valves = ();
while(<>) {
	chomp;
	/Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/;
	my $valve_name = $1;
	my $flow_rate = $2;
	my @tunnels;
	#if($3 =~ /,/) {  
		@tunnels = split /, /, $3;
	#} else {
	#	@tunnels = ($3);
	#}
	my $valve = create_valve($valve_name, $flow_rate, @tunnels);

	$valves{$valve_name} = $valve;
}

foreach(keys(%valves)) {
	say "Valve $valves{$_}->{name} - flow $valves{$_}->{flow}";
	my @tunnels = @{$valves{$_}->{tunnels}};
	say "\t@tunnels";
}

my $time = 30;
my $position = "AA";
my %mem = ();

my $m = consider_options($position, $time);
say "Max found is: $m";

sub consider_options {
	my ($pos, $t, @opened) = @_;
	#say "Position: $pos, time left: $t, Opened valves: @opened";

	return 0 if($t <= 0);

	my $key = "$pos#$t#" . sortlist(@opened);
	return $mem{$key} if exists($mem{$key});
	
	my @op = @opened;
	push(@op, $pos);
	my $max = 0;
	foreach my $option (@{$valves{$pos}->{tunnels}}) {
		# Option 1: Moving directly through
		my $option1_max = consider_options($option, $t-1, @opened);

		# Option 2: Opening the current valve $pos
		my $option2_max = 0;
		if(not_opened($pos, @opened)) {
			$option2_max = $t-1;
			$option2_max = $option2_max * int($valves{$pos}->{flow});
			if($valves{$pos}->{flow} > 0) {
				$option2_max += consider_options($option, $t-2, @op);
			}
		}

		$max = max($max, $option1_max, $option2_max);
	}

	$mem{$key} = $max;

	return $max;
}

sub not_opened {
	my $x = shift;
	my $not_found = 1;
	foreach(@_) {
		$not_found = 0 if $_ eq $x;
	}
	return $not_found;
}

sub sortlist {
	my @a = sort @_;
	my $s = "@a";
	return $s;
}

sub max {
	my $max = 0;
	foreach(@_) {
		$max = $_ if $_ > $max;
	}
	return $max;
}

sub create_valve {
	my ($name, $flow_rate, @tunnels) = @_;
	my %valve = (
		name => $name,
		flow => int($flow_rate),
		tunnels => \@tunnels
	);
	return \%valve;
}
