#!/bin/bash

cd /root/medialab/

LIST=$(ls)

for ITEM in $LIST
do
	echo "medialab contains $ITEM"
done | less
