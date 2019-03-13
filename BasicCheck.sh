#!/bin/bash
Path=$1
Program=$2
Comp=0
Mem=0
Thr=0
if [[ -e $Path ]]; then
	cd $Path
	make 1> /dev/null 2> /dev/null
	if [[ $? -gt 0 ]]; then 
		Comp=1       
	else
		valgrind --error-exitcode=1 --leak-check=full ./$Program 1> /dev/null 2> /dev/null
		if [[ $? -gt 0 ]]; then
			Mem=1	
			valgrind --error-exitcode=1 --tool=helgrind ./$Program 1> /dev/null 2> /dev/null
			if [[ $? -gt 0 ]]; then
				Thr=1	
			fi
		else
			valgrind --error-exitcode=1 --tool=helgrind ./$Program 1> /dev/null 2> /dev/null
			if [[ $? -gt 0 ]]; then
				Thr=1	
			if
		fi
	fi
	echo "Compilation     Memory leak     Thread race"
	echo "   $Comp		 $Mem		 $Thr"
if [[ $Comp == 1 ]];then exit 7 fi
if [[ $Mem == 1 ]];then
	if [[ $Thr == 1 ]];then exit 3 
	else exit 2
	fi
fi
if [[ $Thr == 1 ]];then exit 1
else exit 0
fi
fi
