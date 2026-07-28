#!/bin/bash

fle=$1

len=$(( `wc -l $fle | egrep -o "[0-9]+"` ))
echo $len
for i in $(eval echo "{1..$len}")
do
	b=$i
	e=1
	
	#e=$i
	#sed -n "${b},${b}p" -E 's/[\t]+/,/g' $fle
	
	out=`cat $fle | head -"${b}" | tail -"${e}" | sed -E 's/[\t]+/,/g'`
	echo $i"/"$len " " $out
done
