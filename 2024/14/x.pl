use v5.36;

my $ticks = 100;
my @robots = ();
my $width = 101; # 101 or 11
my $height = 103; # 103 or 7
while(<DATA>) {
	my %robot = ();
	chomp;
	my ($c, $r, $cx, $rx) = (m/p=(\d+),(\d+) v=(-?\d+),(-?\d+)/);
	$robot{c} = $c; $robot{r} = $r;
	$robot{cx} = $cx; $robot{rx} = $rx;
	say "Robot pos: row=$r, kol=$c";
	push @robots, \%robot;
}

while($ticks-- > 0) {
	tick();
}

# Take a step
sub tick {
	foreach(@robots) {
		$_->{c} = ($_->{c} + $_->{cx}) % $width;
		$_->{r} = ($_->{r} + $_->{rx}) % $height;
		say "Robot pos: row=$_->{r}, kol=$_->{c}";
	}
}

say "### FINAL POSITION ###";
my ($q1, $q2, $q3, $q4) = (0, 0, 0, 0);
my @q = ([0, 0], [int($height/2), 0], [int($height/2), int($width/2)], [0, int($width/2)]);
my $mid_h = int($height/2);
my $mid_w = int($width/2);
foreach(@robots) {
	say "Robot pos: row=$_->{r}, kol=$_->{c}";
	$q1++ if $_->{r} < $mid_h && $_->{c} < $mid_w; # top left Quadrant
	$q2++ if $_->{r} < $mid_h && $_->{c} > $mid_w; # top right Quadrant
	$q3++ if $_->{r} > $mid_h && $_->{c} < $mid_w; # bottom left Quadrant
	$q4++ if $_->{r} > $mid_h && $_->{c} > $mid_w; # bottom right Quadrant
}
say "Sol: " . $q1*$q2*$q3*$q4;


__DATA__
p=99,12 v=19,18
p=90,98 v=47,-52
p=86,3 v=82,-13
p=13,8 v=-67,-47
p=36,45 v=28,65
p=71,35 v=-8,-62
p=75,8 v=-30,-21
p=3,46 v=-38,-96
p=1,89 v=78,18
p=47,59 v=-63,99
p=92,78 v=68,48
p=42,31 v=78,94
p=75,29 v=9,83
p=46,12 v=-29,48
p=80,16 v=-70,33
p=18,66 v=57,-97
p=60,12 v=89,-90
p=21,36 v=-41,-78
p=75,53 v=52,-62
p=18,79 v=45,51
p=20,29 v=63,-97
p=22,68 v=23,1
p=6,67 v=-24,-44
p=44,35 v=-54,29
p=33,80 v=28,-56
p=48,78 v=55,-22
p=88,79 v=99,69
p=12,96 v=-50,-59
p=6,57 v=80,61
p=98,31 v=-77,14
p=91,65 v=-13,20
p=52,53 v=-85,41
p=94,94 v=-15,5
p=69,75 v=-41,-11
p=98,77 v=71,-54
p=23,47 v=-61,-27
p=32,74 v=-11,96
p=22,87 v=-5,-75
p=65,22 v=26,71
p=1,67 v=13,69
p=32,96 v=-90,-94
p=17,17 v=-5,71
p=57,85 v=-92,28
p=52,32 v=-41,69
p=13,85 v=-43,-83
p=51,39 v=-38,32
p=64,17 v=91,82
p=97,86 v=-69,-70
p=98,94 v=46,-21
p=43,31 v=61,-24
p=42,58 v=-51,-42
p=5,46 v=-4,91
p=65,52 v=10,50
p=23,6 v=-42,29
p=54,25 v=4,44
p=5,19 v=-77,-74
p=44,77 v=-23,-26
p=10,70 v=6,-72
p=38,101 v=-50,-36
p=9,49 v=35,72
p=64,14 v=77,-78
p=21,2 v=-67,-6
p=34,97 v=-73,-37
p=77,13 v=-30,60
p=50,40 v=83,-58
p=99,85 v=-59,-87
p=65,0 v=-76,-48
p=44,94 v=-45,34
p=5,59 v=92,35
p=73,100 v=93,-71
p=50,20 v=-74,-97
p=9,33 v=-10,-89
p=54,49 v=-46,99
p=99,100 v=92,51
p=84,94 v=-53,-45
p=92,13 v=-61,69
p=19,52 v=56,-12
p=20,52 v=-38,-90
p=98,12 v=99,-22
p=46,23 v=95,-32
p=84,100 v=-70,70
p=19,69 v=58,-52
p=77,67 v=-51,31
p=11,6 v=18,-67
p=11,22 v=-50,-82
p=73,43 v=25,79
p=60,16 v=-58,-36
p=86,18 v=-88,71
p=21,50 v=-50,-88
p=17,20 v=-65,-54
p=38,26 v=67,71
p=22,60 v=-46,15
p=81,46 v=-39,16
p=25,98 v=22,-41
p=9,72 v=-94,8
p=82,59 v=-46,-34
p=71,41 v=-23,45
p=74,1 v=-70,32
p=96,17 v=-37,95
p=39,45 v=-6,-23
p=46,4 v=61,55
p=41,100 v=-35,-10
p=65,75 v=-1,-26
p=8,21 v=7,-32
p=43,71 v=-12,73
p=85,67 v=58,-41
p=73,7 v=31,-89
p=85,71 v=-93,-72
p=54,83 v=-46,-75
p=13,66 v=-24,-98
p=67,13 v=21,-21
p=1,33 v=24,-66
p=71,27 v=54,-78
p=69,86 v=42,35
p=17,28 v=-83,94
p=92,19 v=25,-68
p=92,84 v=-31,16
p=32,26 v=-6,54
p=20,97 v=-16,36
p=1,102 v=13,9
p=59,26 v=-68,91
p=92,44 v=-20,30
p=16,45 v=-83,34
p=30,69 v=-75,-46
p=51,64 v=-73,68
p=53,29 v=-57,-61
p=14,100 v=-15,86
p=80,41 v=-20,-81
p=5,92 v=-60,1
p=91,10 v=-49,98
p=0,62 v=-79,9
p=40,1 v=3,-70
p=81,32 v=-53,41
p=53,18 v=-46,94
p=69,96 v=-95,-82
p=32,92 v=-69,-30
p=73,83 v=-59,-65
p=74,67 v=-8,-99
p=71,45 v=-58,60
p=35,29 v=-51,-92
p=68,15 v=-92,-55
p=74,3 v=26,30
p=67,25 v=-58,22
p=31,46 v=-73,-92
p=29,69 v=45,23
p=48,78 v=-23,-29
p=41,13 v=-45,-78
p=57,8 v=-3,26
p=45,53 v=45,4
p=37,23 v=-62,41
p=41,90 v=-35,55
p=88,96 v=53,-71
p=38,15 v=-90,71
p=62,20 v=4,-88
p=64,19 v=15,-85
p=96,61 v=10,81
p=19,81 v=57,-45
p=53,11 v=67,44
p=51,83 v=66,85
p=29,76 v=-84,-26
p=63,23 v=-13,14
p=23,51 v=-18,-52
p=23,41 v=73,-55
p=99,75 v=-32,-14
p=68,20 v=79,45
p=27,74 v=45,42
p=55,96 v=47,-73
p=87,29 v=-93,22
p=20,76 v=-49,88
p=11,78 v=-67,-41
p=31,78 v=-12,-99
p=21,49 v=64,9
p=56,45 v=10,-4
p=67,97 v=-59,92
p=96,58 v=-49,96
p=36,51 v=-68,8
p=18,10 v=-79,-60
p=25,7 v=47,-55
p=12,101 v=40,-52
p=83,57 v=-42,-38
p=62,89 v=77,20
p=8,49 v=51,-54
p=12,98 v=-20,53
p=47,89 v=35,68
p=46,16 v=89,6
p=72,34 v=37,45
p=61,31 v=49,76
p=42,98 v=64,17
p=27,41 v=71,27
p=50,8 v=-1,-63
p=97,5 v=-56,9
p=41,58 v=5,-38
p=66,101 v=-64,13
p=67,95 v=-40,18
p=94,41 v=-37,73
p=89,102 v=-4,2
p=44,51 v=-84,65
p=9,89 v=29,89
p=28,29 v=5,29
p=76,4 v=-89,8
p=75,93 v=-75,89
p=38,6 v=-73,-2
p=19,1 v=-95,-6
p=61,76 v=-69,23
p=6,27 v=64,-24
p=97,76 v=47,28
p=62,86 v=50,-61
p=85,50 v=-93,-92
p=10,76 v=-83,31
p=58,42 v=52,-81
p=47,42 v=16,38
p=3,17 v=-66,52
p=58,84 v=-59,-36
p=91,76 v=20,-68
p=9,62 v=-10,-23
p=45,99 v=-85,-2
p=0,8 v=-77,17
p=53,70 v=-41,-23
p=32,96 v=6,89
p=67,33 v=26,37
p=94,86 v=47,47
p=26,74 v=-39,12
p=19,15 v=-55,16
p=60,76 v=93,-98
p=44,71 v=-49,-38
p=35,77 v=-1,-7
p=68,98 v=32,89
p=10,54 v=-23,-24
p=63,10 v=-77,50
p=75,61 v=71,80
p=35,78 v=-5,-55
p=74,23 v=15,-45
p=10,68 v=52,-34
p=45,43 v=8,-67
p=12,76 v=24,-75
p=62,73 v=-86,77
p=9,82 v=-38,-64
p=1,95 v=25,-64
p=67,30 v=-69,-20
p=92,25 v=-79,75
p=42,19 v=-46,-78
p=3,98 v=35,-83
p=89,102 v=53,90
p=25,10 v=-5,37
p=46,0 v=-74,29
p=12,40 v=-79,92
p=13,21 v=-56,-44
p=63,49 v=77,-27
p=3,12 v=83,-67
p=48,42 v=72,-62
p=37,74 v=-46,16
p=25,75 v=51,-26
p=84,35 v=81,-43
p=38,40 v=-63,19
p=77,13 v=-64,-48
p=95,13 v=-82,-44
p=81,41 v=-19,-81
p=33,81 v=-64,41
p=69,75 v=65,35
p=30,76 v=45,39
p=48,72 v=-29,39
p=74,10 v=78,-61
p=70,17 v=9,52
p=11,67 v=46,-87
p=35,72 v=-11,-46
p=86,37 v=-82,60
p=99,24 v=-91,56
p=92,46 v=-54,-23
p=93,12 v=76,-9
p=92,43 v=-97,-75
p=3,72 v=10,-79
p=13,83 v=13,8
p=78,80 v=3,-60
p=81,41 v=84,-73
p=93,9 v=-25,36
p=78,96 v=20,-37
p=40,50 v=-78,59
p=66,21 v=85,78
p=37,67 v=56,53
p=49,62 v=-91,-63
p=59,54 v=60,-69
p=57,81 v=77,39
p=51,79 v=-19,-11
p=65,27 v=74,95
p=33,56 v=44,-27
p=7,43 v=80,38
p=11,19 v=36,-88
p=27,15 v=-95,44
p=2,76 v=-15,-53
p=90,40 v=-14,56
p=93,52 v=30,-92
p=31,42 v=56,-16
p=86,64 v=-25,-51
p=97,81 v=-76,-76
p=11,36 v=35,-77
p=9,94 v=-10,-48
p=35,3 v=68,-6
p=10,84 v=69,58
p=12,17 v=18,71
p=61,62 v=77,-4
p=6,93 v=29,-82
p=91,71 v=-49,62
p=84,5 v=26,-17
p=100,1 v=-22,-38
p=90,27 v=-34,-39
p=84,21 v=-68,-62
p=72,10 v=-70,63
p=83,20 v=42,-74
p=51,99 v=-57,51
p=13,56 v=-78,76
p=21,88 v=80,81
p=40,97 v=76,85
p=61,92 v=-97,-15
p=29,58 v=56,-88
p=90,0 v=-34,-2
p=35,46 v=-23,-35
p=88,49 v=82,-67
p=83,23 v=98,-1
p=19,80 v=-5,-98
p=21,45 v=-90,45
p=79,3 v=-14,-86
p=49,37 v=27,-54
p=95,0 v=-93,36
p=55,46 v=-63,26
p=38,78 v=-61,-97
p=91,61 v=-60,-92
p=44,15 v=-51,75
p=82,86 v=20,-72
p=93,69 v=8,-95
p=93,59 v=-37,50
p=73,50 v=-84,22
p=8,7 v=-50,25
p=97,46 v=-14,22
p=43,2 v=-96,44
p=29,32 v=-33,34
p=30,64 v=-56,-95
p=12,65 v=-38,54
p=64,54 v=-12,-54
p=32,29 v=66,-4
p=80,84 v=-24,34
p=2,93 v=53,-87
p=77,14 v=59,-82
p=12,25 v=-77,78
p=65,74 v=76,-61
p=93,89 v=-26,59
p=1,35 v=25,-12
p=100,26 v=1,48
p=28,79 v=-96,16
p=18,1 v=-16,2
p=42,38 v=-39,-31
p=35,76 v=-76,-93
p=28,6 v=78,24
p=36,33 v=-34,-5
p=26,73 v=-95,-95
p=96,22 v=-83,-25
p=82,74 v=-30,-76
p=9,98 v=46,-52
p=80,3 v=13,-65
p=65,11 v=68,-58
p=68,57 v=-13,57
p=91,2 v=27,-94
p=2,96 v=-16,-29
p=65,67 v=-6,-55
p=79,63 v=88,-19
p=17,12 v=-27,52
p=10,6 v=52,-86
p=3,74 v=-37,-61
p=90,47 v=14,68
p=77,87 v=-59,20
p=80,63 v=-98,8
p=20,27 v=-64,10
p=93,60 v=-54,-38
p=93,14 v=52,95
p=53,79 v=-63,-87
p=12,21 v=-10,-70
p=71,62 v=76,-19
p=77,13 v=-3,-48
p=51,99 v=-46,-36
p=58,50 v=77,-31
p=59,62 v=54,43
p=66,66 v=-86,12
p=34,87 v=-93,-88
p=93,64 v=-47,71
p=11,5 v=1,-67
p=54,11 v=-80,-13
p=74,31 v=-30,-85
p=25,60 v=6,-34
p=94,77 v=81,73
p=62,70 v=-41,54
p=44,70 v=-68,80
p=25,78 v=42,71
p=46,0 v=-29,82
p=6,4 v=9,76
p=34,40 v=-52,3
p=62,23 v=2,50
p=85,72 v=31,27
p=85,67 v=1,1
p=3,37 v=-15,-96
p=99,29 v=-65,15
p=65,67 v=-22,-99
p=72,65 v=55,6
p=38,97 v=56,-52
p=16,13 v=35,82
p=0,7 v=-8,-86
p=47,4 v=33,-14
p=50,34 v=-26,59
p=27,61 v=60,81
p=100,11 v=13,-93
p=94,33 v=-26,-35
p=9,43 v=52,68
p=23,73 v=-1,-50
p=76,88 v=62,-78
p=62,28 v=43,3
p=95,22 v=-80,79
p=43,81 v=-84,40
p=19,10 v=85,2
p=40,31 v=-45,-81
p=33,59 v=11,-80
p=53,66 v=27,12
p=52,94 v=5,24
p=3,96 v=-71,-33
p=18,48 v=28,-27
p=76,18 v=34,-7
p=75,73 v=93,-53
p=48,9 v=-12,48
p=65,51 v=-69,-66
p=78,10 v=-14,-40
p=44,32 v=-52,7
p=36,20 v=-68,48
p=4,58 v=63,61
p=12,62 v=-39,-53
p=31,36 v=56,-85
p=14,58 v=-51,-61
p=86,11 v=-76,-17
p=45,38 v=-79,-1
p=60,41 v=29,18
p=28,8 v=-22,-59
p=66,47 v=-13,72
p=91,15 v=-31,-55
p=69,73 v=15,-87
p=52,49 v=71,-76
p=73,69 v=-47,-49
p=87,7 v=-20,-94
p=1,0 v=-76,40
p=96,48 v=-14,88
p=52,36 v=-46,26
p=94,48 v=3,-39
p=36,38 v=-71,-93
p=64,8 v=55,-47
p=75,63 v=59,-38
p=64,97 v=15,-94
p=63,102 v=4,-40
p=41,78 v=16,-87
p=63,82 v=58,50
p=32,24 v=48,42
p=57,69 v=-35,31
p=73,26 v=-2,-28
p=31,89 v=28,32
p=82,93 v=-14,62
p=61,87 v=-12,-26
p=58,36 v=-72,-13
p=80,49 v=-59,15
p=34,10 v=72,40
p=4,82 v=41,16
p=46,12 v=5,82
p=81,17 v=75,-36
p=69,12 v=99,90
p=98,16 v=-55,-24
p=49,39 v=38,-89
p=91,1 v=92,-32
p=91,99 v=-48,-33
p=16,44 v=-60,53
p=26,60 v=-56,-31
p=31,32 v=28,-16
p=36,40 v=33,-47
p=60,18 v=-97,-51
p=5,2 v=36,-21
p=83,8 v=20,-47
p=32,40 v=-16,-39
p=65,11 v=-84,11
p=58,31 v=-80,-5
p=96,38 v=-42,-65
p=40,23 v=14,87
p=36,81 v=67,77
p=13,74 v=35,96
p=6,58 v=-36,-64
p=73,23 v=-53,-5
p=22,18 v=45,-58
p=67,29 v=-81,-52
p=14,18 v=-33,-17
p=51,28 v=43,-55
p=98,11 v=-72,95
p=80,17 v=-53,10
p=76,54 v=65,-77
p=76,98 v=-74,66
p=12,50 v=97,64
p=53,27 v=67,26
p=22,89 v=57,-60
p=23,34 v=40,-43
p=35,85 v=17,-6
