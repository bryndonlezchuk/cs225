#!/bin/bash

cd /root/medialab

MEDIA=$(grep filename media.xml | grep -v '><' | grep -v 'gportal' | grep -v 'NULL' | awk -F">" '{ print $2 }' | awk -F"<" '{ print $1 }')

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

