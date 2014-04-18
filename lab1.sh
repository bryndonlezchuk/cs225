#!/bin/bash

cd /root/medialab/

LIST=$(ls)
MEDIA=$(grep filename media.xml | grep -v '><' | grep -v 'gportal' | grep -v 'NULL' | awk -F">" '{ print $2 }' | awk -F"<" '{ print $1 }')

for ITEM in $LIST
do
#	for testing:
#	echo "medialab contains $ITEM"

	if [ "$ITEM" = "media.xml" ]; then
		continue
	fi

	if [[ *"$ITEM"* != "$MEDIA" ]]
	then
		echo "$ITEM not found in media.xml"
	fi
done
