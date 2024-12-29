#!/bin/bash

# sample cron job
# */3 * * * * [ ! -f "/tmp/opionemain.sh" ] && wget -O "/tmp/opionemain.sh" "https://raw.githubusercontent.com/joefok/mowrtscr001/refs/heads/main/opionemain.sh"
# */3 * * * * bash /tmp/opionemain.sh;

# mysqldump and mysql password less
FILE="/tmp/mysqldump.cnf "
if [ -e "$FILE" ]; then
    echo "The file exists."
else
    echo "The file does not exist."
touch /tmp/mysqldump.cnf 
chmod 600 /tmp/mysqldump.cnf
echo [mysqldump] > /tmp/mysqldump.cnf 
echo user=root >> /tmp/mysqldump.cnf 
echo password=your_password >> /tmp/mysqldump.cnf 
echo [mysql] >> /tmp/mysqldump.cnf 
echo user=root >> /tmp/mysqldump.cnf 
echo password=your_password >> /tmp/mysqldump.cnf 
cat /tmp/mysqldump.cnf 
fi

# create backup for migration with password encrypted
touch /root/passwdmigrate # nano edit this file
echo 1234 > /root/passwdmigrate;

FILE="/tmp/migratearchive.tar.gz"
if [ -e "$FILE" ]; then
    echo "The file exists."
else
    echo "The file does not exist."
mysqldump --defaults-file=/tmp/mysqldump.cnf ccio > /tmp/ShinobiDatabaseBackup.sql
tar czvf /tmp/migratearchive.tar.gz /tmp/ShinobiDatabaseBackup.sql /home/Shinobi/conf.json /home/Shinobi/super.json
gpg --batch --passphrase-file /root/passwdmigrate --symmetric --cipher-algo aes256 -o /tmp/migratearchive.tar.gz.gpg /tmp/migratearchive.tar.gz
fi

# restore migration
FILE="/tmp/migratearchive.tar.gz.gpg"
if [ -e "$FILE" ]; then
    echo "The file exists."
else
    echo "The file does not exist."
wget -O /tmp/migratearchive.tar.gz.gpg https://github.com/joefok/mowrtscr001/raw/refs/heads/main/migratearchive.tar.gz.gpg
gpg --batch --passphrase-file /root/passwdmigrate --output /tmp/migratearchive.tar.gz --decrypt /tmp/migratearchive.tar.gz.gpg 
fi

DIR="/home/Shinobi"
if [ -d "$DIR" ]; then
    echo "The directory exists."
FILE="/root/migratedataflag"
if [ ! -f "$FILE" ]; then
touch /root/migratedataflag
cd /
tar xzvf /tmp/migratearchive.tar.gz 
mysql ccio < /tmp/ShinobiDatabaseBackup.sql
cd /home/Shinobi
npm install discord.js
node tools/modifyConfiguration.js addToConfig='{"discordBot":true}'
pm2 restart all
fi
else
    echo "The directory does not exist."
fi


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
if [ "$uptime_minutes" -gt 30 ]; then
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

if dpkg -l | grep -q ntpdate; then
    echo "The ntpdate package is installed."
NTP_SERVER="stdtime.gov.hk"
sudo ntpdate $NTP_SERVER
else
    echo "The ntpdate package is not installed."
apt install -fy ntpdate;
timedatectl set-timezone Asia/Hong_Kong
fi


fi;


