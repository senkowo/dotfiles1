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
			echo -e "invalid input, try again\n" ;; 
		esac
	done
}

echo "--------------------------------------------"
echo " lsblk"
echo "--------------------------------------------"
lsblk
echo "--------------------------------------------"
echo -e "Mount or Unmount? (1,m/2,u)"
read n
case $n in
	1|m)
		echo -en "Enter the name of the drive to mount:\n>> "
		read d
		ASK-TO-MOUNT "$d"
		;;
	2|u)
		echo -en "Enter the name of the drive to unmount:\n>> "
		read d 
		ASK-TO-UNMOUNT "$d"
		;;
	*)
		echo "invalid input"
		echo "exiting..."
		;;
esac





 

