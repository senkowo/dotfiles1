#!/bin/bash

echo "> cd ~/dwm"
cd ~/dwm 
sleep 1

echo "> git checkout master"
git checkout master
sleep 1

echo "> make clean"
make clean
sleep 1

echo "> trash config.h"
trash config.h
sleep 1

echo "> git reset --hard origin/master"
git reset --hard origin/master
sleep 1

echo -e "\nRun dwmbranchcheck.sh"
echo -e "Then git checkout -b <new-branch>"
