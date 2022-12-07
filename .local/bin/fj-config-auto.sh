#!/bin/bash

cd ~/.config/firejail

ls -al --color=always

echo -en "\nEnter filename\n> "
read n
nvim $n
