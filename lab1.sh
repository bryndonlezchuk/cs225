#!/bin/bash

cd /root/medialab/

LIST=$(ls | grep -v media.xml)
#MEDIA=$(grep filename media.xml | grep -v '><' | grep -v 'gportal' | grep -v 'NULL' | awk -F">" '{ print $2 }' | awk -F"<" '{ print $1 }')

COUNT=0

for ITEM in $LIST
do
#	for testing:
#	echo "medialab contains $ITEM"

#	if [ "$ITEM" = "media.xml" ]; then
#		continue
#	fi

	if ! grep -q "$ITEM" media.xml
	then
		echo "$ITEM not found in media.xml"
		(( COUNT++ ))
	fi
done
echo "$COUNT items not found"

