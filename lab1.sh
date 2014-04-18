#!/bin/bash

cd /root/medialab/

LIST=$(ls)

for ITEM in $LIST
do
#	for testing:
#	echo "medialab contains $ITEM"

	if [ "$ITEM" = "media.xml" ]; then
		continue
	fi

	if [ grep "$ITEM" media.xml = "" ]
	then
		echo "$ITEM not found in media.xml"
	fi	
done
