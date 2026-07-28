#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "need to provide processing file and output filename"
	exit
fi

fle=$1
outFle=$2

constructInsertStatement()
{
	front=$1
	middle=$2
	back=$3

	insertInto="INSERT INTO GeoLocation ("
	insertDefPrefix="CountryCode_GeoLocation_GeoNamesDatabase, PostalCode_GeoLocation_GeoNamesDatabase, PlaceName_GeoLocation_GeoNamesDatabase"
	adminInsertDef=( "AdminName1_GeoLocation_GeoNamesDatabase, AdminCode1_GeoLocation_GeoNamesDatabase" ", AdminName2_GeoLocation_GeoNamesDatabase, AdminCode2_GeoLocation_GeoNamesDatabase" ", AdminName3_GeoLocation_GeoNamesDatabase, AdminCode3_GeoLocation_GeoNamesDatabase" )
	insertDefSuffix="Latitude_GeoLocation_GeoNamesDatabase, Longitude_GeoLocation_GeoNamesDatabase, Accuracy_GeoLocation_GeoNamesDatabase )"

	middleArgCount=`echo $middle | grep -o "," | wc -m`
	middleArgDef=""

	for i in $(eval echo "{1..$middleArgCount}")
	do
		middleArgDef=$middleArgDef`echo ${adminInsertDef[$(( $i - 1 ))]}`
	done

	echo $insertInto $insertDefPrefix $middleArgDef $insertDefSuffix
	constructValuesStatement "$front" "$middle" "$back"
}

constructValuesStatement()
{
	front=$1
	middle=$2
	back=$3

	#TODO quotes/no quotes
	echo "VALUES (" $front $middle $back ");"
}

len=$(( `wc -l $fle | egrep -o "[0-9]+"` ))
echo $len
len=10

for i in $(eval echo "{1..$len}")
do
	b=$i
	e=1
	
	#front
	front=`cat US.csv | head -"${b}" | tail -"${e}" | sed 's/ /@/g' | sed 's/,/ /g' | awk '{print $1 ", " $2 ", " $3 ", "}' | sed 's/@/ /g'`

	#middle
	middle=`cat US.csv | head -"${b}" | tail -"${e}" | sed 's/ /@/g' | sed 's/,/ /g' | awk '{ for (i=(NF-6); i <= NF-3; i++) print $i ", "}' | sed 's/@/ /g'`

	#back
	back=`cat US.csv | head -"${b}" | tail -"${e}" | sed 's/ /@/g' | sed 's/,/ /g' | awk '{print $(NF-2) ", " $(NF-1) ", " $(NF) ", "}' | sed 's/@/ /g' | sed -E 's/[, ]+$//g'`



	out=$front$middle$back

	constructInsertStatement "$front" "$middle" "$back"

	echo $i"/"$len " " $out
	echo $out >> $outFle
done

