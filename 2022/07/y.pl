my %dirs = (
);

my $current_dir = create_dir('root', undef);
$dirs{'root'} = $current_dir;

<>; # don't care about "cd /"
while(<>) {
	chomp;
	if(/^\$ (.*)/) {
		my $command = $1;
		print "Command is $1\n";
		if($command eq 'cd ..') {
			$current_dir = $current_dir->{dotdot};
		} elsif($command eq 'ls') {

		} elsif($command =~ /cd (.*)/) {
			print "Changing dir to $1\n";
			my $new_dir = create_dir($1, $current_dir);
			$current_dir->{$1} = $new_dir; # add it as a child
			$current_dir = $current_dir->{$1}; # this becomes our new current dir
		}
	} elsif(/^dir (.*)/) {
		my $dir = $1;
		# this is a subdir of us...
		push(@{$current_dir->{subdirs}}, $dir);
	} elsif(/^(\d+) (.*)/) {
		my ($size, $filename) = ($1, $2);
		print "Found file $filename with size $size\n";
		$current_dir->{direct_filesize} += $size;
	}
}

$root_dir = $dirs{root};
print "\n\n\n";
$total_size = rec($root_dir, 0);
my $free_space = 70000000-$total_size;
my $space_needed = 30000000;
my $to_clear = $space_needed - $free_space;
print "We occupy $total_size out of 70000000\n";
print "Meaning we have $free_space bytes\n";
print "To have 30000000 bytes free, we need to clear at least $to_clear\n";
print $total_size . "\n";

my $just_big_enough = 70000000;
rec2($root_dir);
print $just_big_enough . "\n";

sub rec {
	my $dir = shift;
	my @subdirs = @{$dir->{subdirs}};
	my $direct_filesize = $dir->{direct_filesize};

	my $total_size = $direct_filesize;
	foreach(@subdirs) {
		$total_size += rec($dir->{$_});
	}
	
	if($total_size <= 100000) {
		$dirs_total_size_smaller_than_100000 += $total_size;
	}

	$dir->{total_size} = $total_size;
	return $total_size;
}

sub rec2 {
	my $dir = shift;
	if($dir->{total_size} - $to_clear >= 0) {

		if($dir->{total_size} < $just_big_enough) {
			$just_big_enough = $dir->{total_size};
		}

		# Maybe a subdir is big enough?
		foreach(@{$dir->{subdirs}}) {
			rec2($dir->{$_});
		}

	} else {
		print "total dir is too small, so any subfolders will also be too small\n";
	}
}

sub create_dir {
	my $name = shift;
	my $current_dir = shift;
	my %new_dir = (
		'name' => $name,
		'dotdot' => $current_dir
	);
	return \%new_dir;
}
