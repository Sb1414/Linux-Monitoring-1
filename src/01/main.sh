#!/bin/bash

if [ $# != 1 ]
then
echo "n/a"
elif [[ $1 =~ [0-9] ]]
then
echo "n/a"
elif [[ $1 =~ [./,+-/%/^] ]]
then
echo "n/a"
else
echo $1
fi