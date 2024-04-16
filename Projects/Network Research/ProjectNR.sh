#! /bin/bash

echo 'Student name: Michelle Lai'
echo 'Student code: S23'
echo 'Class code: CFC020823'
echo 'Lecturer name: Tushar'
echo ' '


#1. Installations and Anonymity Check
	#1.1 Install the needed applications
	#1.2 If the applications are already installed, don’t install them again
function NIPE()	
{
	if [ -x /home ];
	then
		echo "nipe is already installed."
	else
		echo "nipe is not installed."
		cd ~/Desktop
		sudo apt-get update
		git clone https://github.com/htrgouvea/nipe && cd nipe
		sudo cpanm install
		sudo cpanm --installdeps ~/Desktop
		sudo perl nipe.pl install
	fi
	}

function SSHPASS()	
{
	if command -v sshpass >/dev/null;
	then
		echo "sshpass is already installed."
	else
		echo "sshpass is not installed."
		sudo apt-get update
		sudo apt install sshpass
	fi
	}

function TORIFY()	
{
	if command -v torify >/dev/null;
	then
		echo "tor is already installed."
	else
		echo "tor is not installed."
		sudo apt-get update
		sudo apt-get install tor
	fi
	}
function NMAP()	
{
	if command -v nmap >/dev/null;
	then
		echo "nmap is already installed."
	else
		echo "nmap is not installed."
		sudo apt-get update
		sudo apt install nmap
	fi
	}
function WHOIS()	
{
	if command -v whois >/dev/null;
	then
		echo "whois is already installed."
	else
		echo "whois is not installed."
		sudo apt-get update
		sudo apt install whois
	fi
	}

function GEOIP()	
{
	if command -v geoiplookup >/dev/null;
	then
		echo "geoip is already installed."
	else
		echo "geoip is not installed."
		sudo apt-get update
		sudo apt-get install geoip-bin
	fi
	}
	
NIPE
SSHPASS
TORIFY
NMAP
WHOIS
GEOIP

#make a directory to keep whois and nmap data in the local computer
mkdir ~/Desktop/Data
#run ssh in the local computer to download whois and nmap data from remote server
sudo service ssh start

#cd to nipe folder for nipe to run
cd ~/Desktop/nipe

#start nipe
sudo perl nipe.pl restart

function detail()	
{
	#1.5 Allow the user to specify the address to scan via remote server; save into a variable
	echo "Specify a Domain/IP address to scan: "
	read DOMAIN

	#2. Automatically Connect and Execute Commands on the Remote Server via SSH
	#2.1 Display the details of the remote server (Country, IP, and Uptime)
	UPT=$(uptime)
	echo "Remote Server Uptime: $UPT"
	Public_IP=$(curl -s ifconfig.io)
	echo "Remote Server IP address: $Public_IP" 
	Ctry=$(geoiplookup $Public_IP | awk '{print$5}')
	echo "Remote Server Country: $Ctry"

	#2.2 Get the remote server to check the Whois of the given address
	whois $DOMAIN >> /home/kali/Desktop/whois_$DOMAIN.txt

	#2.3 Get the remote server to scan for open ports on the given address
	nmap $DOMAIN -oN /home/kali/Desktop/nmap_$DOMAIN.txt

	#3. Results
	#3.1 Save the Whois and Nmap data into files on the local computer
	sshpass -p "kali" scp /home/kali/Desktop/whois_$DOMAIN.txt 192.168.254.129:/home/kali/Desktop/Data
	echo "Whois data was saved into /home/kali/Desktop/Data/whois_$DOMAIN.txt"
	sshpass -p "kali" scp /home/kali/Desktop/nmap_$DOMAIN.txt 192.168.254.129:/home/kali/Desktop/Data
	echo "Nmap scan was saved into /home/kali/Desktop/Data/nmap_$DOMAIN.txt"
	
	#3.2 Create a log and audit your data collection
	DATE=$(date)
	echo "$DATE Nmap data collected for: $DOMAIN" >> /home/kali/Desktop/nr.log
	echo "$DATE whois data collected for: $DOMAIN" >> /home/kali/Desktop/nr.log
	sshpass -p "kali" scp /home/kali/Desktop/nr.log 192.168.254.129:/home/kali/Desktop/Data
	echo "Data log for Nmap and whois is created in /home/kali/Desktop/nr.log"
		}
		

#1.3 Check if the network connection is anonymous; if not, alert the user and exit
status=$(sudo perl nipe.pl status| grep -i status | awk '{print$3}')
if $status == true;
then 
	echo "You are anonymous."
		#1.4 If the network connection is anonymous, display the spoofed country name
		Ipx=$(sudo perl nipe.pl status| grep -i ip | awk '{print$3}')
		Country=$(geoiplookup $Ipx | awk '{print$5$6}')
		echo "Your Spoofed IP Address is $Ipx"
		echo "Spoofed Country is $Country."
			echo "Connecting to Remote Server..."
			sshpass -p 'kali' ssh kali@192.168.254.130 "$(declare -f detail);detail" 

else
	echo "You are not anonymous."

fi



