#!/bin/bash

# asks to mount argument drive
function ASK-TO-MOUNT() {
	while : ; do
		echo "mount drive \"$1\" on /mnt ? (y/n)"
		read n
		case $n in
			y)
			echo "mounting..."
			doas mount /dev/$1 /mnt 
			break ;;
			n)
			echo "exiting..." 
			break ;;
			*)
			echo -e "invalid input, try again\n" ;; 
		esac
	done
}
# prints lsblk and prompts for drive to mount
function ENTER-CUSTOM-MOUNT() {
	echo "--------------------------------------------"
	echo " lsblk"
	echo "--------------------------------------------"
	lsblk
	echo "--------------------------------------------"
	echo -en " Enter the name of the drive to mount:\n>> "
	read d
	ASK-TO-MOUNT "$d"
}
# asks to unmount argument drive
function ASK-TO-UNMOUNT() {
	while : ; do
		echo "unmount drive \"$1\" on /mnt ? (y/n)"
		read n
		case $n in
			y)
			echo "unmounting..."
			doas umount /dev/$1 
			break ;;
			n)
			echo "exiting..."
			break ;;
			*)
			echo -e "invalid input, try again\n" ;; # loop here?
		esac
	done
}
# prints lsblk and prompts for drive to mount
function ENTER-CUSTOM-UNMOUNT() {
	echo "--------------------------------------------"
	echo " lsblk"
	echo "--------------------------------------------"
	lsblk
	echo "--------------------------------------------"
	echo -en " Enter the name of the drive to unmount:\n>> "
	read d 
	ASK-TO-UNMOUNT "$d"
}
# asks to unmount argument drive

echo "Mount or Unmount? (1,m/2,u)"
read n
case $n in
	1|m)
		# check if 1.8T drive is sdb2, then perform appropriate actions
		if [[ "echo $lsblk | grep -E '1.8T.*?part'" == *"sdb2"* ]]; then
			while : ; do
				echo "drive sdb2 found. Mount? (y/n)"
				read n
				case $n in
					y)
					ASK-TO-MOUNT "sdb2" 
					break ;;
					n)
					ENTER-CUSTOM-MOUNT 
					break ;;
					*)
					echo -e "invalid input, try again\n" ;; # loop here?
				esac
			done
		else 
			ENTER-CUSTOM-MOUNT
		fi ;;
	2|u)
		# check if a drive is already mounted on /mnt
		if [[ "$lsblk" == *"/mnt"* ]]; then
			local mnt = $(lsblk | grep -E /mnt | awk '{print $1}' | sed 's/^..//')
			while : ; do
				echo "there is already a drive mounted at /mnt called \"$mnt\". Unmount?"
				read n
				case $n in
					y)
					ASK-TO-UNMOUNT "$mnt"
					break ;;
					n)
					ENTER-CUSTOM-UNMOUNT 
					break ;;
					*)
					echo -e "invalid input, try again\n" ;; # loop here?
				esac
			done
		else
			ENTER-CUSTOM-UNMOUNT
		fi ;;
	*)
		echo "invalid input"
		echo "exiting..." ;;
esac





 

