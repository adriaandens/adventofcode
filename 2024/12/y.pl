use v5.36;

my @map = ();
my $width;
my $height = 0;
my $b = 0;
while(<DATA>) {
	chomp;
	my @row = split //;
	push @row, '.';
	unshift @row, '.';
	$width = @row;
	if(!$b) {
		my $r = '.' x $width;
		my @rr = split //, $r;
		push @map, \@rr;
		$height++;
		$b = 1;
	}
	push @map, \@row;
	$height++;
}
my $r = '.' x $width;
my @rr = split //, $r;
push @map, \@rr;
$height++;

say "Grid is $width width and $height height";

my @dir = ([0,1],[0,-1],[1,0],[-1,0]);
my @regions = ();
my %crawled = ();
my $prev_val = '.';
for(my $i = 1; $i < $width - 1; $i++) {
	for(my $j = 1; $j < $height - 1; $j++) {
		#if($map[$i][$j] ne $prev_val && !$crawled{$i . '#' . $j}) {
		if(!$crawled{$i . '#' . $j}) {
			my %region = (val => $map[$i][$j], borders => 0, items => []);
			push @regions, crawl($i, $j, $map[$i][$j], \%region);
			say $map[$i][$j];
			#$prev_val = $map[$i][$j];
		}
	}
}

my $total = 0;
foreach my $r (@regions) {
	say $r->{val};
	say "borders: " . $r->{borders};
	say "item count: " . scalar(@{$r->{items}});
	$total += calc_sides(@{$r->{items}}) * scalar(@{$r->{items}});
	foreach my $i (@{$r->{items}}) {
		say "\t[" . $i->[0] . ',' . $i->[1] . ']';
	}
}
say "Sol: $total";

sub crawl {
	my ($r, $c, $val, $region) = @_;
	return undef if($crawled{$r . "#" . $c});
	my $borders = 4;
	$crawled{$r . '#' . $c} = 1;
	push @{$region->{items}}, [$r, $c];
	foreach(@dir) {
		if($map[$r+$_->[0]][$c+$_->[1]] eq $val) { # belongs to the same region
			crawl($r+$_->[0], $c+$_->[1], $val, $region);
			$borders--;
		}
	}
	$region->{borders} += $borders;
	return $region;
}

sub calc_sides {
	return 1
}

__DATA__
AAAA
BBCD
BBCC
EEEC

RRRR
RRRR
  RRR
if you have 4 borders with same val == interior of a shape, not interesting
if you have 2 borders == you are a corner if one is north/south & other west/east!
	you are a funnel if both its north+south or west+east
if you have 3 borders == you can be many things
if you have 1 border == you are a stub
