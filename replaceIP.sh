#! /bin/bash
##Replace IP adress of host 
new_ip=$(curl http://checkip.amazonaws.com)
sed -r -i 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$new_ip"/ sg_rule.tf  