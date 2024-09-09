#!/bin/bash

if [ ! $# -eq 2 ]
then
	echo "2 arguments are required."
	echo "1st Argument: Path to directory to search"
	echo "2nd Argument: String to search for within files located at the specified directory."
	exit 1
fi

filesdir=$1
searchstr=$2

if [ ! -d $filesdir ]
then
	echo "Specified directory does not exist"
	exit 1
fi

# The <(<commmand>) syntax below is called "process substitution". The output of <command>
# is associated with a file descriptor or some other type of named file. It provides a way
# to pass the output of a command to another command when using a pipe is not possible. For
# example, the readarray command below does not take from standard input, so we have to use
# this to make the output of the grep command available to readarray.
# < is for redirecting input
# > is for redirecting output
readarray -t grep_output < <(grep -c $searchstr $filesdir/* 2> /dev/null)

matching_files=0
matching_lines=0

arraylength="${#grep_output[@]}"

for (( i=0; i<${arraylength}; i++ ));
do
	readarray -t -d ':' filestats < <(echo ${grep_output[$i]})
	filename=${filestats[0]}
	matchcount=${filestats[1]}
	if [ $matchcount -gt 0 ]
	then
		((matching_files=$matching_files+1))
		((matching_lines=$matching_lines+$matchcount))
	fi
done

echo "The number of files are $matching_files and the number of matching lines are $matching_lines"

exit 0
