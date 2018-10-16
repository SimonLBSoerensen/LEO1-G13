#!/bin/bash
if [[ -p /dev/stdin ]]; then
	#stdin is from pipe
	echo pipe
fi
if [[ -t 0 ]]; then
	#stdin is from terminal
	echo "Write number to seq"
	read number
	seq $number
fi
