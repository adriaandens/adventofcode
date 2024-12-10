use v5.36;

my @map = ();
my $width = undef;
my $height = 0;
while(<DATA>) {
	chomp;
	my @row = split //;
	push @row, '~';
	unshift @row, '~';
	$width = @row;
	if($height == 0) {
		my $ocean = '~' x $width;
		my @waves = split //, $ocean;
		push @map, \@waves;
		$height++;
	}
	push @map, \@row;
	$height++;
}
my $ocean = '~' x $width;
my @waves = split //, $ocean;
push @map, \@waves;

foreach(@map) {
	say @{$_};
}

my %trails = ();
for(my $i = 1; $i < @map; $i++) {
	for(my $j = 1; $j < $width; $j++) {
		if($map[$i][$j] eq '0') {
			say "found 0: $i, $j";
			brr($i, $j, undef);
		}
	}
}

sub brr {
	my ($r, $c, $path) = @_;
	my $val = $map[$r][$c];
	$path .= "->($r,$c)";
	if($val == 9) {
		# We are at the end
		$trails{$path} = 1;
	} else { # look for val around you that are one higher
		if($map[$r][$c+1] ne '~' && $map[$r][$c+1] ne '.' && $map[$r][$c+1] == $val + 1) {
			brr($r, $c+1, $path);
		}
		if($map[$r][$c-1] ne '~' && $map[$r][$c-1] ne '.' && $map[$r][$c-1] == $val + 1) {
			brr($r, $c-1, $path);
		}
		if($map[$r-1][$c] ne '~' && $map[$r-1][$c] ne '.' && $map[$r-1][$c] == $val + 1) {
			brr($r-1, $c, $path);
		}
		if($map[$r+1][$c] ne '~' && $map[$r+1][$c] ne '.' && $map[$r+1][$c] == $val + 1) {
			brr($r+1, $c, $path)
		}
	}
}
foreach(keys(%trails)) {
	say
}
say "Sol: " . keys(%trails);

__DATA__
210783456778967870123014510101265430321567841067432103
389892167865430965232323623432278921430438932398963412
456787018917821234301056798542103450543228940187876503
144567878706980031212349887653012760690117651256901414
033178989215432120103498978954321821789807652349832365
122017676321056763234567827667430930989778943210765474
221022345432349804589432014578123045678654332122110389
478431001234989812676541323489054101569743221043011268
569532102145676543234540983234569232478890104454345457
459643243054321789107632872110878745323210223467276306
348758954567810654308901962028964656910343210568189210
232367985678910563213456451038943247871356901879011232
141031076589623410012847302347652198961267812921010941
056122125486543223678998218956981067650345765832349850
347034234397890104556780127965671230347876854767456767
298965340987013278943012876871060141236989945678945698
100879891056324562102103945432054650105410834100034501
321410702345456983478754434567123789870320123211129632
492323612101237874569569123458870123561016784342568543
585494543087654723433478010789969834432125692103477655
676788984599123014529821021056954765893236543238989856
569876678678043565810730112347823876734567832397650765
108765549432154378925643209454210985621696941987041654
012014230556069210234758998763401034100787100456132545
321023121687678776107867812012310123212898912343203456
434564087794502985289978903401498921089877654132112347
543478096893211234676129984512347832210168743043032298
692109145232120140165038777601056544301259012158941187
783013234141034051234345668932347895614348747867650016
014560179054543761018903456787890198754109636958934567
323678788765656890127812345196781256543234545567825898
014989699656387787436541014012376387012373236430012327
123176540345494598545632123963465498106789108921183210
034012331256923687656543010876501065410632107847894789
545143422107810765467852196549432678321541096556905654
696654212212701899321946587038944569432532187443211565
787963401321432108910707432127653654549651056300120478
297872317450545657659818956012102165678740145212321329
187701298764696780348723347654245074569632238305433210
056781084543787691230654218923336789430101109876543678
145692985652310541021783204510421123321243278898694589
232343898721023432012895145654530014562354569167783098
621956782891236781763676034789691125671234321016012187
560845021760545890854985421056787323980765012345323456
456732130450674348921234678547845418345896721056891012
308212345321189267630104549430989509216765892234732127
219800456542010106549843230121678678107874763105645298
056701067434329010178760101456563212078983654267836787
147832198125018723269053212387654103147672101756921898
232943219096527654450144528498987054234598767843410189
981856901787403434543239609801256964374567056932501278
870987897898912523692108718712345878985432145001652567
561010762345809610787230125621236323476301232156743410
654323451056718721676343234210987410565432343239874323
