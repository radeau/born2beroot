#!bin/bash

## 1 Architecture of operating system and its kernel version.
## 2 Number of physical processors.
## 3 Number of virtual processors.
## 4 Current available RAM on server and its utilization rate as a percentage.
## 5 Current available memory on server and its utilization rate as a percentage.
## 6 Current utilization rate of processors as a percentage.
## 7 Date and time of the last reboot.
## 8 Shows whether LVM is active or not
## 9 Number of active connections.
## 10 Number of users using the server.
## 11 Shows IPv4 address of the server and its MAC (Media Access Control) address.
## 12 Number of commands executed with the sudo program

## Variables
FRAM=$(free -m | grep Mem: | awk '{print $2}')
URAM=$(free -m | grep Mem: | awk '{print $3}')
PCENTRAM=$(free -m | grep Mem: | awk '{printf(%.2f), $3/$2*100}')
FDISK=$(df -Bg | grep /dev/ | grep -v /boot | awk '{fdisk += $2} END {print fdisk}')
UDISK=$(df -Bg | grep /dev/ | grep -v /boot | awk '{udisk += $3} END {print udisk}')
PCENTDISK=$(df -Bg | grep /dev/ | grep -v /boot | awk '{fdisk += $2} {udisk += $3} END {print udisk/fdisk*100}')
CPU=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
LVM=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

TCP=$(netstat -an | grep ESTABLISHED | wc -l)
TCPMSG=$(if [ ${TCP} -eq 0 ]; then echo NOT ESTABLISHED; else echo ESTABLISHED; fi)
USERLOG=$(users | wc -w)
IP=$(hostname -I)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')
SUDO=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

echo "#Architecture: $(uname -a)" #1
echo "#CPU physical: $(grep -c 'physical id' /proc/cpuinfo)" #2
echo "#vCPU: $(grep -c 'processor' /proc/cpuinfo)" #3
echo "#Memory Usage: ${URAM}/${FRAM}MB (${PCENTRAM})%" #4
echo "#Disk Usage: ${UDISK}/${FDISK}Gb (${PCENTDISK}%)" #5
echo "#CPU load: ${CPU}" #6
echo "#Last boot: $(who -b | awk '$1 == "system" {print $3 " " $4}')" #7
echo "#LVM use: ${LVM}" #8
echo "#Connections TCP: ${TCP} ${TCPMSG}" #9
echo "#User log: ${USERLOG}" #10
echo "#Network: IP ${IP} (${MAC})" #11
echo "#Sudo: ${SUDO} cmd" #12

## 9 Use netstat command to calculate and count the number of connections each IP address makes to the server. 
##  https://techjourney.net/how-to-find-and-check-number-of-connections-to-a-server/#:~:text=Use%20netstat%20command%20to%20calculate,address%20makes%20to%20the%20server.&text=List%20count%20of%20number%20of,using%20TCP%20or%20UDP%20protocol.&text=Check%20on%20ESTABLISHED%20connections%20instead,connections%20count%20for%20each%20IP.

## TCP stands for Transmission Control Protocol a communications standard that enables application programs and computing devices to exchange messages over a network. It is designed to send packets across the internet and ensure the successful delivery of data and messages over networks.
