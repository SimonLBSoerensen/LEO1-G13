# LEO1-G13

See the folder [/assignment2/](/assignment2/) for the scripts used to solve this assignment.

| Container        | Distribution | Version  | Purpose |
|:-------------:|:-------------:|:-----:|:---:|
| c1     | Alpine | 3.4 | Runs the webserver |
| c2      | Alpine      |  edge | Supplies random numbers|

<p align="center">![Replacement Text](https://github.com/SimonLBSoerensen/LEO1-G13/blob/master/WebsiteImage.png "Screenshot of website in action") </p>

----------------
[pi_crontab](/assignment2/pi_crontab)
----------------
This script executes  whenever the pi is rebooted.

------------------
[pi_startC.sh](/assignment2/pi_startC.sh)
------------------
This script starts the two containers, waits for them to get an ip address, finds the ip address of container 1 and routes any 
port 80 (http) communication to container 1.

Relevant functions:
- sudo -H -u pi bash -c: This is to execute a command as the user 'pi'.
- iptables: Used to route the communication through port 80 to the container.

------------------------
[autostartserver_c1](/assignment2/autostartserver_c1)
------------------------
This script is used to start an OpenRC service that calls startserver_c1.sh on container 1 boot.

-----------------------
[startserver_c1.sh](/assignment2/startserver_c1.sh)
-----------------------
This script starts the webserver in the container c1. The webserver is just a socat tcp server listening on port 80. 
Whenever the server is polled, it executes the webserver_c1.sh script. The option pktinfo is used to store the ip-address of
clients connecting to the server.

Relevant functions:
- socat: The webserver used.

---------------------
[webserver_c1.sh](/assignment2/webserver_c1.sh)
---------------------
This script generates the html code of the site. It polls container 2 for a random number and saves it as a variable. 
Then the data to be displayed is collected. The html code is created by calling the makeHTML function, while the
numbers table is maintained with the addLine function.

The script contains the following functions:

welcomeString()
  This function generates the string displayed at the bottom of the website, displaying the ip-address of the user.
  
getColor()
  This functions translates a number into a hexadecimal RGB color, used to set the color, the nuber is displayed in.
  
makeTableCell()
  This function takes three arguments: the cell data, the alignment of the text in the cell and the color of the text in the cell.
  It outputs the relevant html code for displaying the cell.
 
tableFunc()
  This function creates the table containing earlier numbers, dates/times and ip-addresses. The data is stored in a seperate file, which
  is accessed and edited in this script.
  
addLine()
  This function adds a line to the table file used in tableFunc. It also makes sure that the amount of lines in the file stays under a certain limit.
  
makeHTML()
  This function creates the HTML code for the website using the other functions listed.

Relevant functions
- socat: To maintain the html server and to poll container 2 for a random number.
- date: To get the date/time of the number generation.
- printf: To zero-pad the hex numbers for text color.
- bc: To translate decimal numbers to hexadecimal.
- tr: To replace blank spaces with 0.
- wc: To count the lines of the numbers table.
- awk: To select the correct element in a row in the numbers table.

----------------------------
[startserver_c2_crontab](/assignment2/startserver_c2_crontab)
----------------------------
Whenever container 2 reboots, this aautomatically starts the server by executing the script startserver_c2.sh.

-----------------------
[startserver_c2.sh](/assignment2/startserver_c2.sh)
-----------------------
This script runs a tcp server on port 8080 which replies with a random number when polled by executing the script randomizer_c2.sh.

Relevant functions:
- socat: To maintain a tcp server to transfer a random number.

----------------------
[randomizer_c2.sh](/assignment2/randomizer_c2.sh)
----------------------
This scripts echoes a random number using the $RANDOM function.
