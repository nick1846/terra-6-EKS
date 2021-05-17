#! /bin/bash
##Replace IP adress of host 
new_ip=$(curl ipv4.icanhazip.com)
sed -r -i 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$new_ip"/ security_group.tf  