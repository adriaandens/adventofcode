use v5.40;

$_ = <DATA>;
say $_;
my $c = 0;
foreach(split /,/) {
	my ($s, $e) = split /-/;
	foreach my $n ($s..$e) {
		my @a = split //, $n;
		my @invalids = invalid_searcher(@a);
		say "Found: @invalids";
		foreach(@invalids) {
			$c += $_;
		}
	}
}

say "Solution: $c";

sub invalid_searcher {
	# if we have a number of a certain length, we need to go down to 2 and anything it's divisible by
	my $l = scalar(@_);
	my %invalids = ();
	while($l > 1) {
		if(@_ % $l == 0) {
			say "Array @_ of size " . scalar(@_) . " is divisble by length $l";
			my $pieces = generate_pieces($l, @_);
			foreach(@$pieces) {
				my $lol = join('', @$_);
				say "piece: $lol";
			}
			if(compare_pieces(@$pieces)) {
				say "\tit's all the same: @_";
				$invalids{join('', @_)} = 1;
			}
		}
		$l--;
	}
	return keys(%invalids);
}

sub generate_pieces {
	my ($l, @arr) = @_;
	my @pieces = ();
	my $piece_size = @arr / $l;
	while(scalar(@arr) > $piece_size) {
		my @piece = splice @arr, 0, $piece_size;
		say "\t\tbroken off: @piece ; remaining @arr";
		push @pieces, \@piece;
	}
	push @pieces, \@arr;
	return \@pieces;
}

sub compare_pieces {
	my @strings = ();
	return 0 if scalar(@_) < 2;
	foreach(@_) {
		push @strings, join('', @$_);
	}
	say "\tcomparing piece strings: @strings";
	my $same = 1;
	foreach(0..$#strings-1) {
		if($strings[$_] ne $strings[$_+1]) {
			$same = 0;
			last;
		}
	}
	return $same;
}

__DATA__
990244-1009337,5518069-5608946,34273134-34397466,3636295061-3636388848,8613701-8663602,573252-688417,472288-533253,960590-988421,7373678538-7373794411,178-266,63577667-63679502,70-132,487-1146,666631751-666711926,5896-10827,30288-52204,21847924-21889141,69684057-69706531,97142181-97271487,538561-555085,286637-467444,93452333-93519874,69247-119122,8955190262-8955353747,883317-948391,8282803943-8282844514,214125-236989,2518-4693,586540593-586645823,137643-211684,33-47,16210-28409,748488-837584,1381-2281,1-19
