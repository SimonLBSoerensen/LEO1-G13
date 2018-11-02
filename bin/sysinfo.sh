#!/bin/bash

##### Constants
PAGE_TITLE="System information for $HOSTNAME"
TIME=$(date +"%H:%M:%S %d/%m/%y %Z" ) 
SYSTEM_LOAD_AVERAGE=$(cat /proc/loadavg)
VERSION=2.2
##### Functions

welcome_string()
{
	if [ -z "$REMOTE_ADDR" ]; then
		user=": $USER"
	else
		user=" with IP: $REMOTE_ADDR"
	fi
	velcome="Information fetch for user$user at $TIME"
	echo $velcome	
}

system_uptime()
{
	string=$(uptime -p)
	echo ${string:3}
}

system_load_average1min()
{
	load=$(echo $SYSTEM_LOAD_AVERAGE | awk '{print $1}')
	echo $load
}
system_load_average5min()
{
	load=$(echo $SYSTEM_LOAD_AVERAGE | awk '{print $2}')
	echo $load
}
system_load_average15min()
{
	load=$(echo $SYSTEM_LOAD_AVERAGE | awk '{print $3}')
	echo $load
}

currently_users()
{
	wRun=$(w)
	nLines=$(echo "$wRun" | wc -l)
	wRun=$(echo "$wRun" | tail -n $(($nLines - 1)))
	echo "$wRun"
}

free_ram()
{
	freeRam=$(free -m | awk 'NR == 2 {print $4}')
	totalRam=$(free -m | awk 'NR == 2 {print $2}')
	echo "$freeRam MB out of $totalRam MB" 
}

disk_use()
{
	diskUse=$(df -h | awk 'NR == 2 {print $3}')
	totalDisk=$(df -h | awk 'NR == 2 {print $2}')
	echo "$diskUse out of $totalDisk"
}

running_processes()
{
	topRun=$(top -bn 1)
	nLines=$(echo "$topRun" | wc -l)
	topRun=$(echo "$topRun" | tail -n $(($nLines - 6)))
	echo "$topRun"
}

cpu_use()
{
	echo "$(mpstat | tail -n 2)"
}

#Plain TODO Chek if plain is good 
make_plain()
{
	echo "$PAGE_TITLE"

	echo "$(welcome_string)"
	
	echo "System uptime: $(system_uptime)"
	
	echo "CPU use:"
	echo "$(cpu_use)"
	
	echo "System load average:"
	echo "1 min : $(system_load_average1min), 5 min : $(system_load_average5min), 15 min : $(system_load_average1min)" 
	echo "Free RAM: $(free_ram)"
	echo "Disk use: $(disk_use)"
	
	echo "Current useres on system:"
	echo "$(currently_users)"
	
	echo "Current running processes:"
	echo "$(running_processes)"
}

#HTML
make_html()
{
	cat <<- _EOF_
	   <html>
	   <head>
	   	<title>$PAGE_TITLE</title>
	   </head>
	
	   <body>
	   	<h1 style="text-align: center;">$PAGE_TITLE</h1>
		<h6 style="text-align: center;">$(welcome_string)</h6>
		
		<p style="text-align: center;">Basic system information:</p>

		<table border="1" style="border-collapse: collapse; margin-left: auto; margin-right:auto;">
		<tbody>
			<tr>
				<td style="text-align: right;">System uptime:</td>
				<td>$(system_uptime)</td>
			</tr>
			<tr>
				<td style="text-align: right;">Free RAM:</td>
				<td>$(free_ram)</td>
			</tr>
			<tr>
				<td style="text-align: right;">Disk use:</td>
				<td>$(disk_use)</td>
			</tr>
		</tbody>
		</table>
		
		<p style="text-align: center;">CPU use:</p>
		<div style="text-align: center;">
			<pre style="display: inline-block; text-align: left;">
				$(cpu_use)
			</pre>	
		</div>

		<p style="text-align: center;">Load average:</p>
		<table border="1" style="border-collapse: collapse; margin-left: auto; margin-right:auto;">
		<tbody>
			<tr>
				<td style="text-align: center;">1 min</td>
				<td style="text-align: center;">5 min</td>
				<td style="text-align: center;">15 min</td>
			</tr>
			<tr>
				<td style="text-align: center;">$(system_load_average1min)</td>
				<td style="text-align: center;">$(system_load_average5min)</td>
				<td style="text-align: center;">$(system_load_average15min)</td>
			</tr>
		</tbody>
		</table>

		<p style="text-align: center;">Users on system:</p>
		<div style="text-align: center;">
			<pre style="display: inline-block; text-align: left;">
				$(currently_users)
			</pre>	
		</div>
	
		<p style="text-align: center;">Processes running on system:</p>
		<div style="text-align: center;">
			<pre style="display: inline-block; text-align: left;">
				$(running_processes)
			</pre>
		</div>
		<pre style="text-align: center;">sysinfo.sh v$VERSION</pre>
	   </body>
	   </html>
	_EOF_
}

make_help()
{
	cat <<- _EOF_
	sysinfo: sysinfo [-p]
	 	Print system information about the system
	
	 	Options:
	 		-p	print the system information in plain ASCCI, suitable for terminal
		
	 	By default, 'sysinfo' print the system information in HTML format.
		
	 	Exit Status:
	 	Returns 0 unless an invalid option is given

	 	Script verison: v$VERSION
	_EOF_
}
make_sys_usage(){
	echo "sysinfo usage: $(basename $0) [-p]"
}
##### Main
while getopts 'ph-:' OPTION; do
	case "$OPTION" in
		p)
			echo "$(make_plain)"
			;;
		h)
			echo "$(make_help)"
			;;
		-)
			if [ $OPTARG = "help" ]; then
				echo "$(make_help)"
			elif [ $OPTARG = "plain" ]; then
				echo "$(make_plain)"
			else
				echo "$(make_sys_usage)"
				exit 1
			fi
			;;
		?)
			echo "$(make_sys_usage)"
			exit 1
			;;
	esac		
done
if [ $OPTIND -eq 1 ]; then
	echo "$(make_html)"
fi
