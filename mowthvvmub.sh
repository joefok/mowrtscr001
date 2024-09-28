#!/bin/bash
# CONNECT TO SSH ->>>>>>       sshpass -p $(cat /root/ubpwd) ssh rootsu@$(cat /root/ubhost) -p 60922

rm /root/.ssh/known_hosts; sshpass -p $(cat /root/ubpwd) ssh -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -R 51722:127.0.0.1:22 -R 51782:127.0.0.1:8080 rootsu@$(cat /root/ubhost) -p 60922&
