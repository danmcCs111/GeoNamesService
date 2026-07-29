#!/bin/bash


if [ "$#" -ne 3 ]; then
	echo "provide: "
	echo "csv"
	echo "number of file splits"
	echo "save path" 
	exit
fi

fle=$1
count=$2
path=$3


len=$(( `wc -l $fle | egrep -o "[0-9]+"` ))
echo $len

it=$(( $len / $count ))
start=1
echo $it
dCounter=0

for t in $(eval echo "{1..$count}")
do
	if [ $t -eq $count ]
	then
		end=`wc -l $fle | awk '{print $1}'`
	else
		end=$(( $t * $it ))
	fi
	#processing.
	cat $fle | sed -n "${start}","${end}"p > $path/$fle-$t.csv
	start=$(( $end + 1))
done
