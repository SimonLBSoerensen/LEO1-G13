#!/bin/sh
socat tcp-listen:80,fork,pktinfo,reuseaddr exec:"sh /home/pi/webServer.sh"
