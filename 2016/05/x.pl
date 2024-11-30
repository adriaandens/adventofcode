use Digest::MD5 qw(md5 md5_hex md5_base64);
use strict;
use warnings;

my $input = 'wtnhxymk';
my $i = 0;
my @digits = ();
while(scalar(@digits) != 8) {
	my $hashed = md5_hex($input . $i);
	if(substr( $hashed, 0, 5) eq '00000') {
		push @digits, substr($hashed, 5, 1);
	}
	$i++;
	if($i % 100000 == 0) {
		print $i . $/;
	}
}
print join('', @digits) . $/;
