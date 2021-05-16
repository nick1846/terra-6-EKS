#! /bin/bash
##Replace IP adress of host 
sed -r -i 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"0.0.0.0"/ security_group.tf  