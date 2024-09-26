#!/bin/bash
#  sshpass -f /root/ubpwd ssh -y rootsu@$(cat /root/ubhost) -p 60922;
# CONNECT TO SSH ->>>>>>       sshpass -p $(cat /root/ubpwd) ssh rootsu@$(cat /root/ubhost) -p 60922

rm /root/.ssh/known_hosts; sshpass -p $(cat /root/ubpwd) ssh -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -R 55432:127.0.0.1:5432 -R 41022:127.0.0.1:22 $strrev  rootsu@$(cat /root/ubhost) -p 60922&
