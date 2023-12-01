# awk

## Problem
--- Day 1: Not Quite Lisp ---
Santa was hoping for a white Christmas, but his weather machine's "snow" function is powered by stars, and he's fresh out! To save Christmas, he needs you to collect fifty stars by December 25th.

Collect stars by helping Santa solve puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

Here's an easy puzzle to warm you up.

Santa is trying to deliver presents in a large apartment building, but he can't find the right floor - the directions he got are a little confusing. He starts on the ground floor (floor 0) and then follows the instructions one character at a time.

An opening parenthesis, (, means he should go up one floor, and a closing parenthesis, ), means he should go down one floor.

The apartment building is very tall, and the basement is very deep; he will never find the top or bottom floors.

For example:

(()) and ()() both result in floor 0.
((( and (()(()( both result in floor 3.
))((((( also results in floor 3.
()) and ))( both result in floor -1 (the first basement level).
))) and )())()) both result in floor -3.
To what floor do the instructions take Santa?

Your puzzle answer was 138.

--- Part Two ---
Now, given the same instructions, find the position of the first character that causes him to enter the basement (floor -1). The first character in the instructions has position 1, the second character has position 2, and so on.

For example:

) causes him to enter the basement at character position 1.
()()) causes him to enter the basement at character position 5.
What is the position of the character that causes Santa to first enter the basement?

Your puzzle answer was 1771.

## Solutions
### Part 1
#### #1
Split line by `(` and get number of fields. Take length of the line minus the number of feilds to find number of `)`. subtracted the later from the former gives the floor number.
```awk
awk -F\( '{print (NF-1) - (length - (NF-1))}' input.txt
```
#### #2
Same as above except calulating numbers of open and closed parens using gsub.
```awk
awk '{print gsub(/\(/,1,$1) - gsub(/\)/,1,$1)}' input.txt
```
#### #3
More complicated solution using an array and for loop.
```awk
awk '{f=0; split($1,a,""); for (key in a) if(sub(/\(/,1,a[key])==1) f++; else f--; print f}' input.txt
```

### Part 2
#### #1
Similar to the last solution of part but this time checking for `f == -1` and also using the return of split to dictate for loop and index of the -1 floor.
```awk
awk '{f=0; len=split($1,a,""); for (i=1; i <=len; i++) if(a[i]=="(") f++; else if ((f-1) == -1) break; else f--; print i}' input.txt
```
