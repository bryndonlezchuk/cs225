#!/bin/bash
#set -x

ARG="$1"
FILETABLE="/root/bin/filetable.txt"

FILE="${ARG##*/}"
DIR="${ARG%/*}"

while [[ ! -f "$FILETABLE" ]]
do
	echo "Filetable not found. Would you like to specify a file? (default yes)"
	read INPUT

	if [[ "$INPUT" =~ [nN] || "$INPUT" =~ [nN][oO] ]]
	then
		echo "Exiting fileinspector"
		exit
	else
		echo "Please enter directory for the filetable:"
		read FILETABLE
		echo
	fi
done

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
	if [[ ! -f "$FILE" ]]
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
	
	FILETYPE="$(grep $MIME $FILETABLE)"
	
	if [[ ! -z "$FILETYPE" ]]
	then
		echo "Found $FILETYPE"

		FILETYPE="${FILETYPE##*#@#}"
		echo "Filetype for $ITEM is $FILETYPE"
	else
		echo "Filetype not found in filetable. Would you like to add it? (default no)
		read INPUT

		if [[ "$INPUT" =~ [yY] || "$INPUT" =~ [yY][eE][sS] ]]
		then
			
		else
		fi
	fi

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
