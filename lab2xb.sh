#!/bin/bash

cd /root/medialab/

LIST=$(ls | grep -v media.xml)


COUNT=0

for ITEM in $LIST
do

	if ! grep -q "$ITEM" media.xml
	then
		echo "$ITEM not found in media.xml"
		(( COUNT++ ))
	fi
done
echo "$COUNT items not found"


MEDIA=$(grep -e ".mpg" -e ".mp3" media.xml | awk -F">" '{ print $2 }' | awk -F"<" '{ print $1 }' | sort -u)

COUNT=0

for ITEM in $MEDIA
do
	if [ ! -f "$ITEM" ]
	then
		echo "$ITEM"
		(( COUNT++ ))
	fi
done
echo "$COUNT media files not found"

