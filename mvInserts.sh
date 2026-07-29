#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "provide: "
	echo "output path"
	echo "drive path locations, '@' delimited"
	exit
fi

outPath=$1
drives=$2
drives=( `echo $drives | sed 's/@/ /g'` )

for dr in ${drives[@]}
do 
	mv $dr/*.csv $outPath
	mv $dr/*.sql $outPath
done
