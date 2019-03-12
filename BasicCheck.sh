#!/bin/bash
Path=$1
Program=$2
compilation="PASS"
Memory="PASS"
thread="PASS"
if [[ -e $Path ]]; then 
	cd $Path 
	make > /dev/null
	if [[ $? -gt 0 ]]; then
		compilation="FAIL"
	else
		valgrind --leak-check=full -v ./$Program 1> /dev/null 2> /dev/null 
		if [[ $? -gt 0 ]]; then
			Memory="FAIL"
			valgrind --tool=helgrind ./$Program 1> /dev/null 2> /dev/null
			CHECK=$?
		fi
		if [[ $CHECK -gt 0 ]]; then 
			thrtead="FAIl"
		else
			valgrind --tool=helgrind ./$Program 1> /dev/null 2> /dev/null
			if [[ $? -gt 0 ]]; then
				thread="FAIL"
			fi
		fi
	fi
        echo "Compilation        Memory leaks            thread race"
        echo "   $compilation                $Memory                    $thread"
        if [[ "$compilation" = "PASS" && "$Memory" = "PASS" && "$thread" = "PASS" ]]; then
   		exit 0
        elif [[ "$compilation" = "PASS" && "$Memory" = "FAIL" && "$thread" = "PASS" ]]; then
       		exit 2
        elif [[ "$compilation" = "PASS" && "$Memory" = "PASS" && "$thread" = "FAIL" ]]; then
                exit 1
        elif [[ "$compilation" = "PASS" && "$Memory" = "FAIL" && "$thread" = "FAIL" ]]; then
                exit 3
        else
                exit 7
	fi

else
	echo path not exists
	exit 7
fi
