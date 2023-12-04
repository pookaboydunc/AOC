awk 'BEGIN{sum=0} {gsub(/[^0-9]+/,"",$1); n=split($1,a,""); sum +=  a[1]a[n]} END{print sum}' input.txt
