#!/bin/bash

len=$(( `wc -l US.txt | egrep -o "[0-9]+"` ))
echo $len
for i in $(eval echo "{1..$len}")
do
	b=$i
	e=1
	
	#e=$i
	#sed -n "${b},${b}p" -E 's/[\t]+/,/g' US.txt
	
	out=`cat US.txt | head -"${b}" | tail -"${e}" | sed -E 's/[\t]+/,/g'`
	echo $i " " $out
done
