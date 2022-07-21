#!/bin/bash

RED='\u001b[31m'
GREEN='\u001b[32m'
YELLOW='\u001b[33m'
NC='\u001b[0m'

BOLD='\e[1m'
UNDERLINE='\e[4m'
ITALIC='\e[3m'
OVERLINE='\e[53m'
NS='\e[0m'

function PRINT-STATUS()
{
	daemon=$(rc-status -a | grep dropbox | sed 's/.*\[/\[/' | sed 's/\].*/\]/' )
	if [[ $(echo $daemon | cut -d, -f 3 ) == *"started"* ]]; then
		echo -e "${GREEN}${daemon}${NC}\n"
	elif [[ $(echo $daemon | cut -d, -f 3 ) == *"stopped"* ]]; then 
		echo -e "${RED}${daemon}${NC}\n"
	elif [[ $(echo $daemon | cut -d, -f 3 ) == *"crashed"* ]]; then 
		echo -e "${YELLOW}${daemon}${NC}\n"
	else
		echo "$daemon"
	fi 
}

case $1 in 
	stop|1)
		doas rc-service dropbox stop ;;
	start|2)
		doas rc-service dropbox start ;;
	status|3)
		PRINT-STATUS ;;
	*)
		echo -e "\n${BOLD}Toggle dropbox service${NS}\n"
		echo -e "Available commands:\n 1, stop\n 2, start\n 3, status\n 0, exit, quit\n"
		echo -e "${ITALIC}Current dropbox status:${NS}"

		PRINT-STATUS

		echo -n ">> "
		read n
		case $n in 
			stop|1)
				doas rc-service dropbox stop ;;
			start|2)
				doas rc-service dropbox start ;;
			status|3)
				PRINT-STATUS ;;
			exit|quit|0)
				echo "exiting..." ;;
			*)
				echo "improper statement: \"$n\"" ;;
		esac
esac

