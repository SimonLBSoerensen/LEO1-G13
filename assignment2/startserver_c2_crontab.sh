# do daily/weekly/monthly maintenance
# min	hour	day	month	weekday	command
*/15	*	*	*	*	run-parts /etc/periodic/15min
0	*	*	*	*	run-parts /etc/periodic/hourly
0	2	*	*	*	run-parts /etc/periodic/daily
0	3	*	*	6	run-parts /etc/periodic/weekly
0	5	1	*	*	run-parts /etc/periodic/monthly
@reboot sh /home/pi/startRandomServer.sh
@reboot $(echo "log lavet $(date +"%H:%M:%S %d/%m/%y %Z" )" | tee /home/pi/log.log)
