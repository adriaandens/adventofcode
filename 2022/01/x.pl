my @a = sort { $b <=> $a } map { $i++ if /^$/; $_[$i] += $_ } <>;
print $a[0];

__END__
The map returns the value of the last statement, which is what's in $_[$i].
It doesn't matter that we also output the intermediate values of summing since the final one will always be bigger (no negative input).
