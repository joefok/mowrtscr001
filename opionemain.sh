#!/bin/bash

# check web UI alive
rm -rf /tmp/index_azub.html;
wget   http://127.0.0.1:8080/ -O /tmp/index_azub.html -T 150;
if [[ ! -f /tmp/index_azub.html ]]; then
      rm /tmp/shinupdate;
fi;

# check if any discord error
if grep -q discord /root/.pm2/logs/camera-error.log; then
  rm /tmp/shinupdate;
fi;

# Over 3MB size
if [ -n "$(find /root/.pm2/logs/camera-error.log -prune -size +3000000c)" ]; then
pm2 flush;
fi;

# Get the uptime in minutes
uptime_minutes=$(awk '{print int($1/60)}' /proc/uptime)
# Check if uptime is over 30 minutes
if [ "$uptime_minutes" -gt 20 ]; then
    echo "The system has been up for more than 30 minutes."
else
    echo "The system has been up for 30 minutes or less."
    touch /tmp/shinupdate;
fi

# update 
if [ ! -f /tmp/shinupdate ]; then
touch /tmp/shinupdate;
sudo apt remove unattended-upgrades -fy;
sed -i '1s/.*/APT::Periodic::Update-Package-Lists "0";/' /etc/apt/apt.conf.d/20auto-upgrades;
sed -i '2s/.*/APT::Periodic::Unattended-Upgrade "0";/' /etc/apt/apt.conf.d/20auto-upgrades;
#sed -i '2s/.*/   "debugLog": false,/' /home/Shinobi/conf.json;
cd /home/Shinobi;
pm2 stop camera;
pm2 stop all;
sh UPDATE.sh;
cd /home/Shinobi;
pm2 flush;
cd /home/Shinobi;
pm2 restart camera;
cd /home/Shinobi;
pm2 restart cron;
killall ssh;

NTP_SERVER="stdtime.gov.hk"
sudo ntpdate $NTP_SERVER

fi;


