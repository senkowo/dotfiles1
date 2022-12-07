#!/bin/bash

cd ~/dwm

echo -n "> git checkout"
git branch | cat | awk '/\*/ {print $0}' | sed s/^.//
sleep 2

echo "> trash config.h"
trash config.h

echo "> make && doas make clean install"
make && doas make clean install

cd -
