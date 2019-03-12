#!/bin/bash
Path=$1
Program=$2
compilation="PASS"
Memory="PASS"
thread="PASS"
if [[ -e $Path ]]; then 
	cd $Path
	if [[ -e $Program ]]; then
		make > /dev/null
		if [[ $? -gt 0 ]]; then
			compilation="FAIL"
		else
			valgrind --leak-check=full -v ./$Program 2>$1 Mermoryleak.txt 
			if [[ $? -gt 0 ]]; then
				Memory="FAIL"
				valgrind --tool=helgrind ./$Program 2>$1 ThreadRace.txt
				if [[ $? -gt 0 ]];then 
					thrtead="FAIl"
				fi
			else
				valgrind --tool=helgrind ./$Program 2>$1 ThreadRace.txt
				if [[ $? -gt 0 ]]; then
					thread="FAIL"
				fi
			fi
		fi
		                echo "Compilation        Memory leaks            thread race"
                echo "  $compilation           $Memory              $thread"
                if [[ "$compilation" = "PASS" && "$Mamory" = "PASS" && "$thread" = "PASS" ]];then
                        exit 0
                elif [[ "$compilation" = "PASS" && "$Memory" = "FAIL" && "$thread" = "PASS" ]];then
                        exit 5
                elif [[ "$compilation" = "PASS" && "$Memory" = "PASS" && "$thread" = "FAIL" ]];then
                        exit 6
                elif [[ "$compilation" = "PASS" && "$Memory" = "FAIL" && "$thread" = "FAIL" ]];then
                        exit 4
                else
                        exit 7
		fi

	else
		echo program not exists
	fi
else
	echo path not exists
	exit 7

fi
exit 0
