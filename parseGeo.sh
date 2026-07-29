#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "need to provide processing file and output filename"
	exit
fi

fle=$1
outFle=$2

len=$(( `wc -l $fle | egrep -o "[0-9]+"` ))
echo $len
for i in $(eval echo "{1..$len}")
do
	b=$i
	e=1
	
	#e=$i
	#sed -n "${b},${b}p" -E 's/[\t]+/,/g' $fle
	
	out=`sed -n "${b},${b}p" $fle | sed -E 's/[\t]+/,/g'`
	echo $i"/"$len " " $out
	echo $out >> $outFle
done
