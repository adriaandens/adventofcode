use v5.36;

my @arr = ();
my $bool = 0;
my $len;
while(<DATA>) {
	chomp;
	my @chars = split //;
	if(!$bool) {
		$len = scalar(@chars);
		add_empty_row();
		add_empty_row();
		add_empty_row();
		$bool = 1;
	}
	unshift @chars, '.';
	unshift @chars, '.';
	unshift @chars, '.';
	push @chars, '.';
	push @chars, '.';
	push @chars, '.';
	push @arr, \@chars;
}
add_empty_row();
add_empty_row();
add_empty_row();

# Do a debug print
foreach(@arr) {
	say @{$_}
}

# Let's find XMAS
my $count = 0;
for(my $r = 3; $r < scalar(@arr); $r++) {
	for(my $k = 3; $k < $len + 6; $k++) {
		$count++ if $arr[$r]->[$k] eq 'X' && $arr[$r]->[$k+1] eq 'M' && $arr[$r]->[$k+2] eq 'A' && $arr[$r]->[$k+3] eq 'S'; # east (horizontal)
		$count++ if $arr[$r]->[$k] eq 'X' && $arr[$r+1]->[$k+1] eq 'M' && $arr[$r+2]->[$k+2] eq 'A' && $arr[$r+3]->[$k+3] eq 'S'; # south east
		$count++ if $arr[$r]->[$k] eq 'X' && $arr[$r+1]->[$k] eq 'M' && $arr[$r+2]->[$k] eq 'A' && $arr[$r+3]->[$k] eq 'S'; # south
		$count++ if $arr[$r]->[$k] eq 'X' && $arr[$r+1]->[$k-1] eq 'M' && $arr[$r+2]->[$k-2] eq 'A' && $arr[$r+3]->[$k-3] eq 'S'; # south west
		$count++ if $arr[$r]->[$k] eq 'X' && $arr[$r]->[$k-1] eq 'M' && $arr[$r]->[$k-2] eq 'A' && $arr[$r]->[$k-3] eq 'S'; # west
		$count++ if $arr[$r]->[$k] eq 'X' && $arr[$r-1]->[$k-1] eq 'M' && $arr[$r-2]->[$k-2] eq 'A' && $arr[$r-3]->[$k-3] eq 'S'; # north west
		$count++ if $arr[$r]->[$k] eq 'X' && $arr[$r-1]->[$k] eq 'M' && $arr[$r-2]->[$k] eq 'A' && $arr[$r-3]->[$k] eq 'S'; # north
		$count++ if $arr[$r]->[$k] eq 'X' && $arr[$r-1]->[$k+1] eq 'M' && $arr[$r-2]->[$k+2] eq 'A' && $arr[$r-3]->[$k+3] eq 'S'; # north east
	}
}
say "Sol: $count";


sub add_empty_row {
	my $empty_row = '.' x ($len + 6);
	my @row = split //, $empty_row;
	push @arr, \@row;

}

__DATA__
XXASMSMSXMXSMMXMAXMMMAMSAMASMSAMXMAXSXMASMAMMXXMASASXAMAMXSXMMSXSAMXSSXXMXAAXMAXMXXSXMXMMAAMMMMMMMMMMXXMSMSSSMXAAMAMMMSAMXXXXSMSAXMMXXMASMSS
ASMMAAAMAMASAXSSMMSASAMXAAAAXXXMAXXAMSASXMASMSSMSAMSAMMSXMAXSMAAMMSAMAAMSMSMSSSSXSXSMSAAXMXMAAAAMMSAMXSXMAAAAAXMAMAMAMAMMXMSASAXMXSAMXSAMXAS
XSAMSMMSAMASXMXAAXSASXXSSMXXXMMSMSMSMAMMASASXAAXXAMXAXAMAXMASMMSMAMMSMSMAAAAAAAAASASASXSMSASXSSXSAXAMAMAMMMSMMMMAXASMSMXSAAMAMXMMAMAXXAMXMMS
AMAMXAASMMXSAMSMMMMMMMMMAMMSMMAAAAAAXAXSAMASMSSMSAMSAMMSMMMXXAAAMXMAAAAMXMMMMSMMMMAMAMAMAMMSXMAXMASXMSSMSAMXAAASMSMXAAXAMMSMAAMAMXSMMSASXSXM
XSAMMMMXAXSMXXAMAAXSAAXSAMASAAMMSMSMSMMMSMAMMAAXMAMSASXAMXXXSMMMSAMMMSMSSSXXAXXAXMXMXMMMSMMMMMSMMAMAAAAXSMSSMMMMAAAMSMMXSAXXXMSXMAMAAXMAXMAX
MSASXMXSSMSAMSMSSMSMSMXMXMASMMSMMMAXXAAAAMAMMXXMXSMSAMMMMSMAXXAASASXXAXAAXMMXSMMXMXMAMXAAAAAAXAAMXSMMMSAMXAXAXAMSMMMXAMXMMMMXAMAMMSMMSASXSMM
ASXMASAAAXMAMXMAAMSMMSSXXMASAMAAASXMXMMXSSSSMMSSMAAMSMXMASMSMMMXSAMAMMMMMMSSMMMMAXAMAMMSSSMSSSSSMAMXASXXSMSSMMMAAAASMMMMXSAMXMSSMAMMSMMXAASX
XMXSAXMXMAMASXMMSMSAMASAMXAXMXSSMSAMSXAAMMMAAXAAMMMMAMAMXMAXMASMMAMXMAAAXAAAAAAMSMMMAMAAAXAAAAAAMAXAMXMASXMAXMXSSSMSAMSXAXASXAAAMXXSAAXMMMXM
MSMMASMAMXSASMXMAMMAMMMMSMXXSAMXASAMSMMMSASXMMSSMXMSASAMAMMMSMSASXMASASXMMSSMMSMXASXMXSMXMMMSSSMSSSMSAMXXASMMMMMXXAMAMXMXSASMMMSMXSXXXMMASAX
AAAAMXXAMXAMMMSAMASXMXSXAXSAMXXSXMXMMAXXSAMASXAXAXAXASMSSMXAAAMXMASASAMXMXAXXXXXSAMASAXXAXXAAAAXXXAMSXSAMMMSAMXMXSMSAMXAMMAMAASAMXXSSSXSASAS
SSSMSASXXXAXAXSASAMMMAXXAXMAMMMSAMXXSSMMMAMASMSMMMXMAMAAAMMSMSMASMMMXAMAXMASAMXMMMMAMXSMMSMMMSMMXSSMMMSMMSASXSXSAMXAMSMSMMASXMMMXAMXMAAAAXXA
MAMAMXXMSSSMSXSAMMSAMXSMMMMAMAAMAMXASXSASXMAXMAAAXXAMMMMSMAXAAXAMAASXSMMXSAAMAAAASMXSMXAAXMAMXASMXXAXASAAMASXAAMXMMXMAAMXSMSASMXMSSSMMMMSMSS
MAMMMXSAXAAAXXMXMSSXSAXAAASXSMSSSMMXMAMXMXMAMSMSMSMSMAMSAMAXSXMXSSMSAAAAAMASXSMSMSAMXASMMXMSASXMASXXMXMMMSSSMMMMSMASMMSMMSASAMXAAAAMXAAXAAXA
SSSXAXMMMSMMMSXMXASAXMSSMXSAAAAAXXMMMSMSMSMSXSAMAAAASMMMAMMXMXMMMMXXMXMMXSXMAMAAMMMMMXMSAASAMXAMSMMXSSMMMXAXXXXAAMMMAMXXAMAMXMXMMMSMSSSSMMMM
MMAMXSAMXXMSAMXAMMMMMXMASAMXMMMSMSMAMAAAAAAMAMXMSMSMSSXSAMXAXAAAMSMSXMASXMMMAMMMSAMMXXAMSMSAXSMMAAXMASAASMMMSMMSXSASXMMMXSAMXMAMAXAAMAAXXXAX
MSMASAMXAMMMASMMAXAXAMSSMMSXXSXAAXXAMMXMSMAMSMXXAAAXXXXMMSXMSMXMSAAMXMAMAXXMXXXXSMSMAMMMMXSMMXXSXSMSASMMMMMAAXMAMMMMAAAAMXASXXSMMXMMMSMXXSSS
XXXXSXSAMXSMMMASXSSXSAMXASAMXMMMMMMSMSAXXXAXMMSSMSMSMMSXMAMMAMAMMMSMAMXSMMSMAMSMSAAXMASAMMSXMXASAAAMAXAMXXMSSXMSSMASMSMSSSSMMAXASMXSAMXMMAAM
MAMXMAMASASAXMXMAAAXMAMXMMMMASAMXSXAASXSMMXXXAAAAXXXAAASMSMSASMSAAAXXMASMAXMAMAAMSSSMMMASASASAAXSMXMMMSSMSMAMMAMAMAXXAAXAMMAXMMAMAMMAMAAAMXM
AAMAMAMMMASXMSAMMMMMSAMASAMMAXASAXMMMMAAMMSSMMSSMMMSMSSSXAAMAMASMSSSSMAMMSSSSSMSMAMAMXSAMASAMMSMMMXMXAXAAXMASXAXMMXSAMXMMMSSMSMXMAMMMMMSSXMA
SASASASAMXMMAMAXAAAASASXSASMMMMMMSAMMMSMAAXAXAAXAMAAAMAMMMMMXMAMAAAAXMASXMAAAXMAMASAMXMASMMXMAMAAXAXMAXMMMMASMMSXAMMMXAMXMSAAAMMSASAAAMXXXAM
MASASASXSAMSSSMMSSSXSAMAMAMMSAMAAXXXAAAXMASMMMMSMMSMXMAMAAAXXMXSMMMMMMAXAMMMMMSXSASASXSMMAAAMASMMSMSMSAMAAMASASMMXSAMMMXAXMMMMMASASMSSSMMMSA
MAMXMAMASAAAMAAAMAMXMAMXMXMASMSMSMMSMSMXXAXXXMXSXAXMASAMMSXSSXASMXXAAMMSMMSXMAXAMXMAMAXMSMMXSASAMAAAAMASXSSMMMAXAXSAMASMSMXXXXMMMAMXXXMAAMAS
MSSXMAMMMMMMSSMMSMAMXAMAXXMASXSMXAAMAAMXMSSXASAMMXXSASASAXMMAMXSASMMMSMAMAXAXSMSMSXMMSMMMMAMMMXAXMSMSMAMAAAXXXMMSASAMXMAMXMSMSXSMMMSSXSSMSAM
XAMASMSXXMMMAXAXMMASMMSMSMAAXASASMMMMMSAAMAMMMASXSXMASAMAXMSMAMSAMAMAXMAMXSXMAAMASMMAXAAAMAXAMSSMMXXXMXMMSMMAXXAMMMAMXMAMMMAASAMXMMAMMAXXMAS
MXSAMMAMMSAMSSMSAMASAMXXAMMMSXMAMXXMSASMSMAXXMMMXMMMMMXMMMMAXMXXASXMASAXMMMMAMXMAMAMMSMMMSMSMMAXAMXMMXSAXMMMSSMMMXXAMSMMSASMMMXMAXMASMAMXMAM
AMMMSAMXAXMAAAXSXMASAMSXMMAMXMMMMMSAMASXAMSMXSAMAAAAAMASXASMSMMSMMMMMSMMMAAAMXSMXSSMASASMSXAMMMSAMAAAASMMSAAMAMAAMSMMSAASXSXMSAXXXSXXMMSAMAS
MXAAXMXMMMXXXSMSAMASAMAASXMXAAMAAAMAMAXMAMXAMSAMSMSXXMASMMSAXAAXMASAXMASXSXXMAXAAAAMXSAMASXMXAXAASMSMMSAASMMSAMXXMAMASMMSASAXMASMMSAXMXSASXS
SSMMSSSSSSXMXMXXAMASAMMSMASMSSMMMSXXMSSSMSMXMXAMXAMAAMSMMMMMSMMMSASMMSAMXXXMAMXMSSMMAMMMAMMMSSXSAMXAMMSMMSMMSXSAMXAMASAAXASXMMSMMAMAMSAMXMMX
XAAAAAAAAAAAXMASMMXSASMMMAMAMAASAMXAMAAAAAAASMSMMAMAMXMAMXMXSMSASAXXMXAMSMSAXSAMAAAMSMSMSXMAAXMASMSXSMSMAMAASMMAMXMMASAMMAMMXMAAMXMAMMAMSXSM
SSMMSMMMMMXMAMAMAAASMMAAMSSSMSMMAXMASMMMSMSMSAAXMMMMXMSSMAMSMAMASXMXMSSMAAMAXMASXSMMAAXAXMMMMSAMXMAAMASMXMMMXAMXMASMMSXMASMAASXSMSMSMSAMXAXX
AMXAAAAXMASXSMSMMMMSXSMMMAAAAAXMMMAMXXXXXXAAMMMMMXAMMMAXSXMAMAMMMMAAMXMSMSMMMSAMMMMMSSMAMMXSAMXSAMMSMAMAMSMMSXMXSAMAMSAMXMASMSXAAXAAMMMSMMMM
MSMSSSMSMASAMAMASXMXAMASXMSMMAXAAXSXMAMSSMMSMSMAMXAXAMXMMSSMSSSXAXSXMAMAMAAAAMXXAMAAAAMXMSAMMSMMASAXMSMMMAAMAMXAMMSSMXSMASXMASMMMMSMXSAAAAAA
XAAAAAMXXAMMMXXAMAMMXSAMXXXMASMSMSXMXSMAAXMAXASAXXSXMMXSAAXXMAMMMMMXSASASMSMSMMMSXMMSSMSAMAXXAMMXMASMXASMSXMASMAXAAXMAMSASAMAMAXSAMXXMSSMMSS
SMSMSMMSMSSSMMMAXAMSMMASMXSSMMAAXXASAAMSMMMSSMSMSMXAASAMMMSMMMAAXAAMXMSMSXXAAXMAXAAAXAAXAXAMSAXSASAMASAMAAXXAMMSMMSSXMMMXSAMMSMMMAXXMXXXXMAM
SAMXAMXMAAAAAXSAMSXSASMMMMMAXMSMXMAMSMMAAAAAAXXAAAMSMMASAXXMASXMSMSSXXMASAMSMSMASXMXSMMSSMMMAAXSAMXMMMMSMMSMAMAXAMXMASXXXSXMMAMSAMMSSMSSXAAX
MAMSMSAMXMSMMMXAMXAXXXMAAASAMXAAMMSMMXMSMMMSSMMSMSMXASAMXSMSMXAMAAAMXXSMMMMAASMMMAMXXAAAXAXXMSMMXMASXAXSXAXXAMSXSMAMXMMMAXXXSASMAMAXAAAXXSMM
SAMXAAAXMMXAXMXSMSMMMXSXSXSMMSMAMAAAAXAAAMMAXAXXXMAXXMASXSAAXMXMXMMSXMAMAMMMSXASMMMAMMMXSAMXXMASXSASXXMSMSSSXSMAXSSSMAAMMAAMMMMMAMASMMMMAMSA
XAMAMSMMMASMMSAMMMAAXMMXXXMAAASXMSSSMSSSSMMASMMMXMASXSXMAMSMSASMMAMAMSAMASXMXXAMASMSSXAAMAMSMSAMMMASASASAMAMSMMMMAXXMMXXMSASAAMSSSMXXMXSASAS
SXSAXAAXMAXSAMXMAMXMSXSASASMSXSXMXAXAXAAMAMMMMSMXMSAAAXXXMAMXMAAAXMAXSASASAMASXSXMAMAMMMMAMAAMASXMAMXMAMSMAMSSSSMMMXMMSAXMASMMXAAAXXSAAMXMAX
MMMMMSSMMMSMXXSSSXSAXAAASXMMXMSASAMMSMMMSAMXAAMXAMXMMMMMMSAMXXSAMMSXXXMMMXAMAMAMXMXMASXMSSSSSSXMXSXMMMAMAMAMMAMAAXMASAMAXXASMSMMSMMMAMSXXMXM
SMXSXMXXAXSAXXAAAAMXXMMMMASASASAMASAXASXSMSSMMSMMSAMXAAAASASAMXAAXXSSMSAMXAMSMSSXMASXMAAAAAAMXAMASAMASASMSSSMASXMMSAMASMXMMSAMXAXAASMXXAMSSM
XMAMAASMMSMASMMMMMMAXMAMXAMMMAMXMAMMSXMAXSAAXAXASXMSSSSMXXSAMXXMMMAMXASASMMMMAMAASASASMMMSMSMSMMASAMXMXSAAAXMXXAMXMAXMAXASXMMMMSSXXXXAMAMAAS
XMAXMMMAMXMAMAAXAXMXMMASMSSXMAMSMMSAXMXMMMSSMMSSMSXAMAMXAXXMSMMMAMAMMXMMMAAAMAMSMMASAMXSAMAMXMAMMMMMMXMMMMMMXMXMMXSSMSMSMSXSXAAXXMAMXMSMMSSM
XMMSMAMXMXMAXSMMMXSAMXAMXAMMMSXXAAMXSMAMAXXXAMXMASMSSMMMXSAXXMASASMSMMAMSSMMXSMMXMXMXMASAMXMMXAMXXSXSAAASMSSMSAMSXMAMAXMAMMMMMSMSMMMSXAAMXMA
MXMAXMSMMSSSXMSMSAMASMAMMMMSXMMSMMSAXXASAXXXSSMMAMAAMAAAXXXMASMSASAAXSMMXMASAXAMXMAMASMMMMMSASMSMASASXMMMAAMAMASAAXSSMXMAMXMASAAAAAMAMXSXAXS
AASAXMAAMMAMAAASMAMAMMAMAXASASAXASMMSSXSAMMXMAXMSSSMSSMSSSMMXMXSAMMMXXSAMXXMASAMASASXXAAXAXMMXAAMXMXMMMSMMMSSSMMMXMMAMMSXMASMSASMSMSSSMMMMMM
SMMASMXSMMAXMMMSSXMMSSMSSMASAMXSXMASAXMXAASASAMXAMXXXXAMXAASXXAMXMAMSAMXMASMAMAMASMSXMSMSMSMAMXMMSSXMAASAMMAASAMXSASAMMSAXXMASAMXXAAMMMAAASX
AXMAXAAXXSXSXAAXMMMAAXMAXMMMXMXMASXMMSXMSMSASASXMXSAMMXMASAMXMMXMXAMMAMXSASMMSMMASAMAMMAXAAMSXSAXAMMSAMXAMXMAMXMXMAMMSASMMMSMMAMXMMMXAMSSXXA
XMASMMSMASAMXMMXXAMMSSMSSMXXAXAXMMSAXMMAMXMXMAMMMAXMXSMSAXAMMMAASXSSSSMAMXSXMAMMAMASMMSSMXMXAAMXMMXAMXXXMMXXMMSXAMMMMMMXAAAAXSAMXSASXMXMMMSM
XAAXXAMXMMAMMMSMSASAAXXMAXSSMSSXSAMSAMXSAMXXXMSMMASMXXAMASAMAMMXSAXMAXMAMSMMSSSMXSAMXAAXMXSMMSMMMXMSSXSASXMSAAMMSMASMSXSSMSSMSASXXASXSAAAAAX
MMASMMMAXMXMAMAMXAMMSSSMAMMAAAMMMASXXXAXXAMAMXAAXAXAMMSMAMASMSXAMMMMAMSAXAAXAMAAAMAMMMMSXAXMAAMASAMMAASAMXASMASAXMMMAXAAMXMMXSAMXMAMMSSSMSSS
AXASASMSSMMSXSASXSAXXAXMAMXMMMSSMMMMSMMMMMMMASXSMMXSXXAMAXXMXMXMMAAMSMSMSSXMASMMMSAMMAAXMMSMSMSASASMMMMXMMXMSAMMSSSMSMSMSASMMMAMAAMSAMAMAMMM
SMXSAMAASMAAASAMAXSSMSMSMSXMMMAAMXAAAAAXXMASXMMMASAMXASMSSMMXMXXSMSXXXMAMMASXMXMASMMSMSMXAAMXAMXSAMXMXXMXMSAMXMXAXAAMAXAXAMAAXAMXSAMAMAMAXSX
XMAMAMMMMMMSXMSMSMAXXMAAAAMXAMMMMSMSSSSXXMASAAXSAMASXMMAAMAMMMMAMSXMMMXMMMMMAAAMXMAMSAMXMSSSSMSMMAMXXAXSAMXASMMXMSMMMSMMMSSSMSMSXMMMAMXMMSXS
SMXSXXXXXAAXXAAMMMMMSMMMMMMSAMAAMAMMMAXMAMXXXMMMXMSAMXMAMSXMASAASAMAASMMAAMXXMXSXMXAMMMAXXAAXAAAMXMSXMASXSSMMASAMAXXXAAAAAAAMAASAMXSSMSAMAMX
AXXMMMMMSMSMSSSXSASAMAAMXAXSAMSXSAXMMAMSSMMMSMXMMXMXMASXXSASASXSMASXMSASMSSXAMAAAMMMMXSSSMMMMSMXMAXMAMAMXMASMMSASXMSAMXMMSMMMMXMAMAMAASMSMXS
MXSAASAMXAAAMAMAMXMASXMSMMMMAMXASAMSMMXAASXAAAASMASAMAXMAMAMMSMXMAMMMSAMXAAXAMMSXMAAMMMMMXXSXMASMXSSXMASAXXMXASXMASMXMAXXMASXSMSAMXSMMMXAMSS
XAMXMXMSXMMSMAMAMMSXMAAXASMMSMMMMSMSASMSSMMSSXSASXSASMSMSMSMAMAAMXSXAMMMMXSSXMAMASXMMAMAXAXXAMXMXAAMSSXMMSMMMXSAMXMXSSSXMSAXAAASAMXXXSASMSAM
MSSSMMSAXSXXXMSASASAMXMSXAMAMAXXAAXXAMXMAXXXAXXMAMSAMAAAAAMMSSMMSMMMSSMXSAMMAMXSAMXMSSSXMAXSAMXAMMMMAMXMAAAAMMSXMMAMXAXAXMMSSMMMSAMXXMAXXMAX
XAAAAXMASXAXSXMAMAMAMSMMAMMASMMMMSSMSMXXMAMMMMSXMMMAMSMSMSMAXAAAXAXAXAMAMXSXXAXMMSAXAXMXAAASAMXAXSAMASAMXMMAMMMASXSMMMMXMAAXXSXSAMXMXMSMSMXS
MMSMMMMMMMSMMAMSMSMXMAAMMXMXSAMXAAAMXMXSMASAAAAAMXSAMXAXXAMMSSMMSSMXSAMXMXMMMXMAMMAMSMSASMMSAMXMASXSASASASXXMAAXXMAAAAMSMMMSAXXMAMSMMMMASAAA
MAMXXXAAAAXASMMXAAAXSSMMSASXSMMMMSXMAXAMXAXMMSXSMASMSMAMSSXXAMAAAXAXSXMASMSAMASAMSAMAAXAXXXXAMXSAMXMASAMXSASMSXMMASMMMSAAAXMMMMSAMAMAAMAMMXM
MASMSSSSMXMAMXXMSMSMAAMXSASAMXXMXMXSXMMSMSXSMMXAMAXMAMMMAAXMASMMSSMAMMSASASMSASMMSASXSMSMSMSSMXMAXMMAMMMMMAMAMMMAMMAMXSMMMXAMAXXXMMSSSMMSXAX
SXSAMXAAMSMSMXMMMAMAMXMAMXMMMXMMAMMXXMAAMAASAMSMMSMSASAMMSMXAAXSAMXAXAXAMMMXMASXASAMAMXXMXAAMAMSMMSMSXSAXMAMAMAAMAXAMXSXXSSMSSSMMXMAAMAASMMM
MMMXMMMMMAAAMXSAMSMSASMMSXMASAXMAMXXMMAXSMAMAMAXAXXSASASXMXXMMMMMXSASMMMMMMAMAMAMMSMXMAXSMMMSXMAXMSAMASMSSSMXASMSSSMSAMAMXAAAMAMAASXMMMMMAAA
XAXASASMSMSMMMMAXXAMASXAAASAMASMMSMSAAMMMXASAMMMMMMMMMMSAXXXXAAMXXMASXAXAXSASAAMMXMMSMMSAASXAXSXMAMAMASXMXMAXMMMAAAXSAMXMSMMMXAMMMMAXXAMXSMS
MXSXXXSAAAXASMSSMMSMAMMMSMSAMSMMAAASMMSAMMMSMMXAAMXAMAAMXMAMXXSMSAMXMMMMMXXASXSXMXMASAMXMASMMMXAXMMXMAMMSMSMMAXSMSMMSAXSXXXMXMSMSASMMSMSAMAX
SMSMSMMXMXSAMAAAMAAMAMXAXAMXMXAMMMMMAASASAXMASMSMMSSSMXXAAXMSMAASXSXSAMAMXMMMXMAXMMAMAMXXAXAXAMMMXSXMXSAMXAASXMAXAXXXAMSMSMMMSMAAXMAMAMMASAS
AAMAAASASAMXMMMMMMMXXSMMMASMMMXMAXASMMXASMMSAMMAAAAAXXSMXXAAAMMMMMMASAMSAXMAAASXMSMSSXMXMAMSMMMSAAXXSMMXSMSMMAMXSMSSMMMXAXAAXAMXMXSXMASMAMMM
MAMSMSMXSAMXSXSMSMSMSXMXSAMAMSMSSXMMAAMXMMMMASMXMMMMXXSASMMXMMAASAMMMAMAAASASXXXAAAMMAMAMMMXASAMMSMXMAMAMMXASMMAMMAXAMAMSSSMSMSAMXMASAMMMSAS
XMXXMAMAMAMXSAAAAAAMASXXMXSAMAAAAASXMMSXAXXSSMAASXSMSAMXMAXSXSSMXASXMAMMXMXAXMSSSMSMXASASAASAMASAAAASMMMSXMXMSMXMAAMXMXSMXAAAXSMSAXAMXAXXSAS
MASMMMMSSMMAMXMSMSXSASMSAASASMMMSXMASXMXMMMSAMMSXAAXMMMSSXMAMMXXSAMXSASAMMMSMMAAAMXMMMSAXMMMASAMMMXXSAAXAXXAAXMMSMSSMSMMMMMXMMSXSMSMMMASAMXM
AMSAMXAXAMMASMMXMMAMAMAMMMSAMXXXMXSSMAXMMAMXXMXMMMMMSXAXAAAMAXAMMXMASXMASAAMXMMSMMAMMMMMMSXSAMXSAXSASMMMAMXMMMXAAXMAMMAASXSAMXSAMAAAXSASMSMM
SXSMMMMSXMSAMASXAMMMSMSMMXSXMASAMXMASXMASXMSAMXSAAXAXMAXMAMXSMMSSXMASXSAMMSMSXAAMSXSASAMMMAMMSMMAAMMMASAAMAXAXMMSMSAMXMMXAAMSAMAMSMSMMASXAAM
XASXAAXMXMMSMXMXMASAAMAMXASAMMSAMAMMMMAMXMAAMSASXSMXXSASAMXAMXAAAAMAXMMASXAMMMSSMAAXMSASAMAMSAXMMMMXAAAXASXMAXSXMASAMASMMSMXMXMAMAXAAMAMXSMM
MAMSSSMSMSAMXSSSXAMXSSMMMXSASXSASXSXSXSXMMAMMMASAXMAMMASXAXAMMMSXSMMSMXAMXXMAAMAMMSMAMMMMMSMSMXXXXXSMSSSMMMSSMSASASXMXAAAMXMAXXXXXSSSMXSAXXM
MAMAXMAASMAMMXAAMMSAXAMXSXSAMAXXMAAAXAXXMXMSXMAMMMMSMMMMMSMAXMXXMAAXAMAMSAMXMMSAMAXMAMSAMXMAMXSSSMAMAMAAAXAXAAMAMAMMMSSMMSXMASMMMMMXXAXMASMM
SMMXSMMMXXMSAMXMSAMMSASMSAMSMMMSMMMMMSMMSAMXAMSXXAXAMXMSAXSAMSASMSMMASMSMXSASASAMXSMMMSAMASASAAAAMXMAMSSMMSMMMMMMMMXMAMAASMMMAAAAAAXMXSMAMAS
SAMAMMSSMAMXXAAXMASXMASAMXMXMXAMAXXMAXMAXXSXSMAMSMSMSSMMSXMMMMASAXMSMSXAAASAMASAMXXXMAMAMAXAMASXMMMSMXAMAAMXSMSMAAMXMAMMMSASMSAMXSSMSAXMASXM
SAMXSAAAMAMAXMXXSAMAMAMMXASMSMAMSMMMASMSSMMAMMXXAAAAAAXAXXAMSSMMAMAXAMXMSMMXMAMAMAAXMAXSSXMSMXAXXXXAMMASMMSAMAASXXSASMSSSMMMAMASMAAAMMSXXMMA
SAMXMMMXSAMXSMXXMXSAMXSXSXSAXMAMMAMMAMAAAAMAMMMSMSMSMMASMMSMAAMMXMSMSMAXMXMXMAXAMXMXMASMAAXXASAXXXMMXSAMXAMASMMSMXXASMMMAMXMAMAMMSMSMXAXXMXM
MAMSMMXMAMXAAMMSAAXXMAXXXAMXMMXMSAMMMMMSSMSASAXXAXAMXSAMAAAMSSMSSMMAASXMSAMMSSSMSAMAMXAAXMMXAMASXMMSAMASMXSAMXXXMASMMMSXMAAAMMMSAASAMXMASMAS
SAMMAMXXAMMSXMAMMMSXSSMMMXMSMSMAXSMXSAMMAAMAMXXMMMSMAMAXSMMXMAAAAAMSAMXXMAMAAXAXSMSASMXSASXMXMXMAAAMMXMMMMMMXMAXMASAAASAASXSSSMAAMAMMMMSASAS
SASMSMSSXMAMAMXSAMAMAAAXSAAAASMSMAXASASXMMMSMSSMSAMMSSMMAAXMSMMMMXMMXMAMSSMMSSSMMXMAXAAXAAXAXMASXMMMMASAMASXMSXSMASMMMMSMMAMAASMSXXSAAMMAMSS
SAMAMAAMAMASAMSSMSAAMSSMSMSMSMAMSMMXSAMXXMAMAMAAMAMXAAASXMMXAAMXMSASAXAMAAAMAAMAXSSXMMMMSMMSASAXMASMSASAMXSAAXMAMMMXXXMAXMAMXAMXXMXSXSSMMMAM
MMMMMMMSMMAMAMAMASXSXAXAXAXMMXXMAXMXMMMSXMASASMMMSMMMSMMAAASMSMAXMASMSMMAMMMMXMSMAAASXMAXAXMXMMSMAMAMASXMAMMMMMMXSXMXSMSMSXSSMMMMMAMSXXAXMAS
AXAAXAMAMMMXMMMMAMMMMSMSMMMASXSSXAMMSMAMXMASAMXAAAASAMASXMMSAMMSMMMMXXXASMSXSXAXMMMMMAMSSSMSAMMAMASXMMMMMMSXMSMAAMAMAMMMAMAAXSAAAMASXXSMMMXA
MXMXXMXAMASAXXXMAMAXXAXXMXSAMAAXXAXAAMASAXXMMMXMXSXMASAMXMXMAMAMSMXSMXMAMXXAXMSMXSSXSXMAAAASASMSSMXAXXASXMAXXAMMMXAMXSAMSMSAXSSSMSXMMMMAXMSM
SSSSMSSMSASXMXASXSASMMMAMXMMMMMMSSXSXSXSASMSASXSAMMMXMXMASMMSMMSAMMSASMMXMMSMMMXAAAXMAMMSMMMAXXAAMSSMMXMAXSMSASASXSXAMXSXAMXXMAMMAAAMASAMMAX
SAMXAXAAMASAMSXMAAAXMXMAMXAXXAAAAMMMASXXAXAXASAMXSAMMAMMXXAAAXXMASASAMXXMAMAAAMMSSMSSSMAXAMMMMMSMMAMAMXMAMMAMAMASXMASXMMMXMMMMASMSXMSXMAMSAS
MXMMSMMXMAMMMAAMXMMMSXSASXXMSSMMXSAMXMMMMMMMMMAMXSAMXAAMMSMMMXMSAMXMSMSSMSSXXMSAMAXMAMSAMXMAXMAMXMSSSMMSSMMAMXMAMAXSAMAXXMXAXMAXXAMXMMXXMXXX
SMMAXAXAMAMAXAXMAMAXXASAXMAMXAAAAMMSXAAAXAAMSSMMASXMXMXMAAAXMAXSXMXMAXSAAAAASXMMSMMMAMMMMMXSXMAMMAMXAAAAMASXSAMMSSMMMSXSAMXSAMXSASAXXMASMSSX
MAMMSMSXSASMSSXSASAXMMMMMSXMMMMMMSASMSSMMASMAAXMASXMXSAMMSMMMMMSAMAXXXXMMMSMXAAAMMMMAMAAXMAXAMAXMAMXSMMMSAXAMAXMAAAAXAXMAMAMXMXMAMXXAXMXAAMM
XMMXXAMASXSXAAMSAMXSASAXMMMSAXAAXMXMAXAAMAMMSMMMMSMSASASAMXMXMASAMMSMSMAMXXXSMMMSASMSSSSSMASASMSASAMXAMXMMXMSMMMMSSMSMMSAMAMMMMMSMXMMSSMMMSX
SSMMMSMAMMMMMSMXMASAASMXMXAXMSMSSMAMXSMMMAXMMXASASAMASAMMXASXMAXAMAAAASAMXMXMASXSAMAAAAAXMMSAMAMAMMMSMMSAMXXAMMAMXAAXAASAMXXAMSAXMSXAAAAMAMA
MAAXAMMAMASAMMMXMMAMAMMMXMSSXXXXAMXSMMMSSSSXXXXMAXAMAMAMXMXAMMSSMMSSSXMMSMMXMAMMMMMMMMMMMMXMMMAMAMXAASXSXMXSAMXASMMMMMMSAMSSSSMMSAMMMSSSMASM
SSMMAMSAMXMASASMXMAMXSXSAAMXMMMSAMMXAASAAMMMMSMSASXMXSXMXSAMXAXAAMMMXMXXAAXAXMMSASXSMXASASMAMSXSXSMSXSMMXMAMMMSMSMAXAAXXXXXAMXAAMAMSMMAXMXSM
MAMMXAMMSXSAMASAASXSXAASMXMAMAAMAMASXMMMSAAAAAAMAMXAMXXSASMXMMSSMMAXAMXSSSMSASXMASAAXSXSASXSMSMMXMAXMSAMXMASAAAAXMASXMSSSMMMMSMXMAMAXMASMMSA
ASXSMSMSAMXAMAMMAMSMXMMMXSSMSSXXAMMSXAXAXXMSSMSMMMAMXMAMASXAAAAXMSSMASAXAMAMAMXSMMMMMMAMAMAMAXAXSMSMASAMXSASMSSSMMMMAAAAAXMXXMASMSSMSMAAXAXM
XMAXAAXMXSXSMAMMSMAMAXMAMAAAXASMXSXMMXMXSSXXXMAMASAMXAAMAMMSSMMSMAMMXMMSAMAMAMAXAAXXAMMMXMXMMMSXXAAMXMAAXMXXMMAMXXMMMMMSMMSMSMAMMAAAXMSSMMSX
MMMMMMSSMMAXMMXAXSXAXSMSAMMMMAMXXMAMMMSMMMXMAXAXXMAMXSXSASAXAAAMMASXMSXSXMXXSMMSMMSSSSMAASMSMAXXMSMSSSXMSMMSMMASXMSAMXAMXMAAAMXSMSMMMXXXASXM
AAMXSAAAMMAMXXMAMAMXMSAMXXMMMXMXXMAMSAMAAMMSAMSSMSSMAMASAMXSSMMMSMSAASAMASMXMAAMMAMXAAMXSMAAMXMAMAMAAMSXXAAAASAMAAMAMMMSSSMSMSAMMXMXMAMXXMAA
SASAMMSSMSASMSMMSMAAAMMMMMMAMAAXSXMSMASMMSAXASXAAAXXAMAMMMAMXMAXXASMMMASAMMASMSAMXMMSSMMMMSMSMSXSSXSAMXMMMMSXMAMMMMSXSAMXAAAXMAXSAMASXMSSSXS
XAMASAMXXXASMAAAXXSXSSMASASASMSAAAXMXMMASMMSSMXMMMSSMMAXAXMAAXMXMXMAXSAMASAMXAAMXSXAAXAAXAMXXAMAAXAMAXXAXAAXMSXMXXMXAMMMSMMMMSXMSXSAMAXAASAX
SASAMASXMMSMMSMMSAMXAXXASXSAXXMMSSMAMMSXMAMMAAXXAXXMASMSMSXSMXSAMMSAMMAXMMMXMMMMASMMSSSSMSSXMAMMMMSMMMMSXMSAMXMMMMMMAMAAXAAMASMAMXSASXMMSMMM
SAMXSXMAXXMAAMAAXAXXMAMMSMMXMXMXAMMSMAXMSXMSMMMMAMXMMAXAMAMXMAXASAMAMSAMXASAMSXMASAAXAAMAXAASAXAXAAAXMMXXAAXMASAAAMMSMMXSMMMASMXMAXMAMXXAAAA
MAMMXXSXMAMMMSMASMMMSASXSXSASASMXSAXMSMASXMAMSSMMSSMAMSSSMSSMMSMMMSSMMXXXASMMSXMASMMMMMMMMMMSASMMXXXXXAXMAMSAASMSMSAXXXMSAXMASAMMSXXXSXSXSMS
SAMXMMMMMMMSAMXXAXAASASAXASASASXXMASAAMSMMSASAAAAXMASXMAAAAXMAAAAAMMAXAXMXMXAMXXXXMAAAAAAAXXSXXXASMSMMMMSAMMMASAMAMMSMMAMXMMMSASAXXSMSAMXMMM
XMMAMAAAAAXMMMSSMMMMMXMMMMMAMXMMMMAMMMXAAXXMMXXMMSAMMXMSMMMSMXSSMSMSXMMSMMAMMSMSASMSSSSSSXSMMSAMXXAAXXXAMXSASXMMMAAXAMMSMMXAAXXMASXMMXSXAMAS
SSSXSSSSMMSAAAMMXASAMMSXSAMASMMAAMXSXSXMMMXSSSMXMAMMMXMMXAMAMAMXMAXMAXXAXMAMMAXAAMAXXXMAXMAAXXXMAMSMMAMSMXSASXMXSSMMXMAMAMSSMSAMSMMAAAXMMSAM
SAAXXXAAAXSXMSSXXMSASAXASXMAXAMSMSXMASASAMXAAAMXAAXXXMAXSMSASXSASASXSMXMXSMMSMSMMMXMMMSAMMSSMXSMAXAAXMXXAXMMMAMAMAXSXMASXMAXMAMXMAMXMXSAMMMM
MMMXMMSMMMXSMXMASXMASMMMMSMMSSMAMMAXAXMXASMMSSMMSSMMMSAXSAMASMSASAXAMAASXSAASASXASMSAAMASAAAAAXMXMXMMMAMXXAASMMAXMMMASAMAMXSXMMSSSMSMXXXXXAS
AXXXMAAAAASAMXASASXXMXXMASXMAXSASMSMSSMSMMXXAAAMXAAAXMSSMAMXMAMMMMMSMSMMAMMMMAMSMSAMMMSAMMSMMXSSSMXXAMXXAMSMSASMSMXSAMAMSMMAXAAAAAAAMAXSMSXS
XXMASMSMMSMMMMMMAMMAMSAMXMAMAXSXSAMAMSXAXMMMSSMMMSSMSAMXMSMMXXXXASAMXAMMSMXSMMMSXSMXMASXSXMASAAAAAASXMSMMMXAMAMAAXMMXSMXMAMAXMAMMMMMMAXAASMS
MASAAXAXMAMXXXXMAMMAMMXMAXXMMMSMMAMMMMMMSMAAAMAAXAXMMMMSXMASMMSMMMSXMMSAMAASAMAXMMXAAMXSMASAMMMSMMMXMASAXAXAMSMSMMASMXMASAMXSSXSXSSXXXSMSMAX
AMASMMXASASMMMXMAMMASMMXSSMXSAMMSAMAAXAAAXMMMSXMXMMMAMXMAXAMAAMAXSXSSXMASMXMAMMMASMMXXMXXAMXSXXAAXSMMASXMMMMAMAMXMSXAAMMSAMXXMASAMXSAXSXMMSM
MMAAXMSXSASXAAXMASMMSAAAMAMXMASAXSSSSXMSSSMSMSASXXXSMMMXSMASMASXMSAMXAMMMMSSSMXAMSASAXAMSMSXAXSXSMMAMASXAXASAMXMAXMXMMSXMASMXMAMAMAMMMMAMAXA
XMMMAASAMAMXSSSMAXMAMMMXSAMSSSMMSAXXMAXAMAMSASAXMAXSMXSAXAXMMMAMXMAMSXMXAAAXAAXSXSAMXXSAAASAMXSXMASXMAMAMAMMAXAMMSSMSMSASXMAXMMXAMXSMAMAMMMS
MXAMMSMAMAMAMXMMSSMAMAMMSXMAMXSXMMMMSMMASMMMAMSMMXMMAAMMSXSXXXSXSXSMXSSSMMSSMSMMAMXMXSXMMMMMMAMXSMMAMASMSMSAMXASMMMAAASXSMMSMAAXXXMAMASXSXAX
SSSSXAMXMASMMASAMMXXXAMXMXSMSAMXAASAAXSAMAMMMMAXMMMMMMSXSASMMXMASAXSAMXXSAMXXAAMSMXXXAMXSAMAMASASASAMXXXAXAAMASMMAMSMXMAXXAAXXMMSAMAXMXAMMXM
AAMXMASXMXMAAAMASAASXSSXSAMXMAMXSAXSAMMASAMASMMMSAAAAAMAMAMXMAMAMAMMMXSAMXSMMSMXAAXMMXMASASXSMSAXASXXSXMXMSMMXMAMXMAXAMSMMSSSMAASAMSSSMSMAMS
MSMMMSMXXAXMMSSXMMMMAAAAMAMSSMMMAMXMXMAMMASAXAXASMSSSSMXMAMXSASMMXMASAMAMAAAXMXSMSMXAAMXMAMXMMMMMMMXAMXSAMXXXAMXMSSMMXMAMXAMXAMMMAMXAXAMXXSA
XAAXXAASXMXXXMAMSSSMSMMMMMMAAAXAAXXXAXMASXMAMMMXSAMAMXMXMAMASXSAXXSASXSAMSMMMSAMAAAXSMSAMXMMMASAMAASXMMSASAXMASXMXAXSSMMMMAMMSAXSSMMAMMMSSMM
SSMMSMSMASAASXSXAAAAMXXXAXMSXMMSMMMSMSMAMAMAMSAMMXMAMASASASXMASMMMMASASMXMXAAMAMAMSMXAMXMAAAMAMAMMXSAMASXMASMMSAMSXMAAXSASAMMMSMXMAMSMAAXAAX
MXSXXMAMAMXSAAAMMXMMMMMSMSMXASAAAMAAAAMASXMAXMAMXASASXSASASMMXMXAAMAMMMMAMSMMSAMXMAMMXMASXSMSSSSMSXSXMASXSASAASAMXAMXMMSASASAAAMASAMASMMSSMM
SAMXAXXMASXXMXMXSXMASAAAMAASAMMMAMXMSMSXSMMMXSAMXXSASAMXMAMXMASXMSAMXASXMMAMXAAXMSASXXSXXMAMSAAMASAMAMASAMASXMMAMSXMXXAMAMASMMMMAMMXMXMAXAMX
MMMSMMSSXSASXMXAMASAMMMSSMMMMMXMAMSXMASAXXAAMSAXXXMXMAMMSAMAMAAMAMAMMMXAXSSSSSXMXSASMAAAMSXMMMMMAMASXMASXMXMASXMMMSSXSSMXMMMXAAMSXSSXMMXSAMX
MAAAAAXMAMXMAMMXSAMXMMAMXMSMMAMMAMXAMMMMSMMSXSAMMAXMSSMAMAMSXMMMAMAMXSSMMAAAAAMSMMXMMSMSMAXMXSXMXSAMAMASXSXSASAMXAXMAMXMSXMAMMMMMAMXASAAXAMX
SMSSMMSMMMXSAMXAMASMAMMSAAAAMXXSAXSAMXAAAMXMAMAASMMAXAMSXSAMXMMSMMXXAAAASMMMMMSAAXXMAXAXAXMSAMXSAMXSXMXMASAMASMMMSSMAMAAXAMSMMSAMAMSAMMSSSMX
XAAAAAXXXAXAAMMMSXMMAXMAMSSSMAXSMMMAMXMMXSAAAMSMAAXSSMMAAMASASAMXSSMSMSMMAAMXXSMSMMMSMMMMAXMASXXSAMXMASMMMMMAMXXMAMXASXSSSMMASMASXXMASAMXAMX
ASXSMMSSMSAMXMAXMMXSXSSMXMAMMXMXMASAMSXSASXSXXAMMMMMAXAMXMMMAMMSAMAAXAXMSSMSSXMXXMAAXMSMSAMXMAAXAMMMXAXAAAXMASXSMSSSMSAAXAAMMMSXMXXXMMASMMSM
MXAMMMAXAMXMASXSMMMXMMASMMAMSMSMSXSASXAMASAXXSXMASAMMSSXMAMMXMXMASMMMAXAAMMMMAMAMMMSSMAASMMASMSMMSASMSSSMSSSXMMAAXAMAMMMMMXMXMAMXMASAMXMAAAA
SSMMAMMMMMAXAMMSXMXAXSAMXMASMAMAMAXXAMXMAMMMMAXSAMAXXXMMSSMMXSASAMXSMSMMMSAAXXMASASMMMMMMXSASXMAXSAXAAMAMXAMMSSXMMMMXSAMXXASAAAAXMAAASXSMMMS
AAASXSXAMSAMXSAMAXSAXMXMSAMXMAMAMAMXXSAMXSAAXMMMXSSMSMSAAAAXMMXMASXMAMXMASMXSAXXSXMAMXSAMXMMSAASXMSMMMMAMMAMSAXMASXXAMASMMAXSSXXAMSMMMAAXMSM
SSMMAAMSMMAXXMASMMAMMMSMXASMSXSASXMAXMAXSSXMSXAMAXAAAAMMMXMMXMAXXMXMMMMMXSAASAMMMXMXMASASXSASMMMXAAMXSSSSMXMMXMAXAXMMSAAAMAMXMMXSAMXMMSMMMAS
MAMMXMAMMSMMMSMMASXMAXAAXXMASASMAMMMMSMMMMMXMXAXMSMSMSMSXXXAAXSXXSASAAXMMMAMMAMAAAMMMMSAMAMMMAAMMMSXAXAMAMXMXMMSMSXXAAMMXMASMAAAAMMMMMAMXMAS
SAMSAMXMMASAXASAXMAMXSXSAMXSMAXMAMASAAAXSAMASXSAMXAXAAAAMSAMSXXAXSASXSMSAMXXXMMMSMXAAMMAMXMAXSAXAAXMXMMSXMASAMSAAMAMXXSSXMSAMMMSSMAMASXMSMMS
SAXSASMASAMMSAXMMSAMMMAXMAMXMXMSXSASXSMMMAMXSAXAMMMMMMMAMSAAXAMXMMAMAXAMSSXMMSMMMMSSSSSXMXMSXMASMSSMMSMMMSXSASXMSSXMAAXMASAAXSAMXMXSXMXAAMAM
SMMSAMXAMSSXMMMSAMXSAAAMMSAXMAXAMMAMAAAXSAMXMAMASAAAXAMSAMXMMAMMSXAMMMAMASAMAAAASAMAAAAAXMAMAAASAMXXAAAAAMMMXMXMAXASXSMSXMSSMMXMSAMXXSMSMSAA
XSAMMMMMSXMXAMXMXSMXXMSSXASAMXMSSMMMSMAMAMXXMSMSSMSSSXSAMXMXSAMXASASXSXMXSMMSSSMSXMMMMSAMXSSMMASMMSMSSSMXSAMXAXMASAMSAMXMAXMASXAAXMSAMXMASMS
