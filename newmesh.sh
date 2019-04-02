#!/bin/bash
#Generate a mesh folder with the getmesh.sh file

n=1;
max=10;
while [ -d "$(pwd)/mesh"$n"" ]
do
	n=`expr "$n" + 1`;
done
if [ "$n" -gt "$max"  ]
        then
                echo "Too many mesh directories. New one cannot be created."
        else
                echo "creating folder  mesh"$n"."
                mkdir mesh"$n"
                cp $(pwd)/getmesh.sh $(pwd)/mesh"$n"
        fi

cd ./mesh"$n"

bash ../resgen.sh
