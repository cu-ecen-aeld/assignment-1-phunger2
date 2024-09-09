#!/bin/bash

if [ ! $# -eq 2 ]
then
	echo "2 arguments are required."
	echo "1st Argument: Full path to file to create (or overwrite)"
	echo "2nd Argument: Text string to be written within this file"
	exit 1
fi

filepath=$1
writestr=$2

# % is for non-greedy suffix removal of a pattern
filedir=${filepath%/*}
mkdir -p $filedir

touch $filepath
echo $writestr > $filepath

exit 0