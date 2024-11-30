use Digest::MD5 qw(md5 md5_hex md5_base64);
use strict;
use warnings;

my $input = 'wtnhxymk';
my $i = 0;
my @digits = qw/. . . . . . . ./;
while(grep { $_ eq '.' } @digits) {
	my $hashed = md5_hex($input . $i);
	if(substr( $hashed, 0, 5) eq '00000') {
		my $pos = substr($hashed, 5, 1);
		if(ord($pos) < ord('8') && $digits[$pos] eq '.') {
			$digits[$pos] = substr($hashed, 6, 1);
		}
	}
	$i++;
	if($i % 100000 == 0) {
		print $i . $/;
	}
}
print join('', @digits) . $/;
