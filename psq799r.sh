#!/bin/bash
#  sshpass -f /root/ubpwd ssh -y rootsu@$(cat /root/ubhost) -p 60922;
# CONNECT TO SSH ->>>>>>       sshpass -p $(cat /root/ubpwd) ssh rootsu@$(cat /root/ubhost) -p 60922

rm /root/.ssh/known_hosts; sshpass -p $(cat /root/ubpwd) autossh -M 44381  -o StrictHostKeyChecking=no  -N -R 41022:127.0.0.1:22 $strrev  rootsu@$(cat /root/ubhost) -p 60922&
