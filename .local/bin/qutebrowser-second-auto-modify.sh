#!/bin/bash

# config-write-py --defaults

FILE="${HOME}/.config/qutebrowser/config.py"

function MODIFY()
	VAR_TYPE="" # Can be equals or param

	# 1 : Get the Original Line in the file
	PRINTED_LN=$(grep $1 $FILE)
	echo $PRINTED_LN # print the original

	# 2 : Identify the type
	if $(grep -Eoq '.*\s=\s.*\)' <<< $PRINTED_LN); then
		VAR_TYPE='equals'
	elif $(grep -Eoq '.*\(.*\)' <<< $PRINTED_LN); then
		VAR_TYPE='param'
	else 
		echo "error at variable check"
		exit 1
	fi

	# 3 : Uncomment if necessary
	# Can i do all this in one awk command?
	while : ; do
		if $(grep -q '^#' <<< $LINE); then
			PRINTED_LN=$(echo $PRINTED_LN | awk '{print substr($0,1)}')
		else
			break
		fi
	done
	awk '{ while ( ) { print substr($0,1) } }




MODIFY config.load_autoconfig False

MODIFY c.colors.webpage.darkmode.enabled True

MODIFY c.auto_save.session True

MODIFY c.url.searchengines "{'DEFAULT': 'https://searx.tiekoetter.com/search?q={}'}"

