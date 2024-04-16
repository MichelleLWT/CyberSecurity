#!/usr/bin/python3

print('Student name: Michelle Lai')
print('Student code: S23')
print('Class code: CFC020823')
print('Lecturer name: James')

#import all the necessary modules required
import os
import platform					
import netifaces as ni			#ni is used as an alias to call out the module:netifaces
import public_ip as ip      	#require to install public-ip in linux interface (pip install public-ip)
import shutil
import psutil
import time


print(' ')
# 1.Display the OS version
print('1.Display the OS version.')
print('OS Version:' ,platform.platform())

print(' ')
# 2.Display the private IP address, public IP address, and the default gateway.
print('2.Display the private IP address, public IP address, and the default gateway.')
privateip = ni.ifaddresses('eth0')[ni.AF_INET][0]['addr']   
print('Private IP Address:',privateip)

print('Public IP Address:',ip.get())

print('Default Gateway:' , ni.gateways()[ni.AF_INET][0][0])

print(' ')
# 3.Display the hard disk size; free and used space. 
print('3.Display the hard disk size; free and used space.')
total, used, free = shutil.disk_usage("/")   #indicates the path for disk usage statistics

# print the disk usage statistics
print('Total:', total/(10**9), 'GB')
print('Used:', used/(10**9), 'GB')
print('Free:', free/(10**9) ,'GB')

print(' ')
# 4.Display the top five (5) directories and their size. 
print('4.Display the top five (5) directories and their size.')

# list files in the current working directory
files = (os.listdir(os.getcwd()))		

# list files in the current working directory and sorted by size (largest to smallest)
files.sort(key=lambda f: os.stat(f).st_size, reverse=True)	

# list the largest 5 directories/files
top5=files[:5] 

#names and print the largest 5 directories/files along with their size
for name_of_file in top5: 
    path_of_file = os.path.join(os.getcwd(), name_of_file) 
    size_of_file  = os.stat(path_of_file).st_size
    print(size_of_file,'bytes -->', name_of_file) 
    
print(' ')
# 5.Display the CPU usage; refresh every 10 seconds.
print('5.Display the CPU usage; refresh every 10 seconds.')
while True:
	print('CPU utilization:',psutil.cpu_percent(1),'%')
	time.sleep(10)
