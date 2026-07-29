#!/bin/bash


if [ "$#" -ne 3 ]; then
	echo "provide: "
	echo "csv"
	echo "max count in file to split"
	echo "save path" 
	exit
fi

fle=$1
maxCount=$2
path=$3


len=$(( `wc -l $fle | egrep -o "[0-9]+"` ))
echo $len

count=$(( $len / $maxCount ))
start=1
echo $count
dCounter=0

for t in $(eval echo "{1..$count}")
do
	if [ $t -eq $count ]
	then
		end=`wc -l $fle | awk '{print $1}'`
	else
		end=$(( $t * $maxCount ))
	fi
	#processing.
	cat $fle | sed -n "${start}","${end}"p > $path/$fle-$t.csv
	start=$(( $end + 1))
done
