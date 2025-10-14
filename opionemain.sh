#!/bin/bash

# sample cron job
# */5 * * * * [ ! -f "/tmp/opionemain.sh" ] && wget -O "/tmp/opionemain.sh" "https://raw.githubusercontent.com/joefok/mowrtscr001/refs/heads/main/opionemain.sh"
# */3 * * * * bash /tmp/opionemain.sh;
# */12 * * * * [ ! -s /tmp/opionemain.sh ] && rm /tmp/opionemain.sh;

# shinobi restore cron job orange pi opi
#!/usr/bin/env bash
set -euo pipefail
FLAG="/root/crontabflag"
# 僅在旗標檔不存在時執行
if [[ ! -f "$FLAG" ]]; then
  touch "$FLAG"
  # 覆寫 root 的 crontab
crontab - <<'EOF'
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MAILTO=""
*/5 * * * * [ ! -f "/tmp/opionemain.sh" ] && wget -q -O "/tmp/opionemain.sh" "https://raw.githubusercontent.com/joefok/mowrtscr001/refs/heads/main/opionemain.sh"
*/3 * * * * sleep 1800; /usr/bin/flock -n /tmp/opionemain.lock bash /tmp/opionemain.sh
*/12 * * * * [ ! -s "/tmp/opionemain.sh" ] && rm -f "/tmp/opionemain.sh"
EOF
fi

FLAG="/root/shinobiflag"
if [[ ! -f "$FLAG" ]]; then
  touch "$FLAG"
  bash -c '
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
# 1) 基礎工具（不安裝 UFW，亦不設定 IPv4-only）
apt-get update -y
apt-get install -y curl git ca-certificates
# 2) 取用 Shinobi 原始碼
if [ ! -d /opt/Shinobi ]; then
  git clone --depth=1 https://gitlab.com/Shinobi-Systems/Shinobi /opt/Shinobi
fi
cd /opt/Shinobi
# 3) 無人值守 Touchless 安裝（Node.js / FFmpeg / MariaDB / NPM / PM2）
bash INSTALL/ubuntu-touchless.sh
'
fi

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
hostname -I | awk '{print $1}'  > /root/passwdmigrate;
else
    echo "File exists."
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

# if the file /root/migratedataflag was not modified today, and if so, delete it.
[ "$(date -r /root/migratedataflag +%F)" != "$(date +%F)" ] && rm -f /root/migratedataflag
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


# BACKUP 
FILE="/tmp/migratearchive.tar.gz"
if [ -e "$FILE" ]; then
    echo "The file exists."
else
    echo "The file does not exist."
mysqldump --defaults-file=/tmp/mysqldump.cnf ccio > /tmp/ShinobiDatabaseBackup.sql
tar czvf /tmp/migratearchive.tar.gz /tmp/ShinobiDatabaseBackup.sql /home/Shinobi/conf.json /home/Shinobi/super.json
gpg --batch --passphrase-file /root/passwdmigrate --symmetric --cipher-algo aes256 -o /tmp/migratearchive.tar.gz.gpg /tmp/migratearchive.tar.gz
fi
# scp /tmp/migratearchive.tar.gz.gpg rootsu@localhost:/tmp/migratearchive.tar.gz.gpg
# rm -rf /tmp/migratearchive.tar.gz
# rm -rf /tmp/migratearchive.tar.gz.gpg

# check web UI alive
rm -rf /tmp/index_azub.html;
wget   http://127.0.0.1:8080/ -O /tmp/index_azub.html -T 10;
if [[ ! -f /tmp/index_azub.html ]]; then
      rm /tmp/shinupdate;
fi;
if [[ ! -s /tmp/index_azub.html ]]; then
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
if [ "$uptime_minutes" -gt 90 ]; then
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

#sh <(curl -s https://cdn.shinobi.video/installers/shinobi-install.sh)&

fi;

# swap
if timedatectl | grep -q 'Time zone.*UTC'; then
    if dpkg -l | grep -q ntpdate; then
        echo "The ntpdate package is installed."
    else
        echo "The ntpdate package is not installed. Installing..."
        sudo apt install -fy ntpdate
    fi
    NTP_SERVER="stdtime.gov.hk"
    sudo ntpdate $NTP_SERVER
    sudo timedatectl set-timezone Asia/Hong_Kong
pm2 stop camera;
pm2 stop all;
# swap
sudo swapoff -a && sudo dd if=/dev/zero of=/swapfile bs=1M count=2048 && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
# swap 
sudo sysctl vm.swappiness=100 && echo 'vm.swappiness=100' | sudo tee -a /etc/sysctl.conf
cd /home/Shinobi;
pm2 restart camera;
cd /home/Shinobi;
pm2 restart cron;
else
    echo "Timezone does not contain UTC. No changes made."
fi
# swap

FLAG_FILE="/root/cloud-utils-installed"

if [ ! -f "$FLAG_FILE" ]; then
    echo "Flag file not found. Installing cloud-guest-utils..."
    sudo apt update
    sudo apt install -f -y cloud-guest-utils
    sudo touch "$FLAG_FILE"
    echo "Installation complete and flag file created."
else
    echo "Flag file exists. Skipping installation."
fi


FSCK_FLAG="/forcefsck"

if [ ! -f "$FSCK_FLAG" ]; then
    echo "Filesystem check flag not found. Creating it..."
    sudo touch "$FSCK_FLAG"
    echo "Flag file created. Root filesystem will be checked on next boot."
    sudo growpart /dev/mmcblk0 1
    sudo resize2fs /dev/mmcblk0p1
    #sudo swapoff -a
else
    echo "Filesystem check flag already exists. No action needed."
fi


# Get the uptime in minutes
uptime_minutes=$(awk '{print int($1/60)}' /proc/uptime)
# Check if uptime is over 30 minutes
if [ "$uptime_minutes" -gt 90 ]; then
    crontab -r;
    echo "The system has been up for more than 30 minutes."
    # check the status of all PM2 processes and restart them if any are not online
if ! pm2 status | grep -qv "online"; then
    echo "Some PM2 processes are not online. Restarting all..."
    pm2 restart all
fi
fi



