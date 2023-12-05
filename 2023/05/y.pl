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
	
	my @numbers = $_ =~ m/(\d+)/g;
	my $i = 0;
	while($i < scalar(@numbers)) {
		my $start = $numbers[$i];
		my $len = $numbers[$i+1];
		push @seeds, ($start..($start+$len-1));
		$i += 2;
	}
	say "@seeds";
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
