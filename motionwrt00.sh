#!/bin/ash
echo HelloWorld;
# attempt to ssh session from console
# SSH CONSOLE MANUALLY ->    sshpass -f /root/ubpwd ssh -y rootsu@$(cat /root/ubhost) 
# sshpass -f /root/ubpwd autossh -M 41381 rootsu@$(cat /root/ubhost)
# sshpass -f /root/ubpwd autossh -M 41381 -o StrictHostKeyChecking=no rootsu@$(cat /root/ubhost)
# rm /root/.ssh/known_hosts
# rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd autossh -M 41381 -y rootsu@$(cat /root/ubhost);

# for loop
strrev=""
for i in {1..255}
do
  strrev+=" -R $(expr 25000 + $i):10.8.25.$i:554"
done
echo $strrev

# rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd autossh -M 41381 -y -N -R 39285:127.0.0.1:80  -L 0.0.0.0:39286:127.0.0.1:8080  rootsu@$(cat /root/ubhost)&
rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd autossh -M 41381 -y -N -R 39285:127.0.0.1:80 $strrev -L 0.0.0.0:39286:127.0.0.1:8080  rootsu@$(cat /root/ubhost)&
