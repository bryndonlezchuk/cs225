#!/bin/bash

#fileinspector v3	May 29, 2014
#Bryndon Lezchuk (bryndonlezchuk@gmail.com)

setup () {
	IFSTEMP="$IFS"
	IFS=$' \n\t'
	getargs "$@"
	RUNDIR="$(pwd)"
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
	echo
	local I=0
	for ITEM in "$@"
	do
		message "ARG[$I]=$ITEM" "yellow"
		ARGS[$I]="$ITEM"
		((I++))
	done
	echo
}

message () {
	if [[ -z "$2" ]]
	then
		echo -e "$1"
	else
		cmessage "$2" "$1\n"
	fi
}

errormessage () {
	cmessage "red" "ERROR: $1\n" >&2
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

yesnoquit () {
	while true
	do
		message "$1 (yes/no/quit)"
		read INPUT

		case $INPUT in
			y | Y | yes | Yes)
				return 0;;
			n | N | no | No)
				return 1;;
			q | Q | quit | Quit)
				quit;;
			*)	message "Unkown input, please try again";;
		esac
	done
}

#---------------------------------------------------------
#	Start of program specific functions
#---------------------------------------------------------

syntax () {
	message "Usage: fileinspector [-dvrh] [-l logfile] [-f filetable] file | directory"
}

main () {
	if [[ ${#ARGS[@]} -eq 0 ]]
	then
		if yesnoquit "No arguments found, run on the current directory?"
		then
			addextension "./"
		else
			syntax
		fi
	else
		for ARG in "${ARGS[@]}"
		do
			addextension "$ARG"
		done
	fi
}

addextension () {
	local ARG=$1

	local DIR="${ARG%/*}"
	local FILE="${ARG##*/}"

	if ! cd "$DIR" &> /dev/null
	then
		errormessage "Directory '${DIR}' not found\n"
		cd "$RUNDIR"
		return 1
	fi

	if [[ -z "$FILE" ]]
	then	
		#Directory
		SET="$(getset "$DIR")"
	else	
		#File
		if [[ ! -f "$FILE" ]]
		then
			errormessage "File '${FILE}' not found\n"
			return 1
		else
			SET="$FILE"
		fi
	fi

	for ITEM in $SET
	do
		MIME="$(file --mime-type "$ITEM" | awk -F": " '{print $2}')"
                verbout "Serching for type $MIME for file $ITEM"

		FILETYPE="$(grep "$MIME" "$FILETABLE")"
		if [[ ! -z "$FILETYPE" ]]
		then
			verbout "Found $FILETYPE"

			FILETYPE="${FILETYPE##*#@#}"
			verbout "Filetype for $ITEM is $FILETYPE"

			if [[ -z "${ITEM##*$FILETYPE}" ]]
			then
				verbout "Extension already exists for file $ITEM\n"
				continue
			else
				verbout "Applying extension $FILETYPE to $ITEM\n
#				mv "$ITEM" "${ITEM}.$FILETYPE"
			fi
		fi
	done

	cd "$RUNDIR"
}

getset () {
	echo "$(ls -1)"
}

verbout () {
	if [[ "$VERBOSE" = "ON" ]]
	then
		message "$1" "cyan"
	fi
}

#---------------------------------------------------------
#		End of functions
#---------------------------------------------------------
#		Start of getopts
#---------------------------------------------------------

VERBOSE="OFF"
LOGFILE="OFF"
RECURSIVE="OFF"
FILETABLE="/root/bin/filetable.txt"

#getops
while getopts :dl:f:vh opt; do

	case $opt in
		#Debug
		d)	set -x;;

		#Help
		h)	syntax
			quit;;

		#Logfile
		l)	;;

		#Filetable
		f)	FILETABLE="$OPTARG"
                        if [[ ! -f "$FILETABLE" ]]
                        then
				errormessage "Filetable could not be located at $FILETABLE"
			quit 1
                        fi;;

		#Verbose
		v)	VERBOSE="ON";;

		#Recursive
		r)	RECURSIVE="ON";;

		#Other
		\?) 	echo "Unknown option"
			syntax
			quit 1;;
	esac

done
shift $(($OPTIND-1))

#---------------------------------------------------------
#		End of getopts
#---------------------------------------------------------

setup "$@"
main
quit
