#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "need to provide processing file and output filename"
	exit
fi

fle=$1
outFle=$2
count=$3


len=$(( `wc -l $fle | egrep -o "[0-9]+"` ))
echo $len

it=$(( $len / $count ))
start=1
echo $it

for t in $(eval echo "{1..$count}")
do
	if [ $t -eq $count ]
	then
		end=`wc -l $fle | awk '{print $1}'`
	else
		end=$(( $t * $it ))
	fi
	#processing.
	cat $fle | sed -n "${start}","${end}"p > $fle-$t.txt
	start=$(( $end + 1))

	./createInsert.sh $fle-$t.txt $outFle-$t.txt&
done
