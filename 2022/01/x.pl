map { $i++ if ! /\d+/; $_[$i] += $_ } <>;
my @a = sort { $a <=> $b } @_;
print $a[-1];
