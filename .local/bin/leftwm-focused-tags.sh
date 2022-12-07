#!/bin/bash

###[ Note: Run the command with parameters "+" or "-" to cycle forwards or ]###
###[       backwards, respectively.                                        ]###

# Get info of all tags
FULL=$(leftwm-state -q)

# Keep only info for the current workspace (monitor?)
FULL=$( 
	echo "$FULL" |
	awk -v RS="]}" '/"mine":true[^}]*"focused":true/ { 
		print $0
	}' 
)

# Get the currently focused tag number
NOW=$( 
	echo "$FULL" | 
	awk -v RS='{' '/"focused":true/ { 
		beg = index($0, name);
		print substr($0, beg+8, 1)
	}'
)

# Get all occupied tag numbers and turn them into an array
BUSY=$( 
	echo "$FULL" | 
	awk -v RS='{' '/"busy":true/ {
		beg = index($0, busy); 
		print substr($0, beg+8, 1)
	}' |
	tr '\n' ' '
)
BUSY=( $BUSY )
arr_len=${#BUSY[@]}

# Get current workspace (monitor?) index
WORKSPACE=$( 
	echo "$FULL" |
	awk -v RS='{' '/"layout".*"index".*"tags":/ { 
		beg = index($0, "index"); 
		print substr($0, beg+7, 1) 
	}'
)


# Below identifies the destination tag ($DEST), or the tag to go to
DEST=""
if [[ "$1" == "+" ]]; then
	DEST=${BUSY[0]}
	for (( i=0; i<arr_len; i++ )); do
		if (( ${BUSY[$i]} > $NOW )); then
			DEST=${BUSY[$i]}
			break
		fi
	done
elif [[ "$1" == "-" ]]; then
	DEST=${BUSY[$arr_len-1]}
	for (( i=$arr_len-1; i>=0; i-- )); do
		if (( ${BUSY[$i]} < $NOW )); then
			DEST=${BUSY[$i]}
			break
		fi
	done
else
	echo "Error: Pass \"+\" or \"-\" as parameter to run"
	exit 1
fi

# Move to tag $DEST on $WORKSPACE. (haven't tested much with workspaces)
leftwm-command "SendWorkspaceToTag $WORKSPACE $(($DEST-1))"


