#!/bin/bash/
VAL=$(echo '' | socat - tcp:10.0.3.12:8080)
echo $VAL
