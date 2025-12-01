# deel 1
perl -nle '/(\w)(\d+)/;$s=($s+($1eq"L"?-1*$2:$2))%100;$c++if$s==0}BEGIN{$s=50}END{print$c' < input.txt
perl -nle '/(\w)(\d+)/;$s=($s+($1eq"L"?-1*$2:$2))%100;$c++if$s==0}BEGIN{$s=50}END{print$c' < aoc-2025-day-1-challenge-1.txt
# deel 2
perl -nle '/(\w)(\d+)/;$a=$1eq"L"?-1*$2:$2;my$mod=1if$1eq"L"&&$s>0;$c+=int(abs($s+$a)/100)+$mod if$s+$a<=0||$s+$a>=100;$s=($s+$a)%100;}BEGIN{$s=50}END{print$c' < input.txt
perl -nle '/(\w)(\d+)/;$a=$1eq"L"?-1*$2:$2;my$mod=1if$1eq"L"&&$s>0;$c+=int(abs($s+$a)/100)+$mod if$s+$a<=0||$s+$a>=100;$s=($s+$a)%100;}BEGIN{$s=50}END{print$c' < aoc-2025-day-1-challenge-1.txt
