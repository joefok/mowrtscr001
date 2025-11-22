#!/bin/bash
# CONNECT TO SSH ->>>>>>       sshpass -p $(cat /root/ubpwd) ssh rootsu@$(cat /root/ubhost) -p 60922

# docker
# rm /root/.ssh/known_hosts; sshpass -p $(cat /root/ubpwd) ssh -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -L 0.0.0.0:51744:127.0.0.1:51744 -R 51722:127.0.0.1:22 -R 51782:127.0.0.1:51782 rootsu@$(cat /root/ubhost) -p 60922&
# ninja
#rm /root/.ssh/known_hosts; sshpass -p $(cat /root/ubpwd) ssh -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -L 0.0.0.0:65022:$(cat /root/ubhost):65022 -L 0.0.0.0:51744:127.0.0.1:51744 -R 0.0.0.0:51722:127.0.0.1:22 -R 0.0.0.0:51782:127.0.0.1:51782 rootsu@$(cat /root/ubhost) -p 60922&
rm /root/.ssh/known_hosts; sshpass -p $(cat /root/ubpwd) ssh  -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -L 0.0.0.0:65022:$(cat /root/ubhost):65022 -L 0.0.0.0:51744:127.0.0.1:51744 -R 0.0.0.0:51722:127.0.0.1:22 -R 0.0.0.0:51782:127.0.0.1:51782 rootsu@$(cat /root/ubhost) -p 60922&

# check web UI alive
rm -rf /tmp/index_azub.html;
#wget   http://127.0.0.1:51782/ -O /tmp/index_azub.html -T 150;
wget   http://$(cat /root/ubhost):51782/ -O /tmp/index_azub.html -T 150;

upSeconds="$(cat /proc/uptime | grep -o '^[0-9]\+')"
upMins=$((${upSeconds} / 60))
if [ "${upMins}" -gt "5" ]; then
    echo "Up for ${upMins} minutes";
else
    if [[ ! -f /tmp/index_azub.html ]]; then
      rm /tmp/shinupdate;
    fi;
fi;


# check if any sftp error
if grep -q SFTP /root/.pm2/logs/camera-out.log; then
#  rm /tmp/shinupdate;
fi;

# Over 3MB size
if [ -n "$(find /root/.pm2/logs/camera-out.log -prune -size +3000000c)" ]; then
pm2 flush;
fi;

# update 
if [ ! -f /tmp/shinupdate ]; then
timedatectl set-timezone Asia/Hong_Kong;
touch /tmp/shinupdate;
sudo apt remove unattended-upgrades -fy;
sed -i '1s/.*/APT::Periodic::Update-Package-Lists "0";/' /etc/apt/apt.conf.d/20auto-upgrades;
sed -i '2s/.*/APT::Periodic::Unattended-Upgrade "0";/' /etc/apt/apt.conf.d/20auto-upgrades;
sed -i '2s/.*/   "debugLog": true,/' /home/Shinobi/conf.json;
cd /home/Shinobi;
#sh UPDATE.sh;
cd /home/Shinobi;
pm2 flush;
cd /home/Shinobi;
pm2 restart camera;
cd /home/Shinobi;
pm2 restart cron;
echo 'HostKeyAlgorithms +ssh-rsa,ssh-dss' | sudo tee -a /etc/ssh/sshd_config

# Get uptime in seconds
upSeconds=$(awk '{print int($1)}' /proc/uptime)
# Convert to minutes
upMins=$(( upSeconds / 60 ))
# Check if uptime is less than 10 minutes
if (( upMins < 10 )); then
    echo "System uptime is less than 10 minutes."
    sudo systemctl restart sshd
    killall ssh;
else
    echo "System uptime is 10 minutes or more."
fi


sed -i '990s/.*/$.each(getMonitorsFromIds(["BBTrm01R","BBTrm01L","BBlobb006","BBexam003","BBexam002","BBexam001","BBTrm02R","BBTrm02L","BBlobb004","BBexam006","BBexam005","BBexam004","BBTrm03R","BBTrm03L","BBlobb002","BBexam009","BBexam008","b1usbWcm1","BBconfeL","BBTrm04R","BBlobb103","BBlobb142","BBMEET01L","BBMEET01R","BBTrm05R","BBTrm05L","BBlobb143","BBlobb113","BBMEET2L","BBMEET2R"]),function(monitorId,monitor){/' /home/Shinobi/web/assets/js/bs5.liveGrid.js;

fi;

################# CHECK IF NEED RESTORE BACKUP ################
# Define the file to check migrate data flag if not existed today
file="/root/migratedataflag"
# Get today's date in YYYY-MM-DD format
today=$(date +%Y-%m-%d)
# Check if the file was created today
if [[ $(find "$file" -type f -newermt "$today" ! -newermt "$today +1 day") ]]; then
    echo "The file was created today."
else
    echo "The file was not created today."
    rm -rf /root/migratedataflag
    rm -rf /tmp/shinupdate 
    rm -rf /tmp/MOVMmigratearchive.tar.gz.gpg
    rm -rf /tmp/migratearchive.tar.gz
fi
################# CHECK IF NEED RESTORE BACKUP ################


### MIGRATE RESTORE BACKUP ###

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
# Define the filename
filename="/root/passwdmigrate"
# Check if the file does not exist
if [ ! -f "$filename" ]; then
    echo "File does not exist."
touch /root/passwdmigrate # nano edit this file
echo 1234 > /root/passwdmigrate;
cat /root/ubpwd > /root/passwdmigrate;
else
    echo "File exists."
fi


# restore migration
FILE="/tmp/MOVMmigratearchive.tar.gz.gpg"
if [ -e "$FILE" ]; then
    echo "The file exists."
else
    echo "The file does not exist."
wget -O /tmp/MOVMmigratearchive.tar.gz.gpg https://github.com/joefok/mowrtscr001/raw/refs/heads/main/MOVMmigratearchive.tar.gz.gpg
gpg --batch --passphrase-file /root/passwdmigrate --output /tmp/migratearchive.tar.gz --decrypt /tmp/MOVMmigratearchive.tar.gz.gpg 
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

# backup migration
FILE="/tmp/migratearchive.tar.gz"
if [ -e "$FILE" ]; then
    echo "The file exists."
else
    echo "The file does not exist."
mysqldump --defaults-file=/tmp/mysqldump.cnf ccio > /tmp/ShinobiDatabaseBackup.sql
tar czvf /tmp/migratearchive.tar.gz /tmp/ShinobiDatabaseBackup.sql /home/Shinobi/conf.json /home/Shinobi/super.json
gpg --batch --passphrase-file /root/passwdmigrate --symmetric --cipher-algo aes256 -o /tmp/MOVMmigratearchive.tar.gz.gpg /tmp/migratearchive.tar.gz
fi
# scp /tmp/MOVMmigratearchive.tar.gz.gpg rootsu@localhost:/tmp/MOVMmigratearchive.tar.gz.gpg
# rm -rf /tmp/migratearchive.tar.gz
# rm -rf /tmp/MOVMmigratearchive.tar.gz.gpg

