#!/bin/bash

cd /root/bin

clear

FILETABLE=$(cat filetable.txt | sort -u)

cat filetable.txt
echo

for MIME in $FILETABLE
do
	echo $MIME
	if ! echo $MIME | grep -q "#@#"
	then
		echo "Please enter file extention of type $MIME"
		read TYPE

		COUNT=5
		while [[ -z $TYPE && $COUNT -ne 0 ]]
		do
			echo "Invalid entry, please try again ($COUNT tries remaining):"
			read TYPE
			((COUNT--))
		done

		if [ $COUNT -eq 0 ]
		then
			continue
		fi
	fi
done
