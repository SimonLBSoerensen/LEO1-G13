#!/bin/bash
if [ -z "$BLINKING" ]; then
	BLINKING=0
fi
if [ -z "$DEBUG" ]; then
	DEBUG=0
fi
if [ -z "$ON" ]; then
	ON=1
fi
if [ -z "$OFF" ]; then
	OFF=1
fi

while getopts 'bO:o:d' OPTION; do
	case "$OPTION" in
		b)
			BLINKING=1
			;;
		O)
			if ! [[ "$OPTARG" =~ ^[0-9]+$ ]]; then
				echo "On time can only be integer, not: $OPTARG"
				exit 1
			fi
			ON=$OPTARG
			;;
		o)
			if ! [[ "$OPTARG" =~ ^[0-9]+$ ]]; then
				echo "Off time can only be integer, not: $OPTARG"
				exit 1
			fi
			OFF=$OPTARG
			;;
		d)
			DEBUG=1
			;;
		?)
			echo "error $OPTION"
			;;
	esac
done
if [ $DEBUG -eq 1 ]; then
	echo "Blinking is: $BLINKING"
	echo "On time is: $ON"
	echo "Off time is: $OFF"
fi
if [ $BLINKING -eq 1 ]; then
	sudo echo 0 | tee /sys/class/leds/led0/brightness > /dev/null
	while true; do
		sleep $ON
		sudo echo $(( $(cat /sys/class/leds/led0/brightness) == 0 )) | tee /sys/class/leds/led0/brightness > /dev/null
		sleep $OFF
        	sudo echo $(( $(cat /sys/class/leds/led0/brightness) == 0 )) | tee /sys/class/leds/led0/brightness > /dev/null
	done
else
	sudo echo $(( $(cat /sys/class/leds/led0/brightness) == 0 )) | tee /sys/class/leds/led0/brightness > /dev/null
fi
