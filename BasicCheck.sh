#!/bin/bash
Path=$1
Program=$2
if [[ -e $Path ]]; then
	cd $Path
	make 1> /dev/null 2> /dev/null
	if [[ $? -gt 0 ]]; then 
		echo 7       
		exit 7
	else
		valgrind --leak-check=full $Program 1> /dev/null 2> /dev/null
		if [[ $? -gt 0 ]]; then 
			valgrind --tool=helgrind $Program 1> /dev/null 2> /dev/null
			if [[ $? -gt 0 ]]; then
				echo 3       
				exit 3
			else
				echo 2       
				exit 2
			fi
		else
			valgrind --tool=helgrind $Program 1> /dev/null 2> /dev/null
			if [[ $? -gt 0 ]]; then
				echo 1	
				exit 1
			else 
				echo 0
				exit 0
			fi
		fi
	fi
fi
