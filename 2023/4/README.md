```awk
awk -F\| 'BEGIN{total=0} {matches=0; print "new card"; gsub(/Card .*:/,"",$1); n=split($1,a,/[[:space:]]+/); n2=split($2,b,/[[:space:]]+/); for (idx in b) for (idx2 in a) if (b[idx] == a[idx2]) print b[idx] "and" a[idx2];}' example.txt
```

```awk
awk 'BEGIN{total=0} {matches=0; card[$3]=$3; -12}' example.txt
```