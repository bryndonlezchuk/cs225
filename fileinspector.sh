#!/bin/bash
#set -x

ARG=$1
FILETABLE="/root/bin/filetable.txt"

FILE=${ARG##*/}
DIR=${ARG%/*}

if ! cd $DIR
then
	echo "Invalid directory"
	exit 1
fi

if [[ -z $FILE ]]
then
	#Directory
	SET=$(ls)
else
	#File

	#Check if file exist
	if ! ls $FILE &> /dev/null
	then
		echo "File does not exist"
		exit 1
	fi

	SET=$FILE
fi

#for each item, match to mime
#from the mime type, apply file extention
for ITEM in $SET
do
	echo "filetable.txt contains:"
	echo $FILETABLE

	MIME=$(file --mime-type $ITEM | awk '{print $2}')
	echo "Searching for type $MIME"
	
	FILETYPE=$( grep $MIME $FILETABLE)
	echo "Found $FILETYPE"
done
