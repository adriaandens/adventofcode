use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
my $debug = 0;
my @seeds = ();
my @soils = ();
my @fertilizers = ();
my @waters = ();
my @lights = ();
my @temps = ();
my @hums = ();
my @locs = ();

# Tests
open(my $f, '<', 'small_input.txt') or die;
parse_seeds($f);
is($seeds[0]->{start}, 79, "Start of seed range 1 is 79");
is($seeds[0]->{end}, 92, "End of seed range 1 is 92");
is($seeds[1]->{start}, 55, "Start of seed range 2 is 55");
is($seeds[1]->{end}, 67, "End of seed range 2 is 67");
<$f>;

my %mapped_range1 = ("start" => 0, "end" => 99);
my @ranges = (\%mapped_range1);
my @new_ranges = split_src_range_up($seeds[0], \@ranges);
is($new_ranges[0]->{start}, 79, "owkee");
is($new_ranges[0]->{end}, 92, "owkee");

say "TEST 1 ###";
%mapped_range1 = ("start" => 20, "end" => 30);
my %new_source = ("start" => 10, "end" => 70);
@ranges = (\%mapped_range1);
@new_ranges = split_src_range_up(\%new_source, \@ranges);
foreach my $i (@new_ranges) {
	say "Range: [" . $i->{start} . ", " . $i->{end} . "]";
}

say "TEST 2 ###";
%mapped_range1 = ("start" => 20, "end" => 30);
my %mapped_range2 = ("start" => 40, "end" => 50);
%new_source = ("start" => 10, "end" => 70);
@ranges = (\%mapped_range1, \%mapped_range2);
@new_ranges = split_src_range_up(\%new_source, \@ranges);
foreach my $i (@new_ranges) {
	say "Range: [" . $i->{start} . ", " . $i->{end} . "]";
}


say "TEST 3 ###";
%mapped_range1 = ("start" => 20, "end" => 30);
%mapped_range2 = ("start" => 40, "end" => 50);
my %mapped_range3 = ("start" => 60, "end" => 90);
%new_source = ("start" => 10, "end" => 70);
@ranges = (\%mapped_range1, \%mapped_range2, \%mapped_range3);
@new_ranges = split_src_range_up(\%new_source, \@ranges);
foreach my $i (@new_ranges) {
	say "Range: [" . $i->{start} . ", " . $i->{end} . "]";
}

# LETS GOOOOOOOOOOOOOOOOOOOOOOOOOO

my @desties = parse_dests($f);
is($desties[0]->{start}, 98, "start destie is 98");
is($desties[0]->{end}, 99, "end destie is 99");
is($desties[0]->{calc}, -48, "calc destie is -48");
is($desties[1]->{start}, 50, "start destie is 50");
is($desties[1]->{end}, 97, "end destie is 97");
is($desties[1]->{calc}, 2, "calc destie is 2");


my @splitted_sourcies = split_sourcies(\@seeds, \@desties);
my @new_sourcies = mappie(\@splitted_sourcies, \@desties);
foreach my $i (@new_sourcies) {
	say "Range: [" . $i->{start} . ", " . $i->{end} . "]";
}

@desties = parse_dests($f); # fertilizers
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # water
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # light
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # temp
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # humidity
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # location
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

foreach my $i (@new_sourcies) {
	say "Range: [" . $i->{start} . ", " . $i->{end} . "]";
}

my $min = $new_sourcies[0]->{start};
my $i = 0;
foreach(@new_sourcies) {
	$min = $_->{start} if $_->{start} < $min;
}
say "TEST gives $min as minimum";

sub split_sourcies {
	my ($sources, $dests) = @_;
	my @sourcies = ();
	foreach(@{$sources}) {
		push @sourcies, split_src_range_up($_, $dests);
	}
	return @sourcies;
}


#mappie($f, \@seeds, \@soils);
#mappie($f, \@soils, \@fertilizers);
#mappie($f, \@fertilizers, \@waters);
#mappie($f, \@waters, \@lights);
#mappie($f, \@lights, \@temps);
#mappie($f, \@temps, \@hums);
#mappie($f, \@hums, \@locs);

done_testing();

# Code
sub resett {
	@seeds = ();
	@soils = ();
	@fertilizers = ();
	@waters = ();
	@lights = ();
	@temps = ();
	@hums = ();
	@locs = ();

	@desties = ();
	@splitted_sourcies = ();
	@new_sourcies = ();
}

sub parse_seeds {
	my $f = shift;
	$_ = <$f>;
	
	my @numbers = $_ =~ m/(\d+)/g;
	my $i = 0;
	while($i < scalar(@numbers)) {
		my $start = $numbers[$i];
		my $len = $numbers[$i+1];
		my %seed_range = ("start" => $start, "end" => $start + $len - 1);
		push @seeds, \%seed_range;
		$i += 2;
	}
}

sub parse_dests {
	my $f = shift;
	my @dests = ();

	<$f>; # Header line
	my $line = <$f>;
	chomp($line);
	say "Line is $line";
	while($line) {
		my ($dst, $src, $len) = $line =~ m/(\d+) (\d+) (\d+)/;
		my %mapper = ("start" => $src, "end" => $src + $len - 1, "calc" => $dst - $src);
		push @dests, \%mapper;
		$line = <$f>;
		chomp($line) if $line;
		say "Line is $line" if $line;
	}

	return @dests;
}

sub mappie {
	my $src_arr = shift;
	my $dst_arr = shift;

	my @desties = ();
	# So if we did our work correctly in previous steps
	# Each source range either fits fully in a dest range
	# Or it's not in any destination range.

	foreach my $s (@{$src_arr}) {
		my $found_dest_range = 0;
		foreach my $d (@{$dst_arr}) {
			if(is_fully_in_range($s->{start}, $s->{end}, $d->{start}, $d->{end})) {
				$found_dest_range = 1;
				my %new_range = ("start" => $s->{start} + $d->{calc}, "end" => $s->{end} + $d->{calc});
				push @desties, \%new_range;
			} elsif(is_fully_before_or_behind($s->{start}, $s->{end}, $d->{start}, $d->{end})) {
				# Don't need to do anything for this dest range... continue...
			} else {
				die "Should not happen";
			}
		}

		if(!$found_dest_range) { # No range found, it just stays as is.
			push @desties, $s;
		}
	}

	return @desties;
}

# Input is one source range to handle
# Output is 1 or more source ranges that can be mapped in one move
sub split_src_range_up {
	my ($s, $ranges) = @_;
	
	my @splitz = ($s);
	my $i = 1;
	foreach my $mapped_region (@{$ranges}) {
		say "Mapped region $i: [" . $mapped_region->{start} . ", " . $mapped_region->{end} . "]";
		$i++;

		my @new_splitz = ();
		foreach my $src (@splitz) {
			say "\tSource range: [" . $src->{start} . ", " . $src->{end} . "]";
			if(is_fully_in_range($src->{start}, $src->{end}, $mapped_region->{start}, $mapped_region->{end})) {
				say "\t\tSource is fully in one destination range";
				push @new_splitz, $src;
				
			}
			elsif(is_overarching($src->{start}, $src->{end}, $mapped_region->{start}, $mapped_region->{end})) {
				say "\t\tSource is so big it starts before and ends after the destination range";
				my %before = ("start" => $src->{start}, "end" => $mapped_region->{start} - 1);
				my %inside = ("start" => $mapped_region->{start}, "end" => $mapped_region->{end});
				my %after = ("start" => $mapped_region->{end} + 1, "end" => $src->{end});

				push @new_splitz, \%before;
				push @new_splitz, \%inside;
				push @new_splitz, \%after;
			}
			elsif(is_partially_before($src->{start}, $src->{end}, $mapped_region->{start}, $mapped_region->{end})) {
				say "\t\tSource is in front of dest range but ends within the dest range";
				my %before = ("start" => $src->{start}, "end" => $mapped_region->{start} - 1);
				my %inside = ("start" => $mapped_region->{start}, "end" => $src->{end});
				push @new_splitz, \%before;
				push @new_splitz, \%inside;
			}
			elsif(is_partially_behind($src->{start}, $src->{end}, $mapped_region->{start}, $mapped_region->{end})) {
				say "\t\tSource start is within dest range but end is outside of this dest range";
				my %inside = ("start" => $src->{start}, "end" => $mapped_region->{end});
				my %after = ("start" => $mapped_region->{end} + 1, "end" => $src->{end});
				push @new_splitz, \%inside;
				push @new_splitz, \%after;
			}
			elsif(is_fully_before_or_behind($src->{start}, $src->{end}, $mapped_region->{start}, $mapped_region->{end})) {
				say "\t\tSource range has nothing to do with the dest range";
				push @new_splitz, $src;
			}

		}
		# Overwrite
		@splitz = @new_splitz;
	}

	return @splitz;
}

sub is_fully_in_range { $_[0] >= $_[2] && $_[1] <= $_[3] ? 1 : 0; }
sub is_overarching { $_[0] < $_[2] && $_[1] > $_[3] ? 1 : 0; }
sub is_partially_before { $_[0] < $_[2] && $_[1] >= $_[2] &&  $_[1] <= $_[3] ? 1 : 0; }
sub is_partially_behind { $_[0] >= $_[2] && $_[0] < $_[3] && $_[1] > $_[3] ? 1 : 0; }
sub is_fully_before_or_behind { $_[1] < $_[2] || $_[0] > $_[3] ? 1 : 0; }

sub within_range {
	my ($s, $src, $len) = @_;
	return 1 if $s >= $src && $s < $src + $len;
	return 0;
}

exit(0) if $debug == 1;

resett();
open($f, '<', 'input.txt') or die;
parse_seeds($f); # this fills @seeds

@desties = parse_dests($f); # soil
@splitted_sourcies = split_sourcies(\@seeds, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # fertilizers
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # water
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # light
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # temp
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # humidity
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

@desties = parse_dests($f); # location
@splitted_sourcies = split_sourcies(\@new_sourcies, \@desties);
@new_sourcies = mappie(\@splitted_sourcies, \@desties);

$min = $new_sourcies[0]->{start};
$i = 0;
foreach(@new_sourcies) {
	$min = $_->{start} if $_->{start} < $min;
}
say "Solution is: $min";

# Numbers

__DATA__
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
