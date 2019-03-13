#!/bin/bash
Path=$1
Program=$2
Comp=0
Mem=0
Thr=0
if [[ -e $Path ]]; then
	cd $Path
	make > /dev/null
	if [[ $? -gt 0 ]]; then exit 7
	else
		valgrind --leak-check=full ./$Program 1> /dev/null 2> /dev/null
		if [[ $? -gt 0 ]]; then 
			valgrind --tool=helgrind ./$Program 1> /dev/null 2> /dev/null
			if [[ $? -gt 0 ]]; then exit 3
			else exit 2
			fi
		else
			valgrind --tool=helgrind ./$Program 1> /dev/null 2> /dev/null
			if [[ $? -gt 0 ]]; then exit 1
			else exit 0
			fi
		fi
	fi
fi
