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
my $dirs_total_size_smaller_than_100000 = 0;
print "\n\n\n";
rec($root_dir, 0);
print $dirs_total_size_smaller_than_100000;

sub rec {
	my $dir = shift;
	my @subdirs = @{$dir->{subdirs}};
	print "Subdirs: @subdirs\n";
	my $direct_filesize = $dir->{direct_filesize};
	print "Filesize: $direct_filesize\n";

	my $total_size = $direct_filesize;
	foreach(@subdirs) {
		$total_size += rec($dir->{$_});
	}
	
	if($total_size <= 100000) {
		print "Directory $dir->{name} has less than 100.000 total size\n";
		$dirs_total_size_smaller_than_100000 += $total_size;
	}

	return $total_size;
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
