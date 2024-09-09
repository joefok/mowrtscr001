#!/bin/ash
echo HelloWorld;
# attempt to ssh session from console
# sshpass -f /root/ubpwd ssh rootsu@$(cat /root/ubhost) 
# sshpass -f /root/ubpwd autossh -M 41381 rootsu@$(cat /root/ubhost)
# sshpass -f /root/ubpwd autossh -M 41381 -o StrictHostKeyChecking=no rootsu@$(cat /root/ubhost)
# rm /root/.ssh/known_hosts
# rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd autossh -M 41381 -y rootsu@$(cat /root/ubhost);
rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd autossh -M 41381 -y -R 39285:127.0.0.1:80 rootsu@$(cat /root/ubhost);
