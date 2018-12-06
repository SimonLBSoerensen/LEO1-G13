#!/bin/bash
echo $(date) | tee -a /home/pi/log_sudo_crontab.log
sudo -H -u pi bash -c 'lxc-start -n c1'
sleep 10
sudo -H -u pi bash -c 'lxc-start -n c2'
sleep 10
c1Ip=$(sudo -H -u pi bash -c 'lxc-ls -f | awk "NR == 2"')
c1Ip=$(echo $c1Ip | awk '{print $5}')
echo $c1Ip | tee -a /home/pi/log_sudo_crontab.log
sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j DNAT --to-destination $c1Ip:80 | tee -a /home/pi/log_sudo_crontab.log
           
