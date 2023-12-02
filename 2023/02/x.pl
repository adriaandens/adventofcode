use Test::More;
use feature 'say';

my @data = <DATA>;
say $data[0];
say $data[1];
say $data[2];
say $data[3];
say $data[4];

my $red = 12;
my $green = 13;
my $blue = 14;

# Write some tests
ok(1 == 1, "Dummy test");
ok(x($data[0]) == 1, "Game one is possible");
ok(x($data[1]) == 1, "Game two is possible");
ok(x($data[2]) == 0, "Game three is NOT possible");
ok(x($data[3]) == 0, "Game four is NOT possible");
ok(x($data[4]) == 1, "Game five is possible");

ok(z($data[0]) == 48, "Game one is 48");
ok(z($data[1]) == 12, "Game one is 12");
ok(z($data[2]) == 1560, "Game one is 1560");
ok(z($data[3]) == 630, "Game one is 630");
ok(z($data[4]) == 36, "Game one is 36");
# solve code

sub x {
	my $line = shift;
	my ($game_number, $shows_str) = $line =~ /^Game (\d+): (.*)$/;
	my @shows = split /;/, $shows_str;
	foreach my $s (@shows) {
		say "Show is $s";
		my ($r) = $s =~ m/(\d+) red/;
		say "Red is $r";
		return 0 if $r > $red;
		my ($b) = $s =~ m/(\d+) blue/;
		say "Blue is $b";
		return 0 if $b > $blue;
		my ($g) = $s =~ m/(\d+) green/;
		say "Green is $g";
		return 0 if $g > $green;
	}

	return 1;
}

sub z {
	my $line = shift;
	my ($game_number, $shows_str) = $line =~ /^Game (\d+): (.*)$/;
	my @shows = split /;/, $shows_str;
	my $r_min = 0;
	my $b_min = 0;
	my $g_min = 0;
	foreach my $s (@shows) {
		say "Show is $s";
		my ($r) = $s =~ m/(\d+) red/;
		say "Red is $r";
		$r_min = $r if $r_min < $r;
		my ($b) = $s =~ m/(\d+) blue/;
		say "Blue is $b";
		$b_min = $b if $b_min < $b;
		my ($g) = $s =~ m/(\d+) green/;
		say "Green is $g";
		$g_min = $g if $g_min < $g;
	}

	say "r $r_min - b $b_min - g $g_min";

	return $r_min * $b_min * $g_min;
}


done_testing();

my $sum = 0;
my $sum2 = 0;
while(<STDIN>) {
	my $result = x($_);
	$sum += $. if $result == 1;

	$result = z($_);
	$sum2 += $result;
}

say "Solution: $sum";
say "Solution 2: $sum2";


__DATA__
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
