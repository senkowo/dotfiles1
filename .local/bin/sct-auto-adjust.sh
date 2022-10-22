#!/bin/bash

time="$(date +"%H")"
sct="env DISPLAY=:0 XAUTHORITY=$HOME/.Xauthority /usr/bin/sct"

if (( $time > 5 )); then
	if (( $time < 17 )); then
		$sct
		exit 0
	fi
fi

#
# 17 5
# 18 6
# 19 7
# 20 8
# 21 9
# 22 10
# 23 11
# 24 12
# 0  12
#

case $time in
 17)
	 $(echo "$sct 5600") ;;
 18)
	 $(echo "$sct 5000") ;;
 19)
	 $(echo "$sct 4600") ;;
 20)
	 $(echo "$sct 3800") ;;
 21|22|23|24)
	 $(echo "$sct 3600") ;;
 00|01|02|03|04|05)
	 $(echo "$sct 3000") ;;
esac

