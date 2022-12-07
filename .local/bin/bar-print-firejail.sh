#!/bin/bash

echo -n 'fj: '
firejail --list | sed 's/.*\///g' | wc -w
