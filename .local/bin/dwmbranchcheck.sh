#!/bin/bash

git branch | cat | awk '/\*/ {print $0}' 
