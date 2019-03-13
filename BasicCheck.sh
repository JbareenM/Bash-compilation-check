#!/bin/bash

CURRDIR=$1            #the given directory.
PROGRAM=$2            #the given program.
MEMCHECK=0
THREADRACE=0
COMPILATION=0

cd $1

make

if [ $? != 0 ]; then       #if the compilation failed or there is no makefile. 
COMPILATION=1
MEMCHECK=1
THREADRACE=1
fi

if [ $COMPILATION == 0 ]; then          #if the compilation succeed, checks for memory leaked.
	valgrind --error-exitcode=1 --leak-check=full ./$PROGRAM

	if [ $? != 0 ]; then MEMCHECK=1       #if there is a memory leaked.
	fi

	valgrind --error-exitcode=1 --tool=helgrind ./$PROGRAM       #run thread race test.

	if [ $? != 0 ]; then THREADRACE=1     #if there is a thread race problem.
	fi
fi

echo ""
echo ""
echo ""

echo "COMPILATION       MEMORY LEAKS       THREAD RACE"
echo "    $COMPILATION                  $MEMCHECK                  $THREADRACE"     


if [ $COMPILATION -eq 1 ]; then exit 7
fi

if [ $COMPILATION -eq 0 ]; then 
	if [ $MEMCHECK -eq 1 ]; then
		if [ $THREADRACE -eq 1 ]; then exit 3
		else exit 2
		fi
	else
		if [ $THREADRACE -eq 1 ]; then exit 1
		else exit 0
		fi
	fi
fi


