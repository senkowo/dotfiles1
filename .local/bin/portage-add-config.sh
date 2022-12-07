#!/bin/bash

function REQUEST-INPUT() {
	local DIR=$1
	while : ; do
		clear
		echo -e "\n~ Portage auto-add configs ~\n"
		echo -ne "$DIR\n> "
		read n
		#echo "Value of n: $n" ; sleep 1
		# use global variable
		TOGO="$(echo "$DIR" | awk "/^$n.*$/" 2>/dev/null)"
		#echo "Value of TOGO: $TOGO" ; sleep 1
		if [[ $n =~ ^[0-9].*$ ]] && [[ $TOGO =~ ^[0-9].*$ ]]; then
			break;
		else
			echo "incorrect input"
			sleep 1
		continue;
		fi
	done
}

cd /etc/portage/
# store ls output
DIR="$(/bin/ls -l | grep package | awk '{print NR " " $9}')"
REQUEST-INPUT "$DIR"
#echo "here's TOGO out: $TOGO"

# Begin in next directory
cd $(echo "$TOGO" | awk '{print $2}')
DIR="$(/bin/ls -l | awk 'NR!=1 {print NR-1 " " $9}')"
REQUEST-INPUT "$DIR"
#echo "here's TOGO out: $TOGO"

doas nvim $(echo "$TOGO" | awk '{print $2}')

# end
