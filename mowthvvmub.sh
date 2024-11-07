#!/bin/bash
# CONNECT TO SSH ->>>>>>       sshpass -p $(cat /root/ubpwd) ssh rootsu@$(cat /root/ubhost) -p 60922

# docker
# rm /root/.ssh/known_hosts; sshpass -p $(cat /root/ubpwd) ssh -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -L 0.0.0.0:51744:127.0.0.1:51744 -R 51722:127.0.0.1:22 -R 51782:127.0.0.1:51782 rootsu@$(cat /root/ubhost) -p 60922&
# ninja
rm /root/.ssh/known_hosts; sshpass -p $(cat /root/ubpwd) ssh -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -L 0.0.0.0:65022:$(cat /root/ubhost):65022 -L 0.0.0.0:51744:127.0.0.1:51744 -R 0.0.0.0:51722:127.0.0.1:22 -R 0.0.0.0:51782:127.0.0.1:51782 rootsu@$(cat /root/ubhost) -p 60922&

# check if any sftp error
if grep -q SFTP /root/.pm2/logs/camera-out.log; then
  rm /tmp/shinupdate;
fi;

# update 
if [ ! -f /tmp/shinupdate ]; then
touch /tmp/shinupdate;
sed -i '2s/.*/   "debugLog": true,/' /home/Shinobi/conf.json;
cd /home/Shinobi;
sh UPDATE.sh;
cd /home/Shinobi;
pm2 flush;
cd /home/Shinobi;
pm2 restart camera;
cd /home/Shinobi;
pm2 restart cron;
killall ssh;
fi;
