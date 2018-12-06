#!/bin/bash/
socat tcp-listen:8080,fork,reuseaddr exec:"sh /home/pi/randomizerScript.sh"
