#!/bin/sh
socat tcp-listen:80,fork,reuseaddr exec:"sh /home/pi/webServer.sh"
