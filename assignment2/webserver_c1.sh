#!/bin/bash/
N=$(echo "" | socat - tcp:10.0.3.12:8080)
DATA_PATH="/home/pi/serverData"
TABLE_PATH="$DATA_PATH/numbers.table"
mkdir $DATA_PATH &>/dev/null
TIME=$(date +"%H:%M:%S-%d/%m/%y-%Z")
TABLE_LINES=25


welcomeString()
{
        if [ -z "$SOCAT_PEERADDR" ]; then
		user=": $USER"
	else
		user=" with IP: $SOCAT_PEERADDR"
	fi
	welcome="Numbers fetched for user$user at $TIME"
	echo $welcome
}



getColor() {
	echo $(printf "%06s\n" $(echo "obase=16; $(($1*512))" | bc) | tr ' ' '0')
}

makeTableCell(){
	echo "<td align=$2 style="color:#$3">"
	echo "$1"
	echo "</td>"
}

tableFunc() {
	LINES=$(wc -l $TABLE_PATH | awk '{print $1}')
	TABLE="$(cat $TABLE_PATH)" 
	for i in `seq 1 $LINES`
	do
		ir=$(($LINES+1-$i))
		echo "<tr>"
		ROW=$(cat $TABLE_PATH | awk "NR == $ir")
		RNUMBER="$(echo $ROW | awk '{print $1}')"
		TIMETMP="$(echo $ROW | awk '{print $2}')"
		ADDR="$(echo $ROW | awk '{print $3}')"
		makeTableCell $i "center" 
		makeTableCell $RNUMBER "right" $(getColor $RNUMBER) 
		makeTableCell $ADDR "center" 
		makeTableCell $TIMETMP "center" 
		echo "</tr>"
	done
}

addLine() {	
	echo "$N $TIME $SOCAT_PEERADDR" | tee -a $TABLE_PATH &>/dev/null
	echo "$(tail -$TABLE_LINES $TABLE_PATH)" > $TABLE_PATH
}

makeHTML(){
	cat <<- _EOF_
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head >
	        	<title>"Random" Number Generator</title>
			<link rel="icon" href="https://www.makerlab-electronics.com/my_uploads/2018/08/raspberry-pi-icon.png">
			<meta content="da" http-equiv="Content-Language" />
			<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
		</head>
		<body style="background-color:#DDDDDD">
			<div style="margin-left:auto; margin-right:auto">
				<p align="center" style="margin-bottom:0">Your random number is:</p></marquee>
				<h1 align="center" style="margin-top:0; margin-bottom:3px; color:#$(getColor $N)">$N</h1>
				
				<table border="1" style="border-collapse: collapse; margin-left:auto; margin-right:auto">
					<tr>
						<th>
							Nr.
						</th>
						<th>
							Value:
						</th>
						<th>
							Fetch for user at:
						</th>
						<th>
							Time of Generation:
						</th>
					</tr>
					$(tableFunc)
				</table>
				<marquee><p>$(welcomeString)</p><marquee>
			</div>
		</body>
	</html>
	_EOF_
}


echo "$(makeHTML)"
$(addLine)
#echo $(makeWebsite)
