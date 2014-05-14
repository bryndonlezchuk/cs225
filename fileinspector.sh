#!/bin/bash
#set -x

ARG="$1"
FILETABLE="/root/bin/filetable.txt"

FILE="${ARG##*/}"
DIR="${ARG%/*}"

while [[ ! -f "$FILETABLE" ]]
do
	echo "Filetable not found. Would you like to specify a file?"
	read INPUT

	if [[ "$INPUT" =~ [nN] || "$INPUT" =~ [nN][oO] ]]
	then
		echo "Exiting fileinspector"
		exit
	elif [[ "$INPUT" =~ [yY] || "$INPUT" =~ [yY][eE][sS] ]]
	then
		echo "Please enter directory for the filetable:"
		read FILETABLE
		echo
	else
		echo "Invalid entry, exiting script"
                exit 1
	fi
done

if [[ -z "$DIR" ]]
then
	echo "Do you want to run fileinspector on the current directory?"

	select CHOICE in "Yes" "No"
	do
		case $CHOICE in
			Yes)
				DIR="."
				break ;;
			No)
				exit ;;
		esac
	done
fi

if ! cd "$DIR"
then
	echo "Invalid directory"
	exit 1
fi

if [[ -z "$FILE" ]]
then
	#Directory
	SET="$(ls -1)"
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

IFS=$'\n'

#for each item, match to mime
#from the mime type, apply file extention
for ITEM in $SET
do
	MIME="$(file --mime-type $ITEM | awk -F": " '{print $2}')"
	echo "Searching for type $MIME for file $ITEM"
	
	FILETYPE=$(grep "$MIME" $FILETABLE)
	
	if [[ ! -z "$FILETYPE" ]]
	then
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
	else
		echo "Filetype $FILETYPE was not found in filetable."
	fi
done
