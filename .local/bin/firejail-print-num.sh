#!/bin/bash

list=$(firejail --list | sed 's/.*\///g')

# echo "$list"

echo "$(echo "$list" | wc -w)"
