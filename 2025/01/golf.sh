perl -nle '/(\w)(\d+)/;$s=($s+($1eq"L"?-1*$2:$2))%100;$c++if$s==0}BEGIN{$s=50}END{print$c' < input.txt
perl -nle '/(\w)(\d+)/;$s=($s+($1eq"L"?-1*$2:$2))%100;$c++if$s==0}BEGIN{$s=50}END{print$c' < aoc-2025-day-1-challenge-1.txt
