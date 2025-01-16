```awk
awk 'BEGIN{sum=0} {gsub(/[^0-9]+/,"",$1); n=split($1,a,""); sum +=  a[1]a[n]} END{print sum}' input.txt
```

awk -F'[^0-9]+' '{print NF}' example.txt
sub("one"
sub("two"
sub("three"
sub("four"
sub("five"
sub("six"
sub("seven"
sub("eight"
sub("nine"