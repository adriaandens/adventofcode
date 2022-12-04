map {
	/(\d+)-(\d+),(\d+)-(\d+)/;
	$total++ if ! ($2 < $3 || $4 < $1);
} <>;
print $total;
