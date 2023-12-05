use strict;
use warnings;
use Test::More;
use feature 'say';

# Global vars before any call in the tests
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
<$f>;
is($seeds[1], 14, "Seed 1 is 14");
mappie($f, \@seeds, \@soils);
is($soils[0], 81, "Seed 79 maps to soil 81");
is($soils[1], 14, "Seed 14 maps to soil 14");
is($soils[2], 57, "Seed 55 maps to soil 57");
is($soils[3], 13, "Seed 13 maps to soil 13");
mappie($f, \@soils, \@fertilizers);
is($fertilizers[0], 81, "Soil 81 maps to fertilizer 81");
is($fertilizers[1], 53, "Soil 14 maps to fertilizer 53");
is($fertilizers[2], 57, "Soil 57 maps to fertilizer 57");
is($fertilizers[3], 52, "Soil 13 maps to fertilizer 52");
mappie($f, \@fertilizers, \@waters);
is($waters[0], 81, "Fertilizer 81 maps to water 81");
is($waters[1], 49, "Fertilizer 53 maps to water 49");
is($waters[2], 53, "Fertilizer 57 maps to water 53");
is($waters[3], 41, "Fertilizer 52 maps to water 41");
mappie($f, \@waters, \@lights);
is($lights[0], 74, "Water 81 maps to light 74");
is($lights[1], 42, "Water 49 maps to light 42");
is($lights[2], 46, "Water 53 maps to light 46");
is($lights[3], 34, "Water 41 maps to light 34");
mappie($f, \@lights, \@temps);
is($temps[0], 78, "Light 74 maps to temp 78");
is($temps[1], 42, "Light 42 maps to temp 42");
is($temps[2], 82, "Light 46 maps to temp 82");
is($temps[3], 34, "Light 34 maps to temp 34");
mappie($f, \@temps, \@hums);
is($hums[0], 78, "Temp 78 maps to hum 78");
is($hums[1], 43, "Temp 42 maps to hum 43");
is($hums[2], 82, "Temp 82 maps to hum 82");
is($hums[3], 35, "Temp 34 maps to hum 35");
mappie($f, \@hums, \@locs);
is($locs[0], 82, "Hum 78 maps to loc 82");
is($locs[1], 43, "Hum 43 maps to loc 43");
is($locs[2], 86, "Hum 82 maps to loc 86");
is($locs[3], 35, "Hum 35 maps to loc 35");

my $i = 0;
my $min = $locs[$i];
foreach(@locs) {
	$min = $_ if $_ < $min;
}
is($min, 35, "The lowest location is 35");
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
}

sub parse_seeds {
	my $f = shift;
	$_ = <$f>;
	@seeds = m/(\d+)/g;
}

sub mappie {
	my $f = shift;
	my $src_arr = shift;
	my $dst_arr = shift;
	<$f>;
	my $line = <$f>;
	chomp($line);
	say "Line is $line";
	@{$dst_arr} = @{$src_arr};
	while($line) {
		my ($dst, $src, $len) = $line =~ m/(\d+) (\d+) (\d+)/;
		my $i = 0;
		foreach my $s (@{$src_arr}) {
			if(within_range($s, $src, $len)) {
				#say "Seed $s is in range of source [$src, " . ($src+$len) . "[";
				$$dst_arr[$i] = $dst + ($s - $src);
			} else {
				#say "Seed $s is not in range of source [$src, " . ($src+$len) . "[";
			}
			$i++;
		}

		$line = <$f>;
		chomp($line) if $line;
		say "Line is $line" if $line;
	}
}

sub within_range {
	my ($s, $src, $len) = @_;
	return 1 if $s >= $src && $s < $src + $len;
	return 0;
}

resett();
open(my $f, '<', 'input.txt') or die;
parse_seeds($f);
<$f>;
mappie($f, \@seeds, \@soils);
mappie($f, \@soils, \@fertilizers);
mappie($f, \@fertilizers, \@waters);
mappie($f, \@waters, \@lights);
mappie($f, \@lights, \@temps);
mappie($f, \@temps, \@hums);
mappie($f, \@hums, \@locs);

my $i = 0;
my $min = $locs[$i];
foreach(@locs) {
	$min = $_ if $_ < $min;
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
