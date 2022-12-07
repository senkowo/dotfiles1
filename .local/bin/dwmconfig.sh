#!/bin/bash

echo "> cd ~/dwm"
cd ~/dwm
sleep 1

echo "> git checkout config"
git checkout config
sleep 1

echo "> nvim config.def.h"
sleep 1
nvim config.def.h
sleep 1

echo "> git add config.def.h"
git add config.def.h
sleep 1

echo -n "> git commit -m "
read a
git commit -m "$a"
sleep 1

echo "> git checkout custom"
git checkout custom
sleep 1

echo "> git merge config"
git merge config
echo -e "\n Now run dwmrecompile to recompile"
