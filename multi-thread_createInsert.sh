#!/bin/bash


if [ "$#" -ne 4 ]; then
	echo "provide: "
	echo "csv"
	echo "output sql filename"
	echo "number of file splits"
	echo "drive path locations, '@' delimited"
	exit
fi

fle=$1
outFle=$2
count=$3
drives=$4
drives=( `echo $drives | sed 's/@/ /g'` )


len=$(( `wc -l $fle | egrep -o "[0-9]+"` ))
echo $len

it=$(( $len / $count ))
start=1
echo $it
drivesCount=${#drives[@]}
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
	path="${drives[$dCounter]}/"
	cat $fle | sed -n "${start}","${end}"p > $path$fle-$t.csv
	start=$(( $end + 1))

	./createInsert.sh $path$fle-$t.csv $path$outFle-$t.sql&

	dCounter=$(( $dCounter + 1 ))
	if [ $dCounter -eq $drivesCount ]
	then
		dCounter=0
	fi
done
