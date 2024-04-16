#! /bin/bash

echo 'Student name: Michelle Lai'
echo 'Student code: S23'
echo 'Class code: CFC020823'
echo 'Lecturer name: Kar Wei'
echo ' '


#1. Getting the User Input
	#1.1 Get from the user a network to scan.
	echo "Stage 1: Getting a network from user to scan..."
	echo "Specify a IP address to scan: "   #user to input an ip address
	read ipx 
	
	if [[ $ipx =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; #checks for ip address validation (#1.4 Make sure the input is valid.)
	then
			#if ip address is valid, user to input a name for the output directory
			#1.2 Get from the user a name for the output directory.
			echo "Provide a name for the ouput directory: "   #user to input a name for the output directory
			read directory 
			mkdir ./$directory 					#make a directory where the files will be saved
			echo "$directory has been created."
								
function scanning()
{		
					echo "Stage 2: Checking for open ports in the network"		#4.1 During each stage, display the stage in the terminal.
					echo "Scanning for TCP open ports..."			#Infrom user that TCP scan has started
					sudo nmap $ipx -p- -sV -oX tcpscan_$ipx.txt					#TCP Scan on the network and save it into a xml file
					xsltproc tcpscan_$ipx.txt -o tcpscan_$ipx				#Convert xml file to html file for easy reading
					echo "Scanning for UDP open ports..."			#Infrom user that UDP scan has started
					sudo masscan $ipx -pU:1-65535 --banners --rate 1000 -oL udpscan_$ipx.txt 	#UDP Scan on the network and save it into a txt file
					mv tcpscan_$ipx udpscan_$ipx.txt ./$directory 		#Move the output files into the directory the user created	
					echo "Scan Results for both TCP (tcpscan_$ipx) and UDP (udpscan_$ipx.txt) have been saved in $directory."	#Inform user where the scan results have been saved.
	}
	
function wkpasswd()
{
	#2.1 Look for weak passwords used in the network for login services.(#2.2 Login services to check include: SSH, RDP, FTP, and TELNET.)
					echo "Stage 3: Checking for Weak Passwords in the network"		#4.1 During each stage, display the stage in the terminal.
					echo " How does user wants to check for weak passwords in the network? 
						   A) Username list provided by user and Inbuilt Password list
						   B) Username list and Password list provided by user
						   C) Username provided by user and Inbuilt Password list
						   D) Username and Password list provided by user"		#Check what username or usernamelist or passwordlist user wants to use
					read ANSWERS
					case $ANSWERS in
					
						A|a)  #Username list provided by user and Inbuilt Password list (#2.1.1 Have a built-in password.lst to check for weak passwords.)
						echo "State the username list you wan to check: "	 #user to input an username list to check
						read usernamelist
						echo "Scanning for weak passwords on telnet service..."	
						medusa -h $ipx -U $usernamelist -P builtin100.txt -M telnet -t 10 -O passwordfound.txt  	#scan for weak passwords on telnet service
						echo "Scanning for weak passwords on ftp service..."	
						medusa -h $ipx -U $usernamelist -P builtin100.txt -M ftp -t 10 -O passwordfound.txt			#scan for weak passwords on ftp service
						echo "Scanning for weak passwords on ssh service..."	
						medusa -h $ipx -U $usernamelist -P builtin100.txt -M ssh -t 10 -O passwordfound.txt			#scan for weak passwords on ssh service
						echo "Scanning for weak passwords on rdp service..."	
						hydra -L $usernamelist -P builtin100.txt -F rdp://$ipx -V -o passwordfound.txt				#scan for weak passwords on rdp service
						mv passwordfound.txt ./$directory
						echo "Results and Logs for weak passwords (passwordfound.txt) has been saved in $directory."	#Inform user where the results have been saved.
					;;
			
						B|b) #Username list and Password list provided by User
						echo "State the username list you wan to check: "	 #user to input an username list to check
						read usernamelist
						echo "State the password list you wan to use: "   #user to input a password list to use (#2.1.2 Allow the user to supply their own password list.)
						read pwlist
						echo "Scanning for weak passwords on telnet service..."	
						medusa -h $ipx -U $usernamelist -P $pwlist -M telnet -t 10 -O passwordfound.txt		#scan for weak passwords on telnet service
						echo "Scanning for weak passwords on ftp service..."
						medusa -h $ipx -U $usernamelist -P $pwlist -M ftp -t 10 -O passwordfound.txt		#scan for weak passwords on ftp service
						echo "Scanning for weak passwords on ssh service..."
						medusa -h $ipx -U $usernamelist -P $pwlist -M ssh -t 10 -O passwordfound.txt		#scan for weak passwords on ssh service
						echo "Scanning for weak passwords on rdp service..."
						hydra -L $usernamelist -P $pwlist -F rdp://$ipx -V -o passwordfound.txt				#scan for weak passwords on rdp service
						mv passwordfound.txt ./$directory
						echo "Results and Logs for weak passwords (passwordfound.txt) has been saved in $directory."	#Inform user where the results have been saved.
					;;
				
						C|c) #Username provided by user and Inbuilt Password list (#2.1.1 Have a built-in password.lst to check for weak passwords.)
						echo "State the username you wan to check: "  #user to input an username
						read username
						echo "Scanning for weak passwords on telnet service..."
						medusa -h $ipx -u $username -P builtin100.txt -M telnet -t 10 -O passwordfound.txt		#scan for weak passwords on telnet service
						echo "Scanning for weak passwords on ftp service..."
						medusa -h $ipx -u $username -P builtin100.txt -M ftp -t 10 -O passwordfound.txt			#scan for weak passwords on ftp service
						echo "Scanning for weak passwords on ssh service..."
						medusa -h $ipx -u $username -P builtin100.txt -M ssh -t 10 -O passwordfound.txt			#scan for weak passwords on ssh service
						echo "Scanning for weak passwords on rdp service..."
						hydra -l $username -P builtin100.txt -F rdp://$ipx -V -o passwordfound.txt				#scan for weak passwords on rdp service
						mv passwordfound.txt ./$directory
						echo "Results and Logs for weak passwords (passwordfound.txt) has been saved in $directory."	#Inform user where the results have been saved.
					;;
				
						D|d) #Username and Password list provided by user
						echo "State the username you wan to check: " 	#user to input an username
						read username
						echo "State the password list you wan to use: "   #user to input a password list to use (#2.1.2 Allow the user to supply their own password list.)
						read pwlist
						echo "Scanning for weak passwords on telnet service..."
						medusa -h $ipx -u $username -P $pwlist -M telnet -t 10 -O passwordfound.txt		#scan for weak passwords on telnet service
						echo "Scanning for weak passwords on ftp service..."
						medusa -h $ipx -u $username -P $pwlist -M ftp -t 10 -O passwordfound.txt		#scan for weak passwords on ftp service
						echo "Scanning for weak passwords on ssh service..."
						medusa -h $ipx -u $username -P $pwlist -M ssh -t 10 -O passwordfound.txt		#scan for weak passwords on ssh service
						echo "Scanning for weak passwords on rdp service..."
						hydra -l $username -P $pwlist -F rdp://$ipx -V -o passwordfound.txt				#scan for weak passwords on rdp service
						mv passwordfound.txt ./$directory
						echo "Results and Logs for weak passwords (passwordfound.txt) has been saved in $directory."	#Inform user where the results have been saved.
					;;
					esac
	}

function vuln()
{		
	#3. Mapping Vulnerabilities
					#3.1 Mapping vulnerabilities should only take place if Full was chosen.
					#3.2 Display potential vulnerabilities via NSE and Searchsploit.
					echo "Stage 4: Vulnerability Assessment on the server..."		#4.1 During each stage, display the stage in the terminal.
					echo "Checking for vulnerabilities on open services..."
					nmap --script vulners -sV $ipx	-oX vulnassess_$ipx.txt		#Check for CVEs based on open services and saved it into a xml file
					xsltproc vulnassess_$ipx.txt -o vulnassess_$ipx		#Convert xml file to html file for easy reading
					mv vulnassess_$ipx ./$directory
					echo "Results for vulnerabilities found (vulnassess_$ipx) has been saved in $directory."	#Inform user where the scan results have been saved.
					echo "Checking for exploits on found vulnerabilities..."
					searchsploit -x --nmap tcpscan_$ipx.txt > tcp_exploits_$ipx		#Check for exploits that user can try on vulnerabilities found.
					mv tcp_exploits_$ipx ./$directory
					echo "Results for exploits found (tcp_exploits_$ipx) has been saved in $directory." 			
	}

function zipping()
{	
	#4.4 Allow to save all results into a Zip file.
	echo "Does the user want to zip $directory, A)Yes or B)No? "
	read Ans

	case $Ans in
		A|a|Yes|yes|YES)
		echo "Zipping $directory"
		tar -cvzf $directory.tar.gz $directory		#zip the output file
		echo "$directory is now a zip file."
	;;

		B|b|No|NO|no)
		
	;;
	esac
	 
}

function searchandzip()
{	
	#4.3 Allow the user to search inside the results.
	while true
	do
		echo "Does the user want to search in the results, A)Yes or B)No? "
		read Ans

		case $Ans in
			A|a|Yes|yes|YES)
			echo "Please state the keyword you want to search for"
			read keyword
			grep -r $keyword ./$directory/* > search_$keyword.txt  #search for the keyword user want to find and save it into a txt file
			mv search_$keyword.txt ./$directory
			echo "Search Results for $keyword (search_$keyword.txt) has been saved in $directory."
		;;

			B|b|No|NO|no)
			echo "Quiting Search"
			zipping
			exit
		;;
		esac
	 done
}

			#1.3 Allow the user to choose 'Basic' or 'Full'.
			echo "Please choose the scan you want, A) Basic or B) Full: "	#user to choose the type of scan 
			read OPTIONS
			case $OPTIONS in
				A|a|Basic|basic)								#run the option Basic
					echo "Basic Scan has been chosen!"
					#1.3.1 Basic: scans the network for TCP and UDP, including the service version and weak passwords.
					scanning
					wkpasswd
					searchandzip
					
				;;
			
				B|b|Full|full)								#run the option Full
					echo "Full Scan has been chosen!"
					#1.3.2 Full: include Nmap Scripting Engine (NSE), weak passwords, and vulnerability analysis.
					scanning
					wkpasswd
					vuln
					searchandzip
									
				;;
			esac
	else
			#if ip address is invalid, user to input IP address again.
			echo "Invalid IP address!"		
	fi
	
	
	


