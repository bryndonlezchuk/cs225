#!/bin/bash

setup () {
	IFSTEMP="$IFS"
	IFS=$' \n\t'
}

quit () {
	IFS="$IFSTEMP"

	if [[ -z $1 ]]
	then
		exit 0
	elif [[ $1 =~ [0-9]* ]]
	then
		exit "$1"
	else
		
		exit 1
	fi
}

getargs () {
	local I=0
	for ITEM in $@
	do
		echo "$ITEM"
		ARGS[$I]="$ITEM"
		((I++))
	done

#	echo ${ARGS[@]}
}

#getops
while getopts :d:l:f:vh opt; do

	case $opt in
		d)	set -x;;
		h) ;;
		l) ;;
		f) ;;
		v) ;;
		\?) 	echo "Unknown option $opt"
	esac

done
shift $(($OPTFIND-1))

setup
getargs "$@"
quit
