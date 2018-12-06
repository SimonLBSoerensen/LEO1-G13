#!/bin/sh
re='^[0-9]+$'
if [[ $1 -eq $re ]] 2>/dev/null
then
	echo "is a number"
else
	echo "NaN"
fi
