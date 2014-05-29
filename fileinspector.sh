#!/bin/bash

setup () {
	IFSTEMP="$IFS"
	IFS=$' \n\t'
	getargs "$@"
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

syntax () {
	echo
}

message () {
	echo
}

errormessage () {
	cmessage "red" "ERROR: $1\n"
}

cmessage () {
	local COLOR
	local MSG=$2

	case $1 in
		black)	COLOR='\e[0;30m';;
		red)	COLOR='\e[0;31m';;
		green)	COLOR='\e[0;32m';;
		yellow)	COLOR='\e[0;33m';;
		blue)	COLOR='\e[0;34m';;
		purple) COLOR='\e[0;35m';;
		cyan)	COLOR='\e[0;36m';;
		white)	COLOR='\e[0;37m';;
	esac

	echo -ne "${COLOR}${MSG}\e[0;37m"
}

main () {
	echo
}

VERBOSE="OFF"
LOGFILE="OFF"
FILETABLE="/root/bin/filetable.txt"

#getops
while getopts :dl:f:vh opt; do

	case $opt in
		#Debug
		d)	set -x;;

		#Help
		h)	echo "Help coming soon"
			quit;;

		#Logfile
		l)	;;

		#Filetable
		f)	FILETABLE="$OPTARG"
                        if [[ ! -f "$FILETABLE" ]]
                        then
				errormessage "Filetable could not be located at $FILETABLE"
                        fi;;

		#Verbose
		v)	VERBOSE="ON";;

		#Recursive
		r)	;;

		#Other
		\?) 	echo "Unknown option"
			$0 -h;;
	esac

done
shift $(($OPTIND-1))

setup "$@"
quit
