#!/bin/bash
#Generate a results folder with the fesom.clock file

if [ -d "$(pwd)/results" ]
then
	echo "results directory already exists."
	n=1;
	max=10;
	while [ -d "$(pwd)/results"$n"" ]
	do
		n=`expr "$n" + 1`;
	done
	if [ "$n" -gt "$max"  ]
	then
		echo "Too many results directories. New one cannot be created."
	else
		echo "renaming to results"$n"."
                mv $(pwd)/results $(pwd)/results_"$n"
		mkdir results
		cp $(pwd)/../fesom.clock $(pwd)/results
	fi
else
	echo "Creating results directory."
	mkdir $(pwd)/results
	cp $(pwd)/../fesom.clock $(pwd)/results
fi

cd $(pwd)/results/
mkdir newdata
mkdir plots
mkdir animations
