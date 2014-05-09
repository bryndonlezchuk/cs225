#!/bin/bash
#set -x

ARG="$1"
FILETABLE="/root/bin/filetable.txt"

FILE="${ARG##*/}"
DIR="${ARG%/*}"

if [[ -z "$DIR" ]]
then
	echo "Do you want to run fileinspector on the current directory? (default no)"
	read INPUT

	if [[ "$INPUT" =~ [yY] || "$INPUT" =~ [yY][eE][sS] ]]
	then
		DIR="."
	else
		exit
	fi
fi

if ! cd "$DIR"
then
	echo "Invalid directory"
	exit 1
fi

if [[ -z "$FILE" ]]
then
	#Directory
	SET="$(ls)"
else
	#File

	#Check if file exist
	if ! ls "$FILE" &> /dev/null
	then
		echo "File does not exist"
		exit 1
	fi

	SET="$FILE"
fi

#for each item, match to mime
#from the mime type, apply file extention
for ITEM in $SET
do
	MIME="$(file --mime-type $ITEM | awk '{print $2}')"
	echo "Searching for type $MIME for file $ITEM"
	
	FILETYPE="$( grep $MIME $FILETABLE)"
	echo "Found $FILETYPE"

	FILETYPE="${FILETYPE##*#@#}"
	echo "Filetype for $ITEM is $FILETYPE"

	if [[ -z "${ITEM##*$FILETYPE}" ]]
	then
		echo "Extention already exists"
		echo
		continue
	else
		echo "Applying extention $FILETYPE to $ITEM"
		echo
		mv "$ITEM" "${ITEM}.$FILETYPE"
	fi
done
