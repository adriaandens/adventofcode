map { $i++ if /^$/; $_[$i] += $_ } <>;
my @a = sort { $b <=> $a } @_;
print $a[0]+$a[1]+$a[2];

__END__
Inlining the sort and the map as in x.pl is wrong because map will return all elements, also the intermediate states of calory counting.
If one Elf has crazy amounts of calories, his intermediate values will rank in the Top 3, giving a wrong result.
That's why we need to be break and the final values, stored in @_ after the map.
