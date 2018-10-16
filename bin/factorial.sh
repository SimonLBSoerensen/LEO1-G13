#!/bin/bash
if [ -z "$1" ]; then
	echo "No number given"
	exit 1
elif [ "$1" -eq 0 ]; then
	echo 1
else
	echo $(( $1 * $(factorial.sh $(( $1 - 1 )))))
fi
