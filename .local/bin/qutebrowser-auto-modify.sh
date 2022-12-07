#!/bin/bash

# config-write-py --defaults

FILE="${HOME}/.config/qutebrowser/config.py"

function MODIFY()
{
	# save line to modify
	ORIG_LINE=$(grep $1 $FILE)
	LINE="$ORIG_LINE"
	echo "$LINE"

	# check type of variable
	VAR_TYPE=""
	if $(echo $LINE | grep -Eoq '.*\(.*\)'); then
		VAR_TYPE="method"
	elif $(echo $LINE | grep -Eoq '.*\s=\s.*'); then
		VAR_TYPE="equals"
	else 
		echo "error at variable check"
		exit 1
	fi

	# uncomment but with loops
	while : ; do
		if $(echo $LINE | grep -q '^#'); then
			LINE="$(echo $LINE | sed 's/^.*#//')"
		else
			break
		fi
	done
	LINE="$(echo $LINE | sed 's/^. //')"

	# change parameter/value
	if [[ $VAR_TYPE == "method" ]]; then 
		PARAM="$(echo $LINE | sed -n "s/^.*(\(\S*\)).*$/\1/p")"
		if [[ $2 != $PARAM ]]; then
			LINE="$(echo "$1($2)")"
		fi 
	elif [[ $VAR_TYPE == "equals" ]]; then 
		PARAM="$(echo $LINE | sed -n "s/^.*=\s*\(.*\).*$/\1/p")"
		if [[ $2 != $PARAM ]]; then
			LINE="$(echo "$1 = $2")"
		fi 
	else
		echo "error at change parameter"
		exit 1
	fi

	# print final changes
	echo -e "$LINE\n"

	# execute
	sed -i "s|$ORIG_LINE|$LINE|" $FILE
}

echo -e "\nChanging qutebrowser settings...\n"

MODIFY config.load_autoconfig False

MODIFY c.colors.webpage.darkmode.enabled True

MODIFY c.auto_save.session True

MODIFY c.url.searchengines "{'DEFAULT': 'https://searx.tiekoetter.com/search?q={}'}"




