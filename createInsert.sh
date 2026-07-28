#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "need to provide processing file and output filename"
	exit
fi

fle=$1
outFle=$2

len=$(( `wc -l $fle | egrep -o "[0-9]+"` ))
echo $len
len=10
for i in $(eval echo "{1..$len}")
do
	b=$i
	e=1
	
	#front
	front=`cat US.csv | head -"${b}" | tail -"${e}" | sed 's/ /@/g' | sed 's/,/ /g' | awk '{print $1 " " $2 " " $3 " "}' | sed 's/@/ /g'`
	#back
	back=`cat US.csv | head -"${b}" | tail -"${e}" | sed 's/ /@/g' | sed 's/,/ /g' | awk '{print $(NF-2) " " $(NF-1) " " $(NF) " "}' | sed 's/@/ /g'`
	#middle
	middle=`cat US.csv | head -"${b}" | tail -"${e}" | sed 's/ /@/g' | sed 's/,/ /g' | awk '{ for (i=(NF-6); i <= NF-3; i++) print $i " "}' | sed 's/@/ /g'`

	out=$front$middle$back

	echo $i"/"$len " " $out
	echo $out >> $outFle
done

