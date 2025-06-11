#!/bin/bash
echo HelloWorld;
# @reboot sleep 25; /usr/bin/proxychains4 python3 /root/server.py&
# * 7-23 * * * if [ ! -f /tmp/u428jump.sh ] ; then wget https://raw.githubusercontent.com/joefok/mowrtscr001/refs/heads/main/u428jump.sh -O /tmp/u428jump.sh; bash /tmp/u428jump.sh; fi;
# */5 * * * * bash /tmp/u428jump.sh;

# env file list
# /root/tenhost
# /root/passwdten.txt
# /root/azubhost
# /root/passwdazub.txt

ip428address=$(nslookup info-428 | grep Address | tail -n 1 | cut -d ' ' -f 2)
test -z "$ip428address" && ip428address=127.0.0.1
echo $ip428address

/usr/bin/sshpass -f /root/passwdten.txt ssh -o ExitOnForwardFailure=yes -N -R 8082:127.0.0.1:8080 -L 51681:127.0.0.1:51681  -L 38181:127.0.0.1:8099  -R 8097:127.0.0.1:22 -R 31681:127.0.0.1:11681 -L 127.0.0.1:30022:127.0.0.1:30022  -R 33890:$ip428address:3389  -L 172.17.0.1:44581:127.0.0.1:25581 -L 172.17.0.1:44582:127.0.0.1:25582 -L 172.17.0.1:44583:127.0.0.1:25583  -L 172.17.0.1:44541:127.0.0.1:25541 -L 172.17.0.1:44542:127.0.0.1:25542 -L 172.17.0.1:44543:127.0.0.1:25543  -L 172.17.0.1:44080:127.0.0.1:8080 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no rootsu@$(cat /root/tenhost) &

#/usr/bin/sshpass -f /root/passwdazub.txt ssh -o ExitOnForwardFailure=yes -N -L 6000:127.0.0.1:6000 -R 33631:127.0.0.1:631  -R 5455:127.0.0.1:11681 -R 38282:127.0.0.1:8080 -L 172.17.0.1:25581:127.0.0.1:25581 -L 172.17.0.1:25582:127.0.0.1:25582 -L 172.17.0.1:25583:127.0.0.1:25583  -L 172.17.0.1:25541:127.0.0.1:25541 -L 172.17.0.1:25542:127.0.0.1:25542 -L 172.17.0.1:25543:127.0.0.1:25543 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no rootsu@$(cat /root/azubhost) -p 60922 &
#/usr/bin/sshpass -f /root/passwdazub.txt ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -L 6000:127.0.0.1:6000 -R 33631:127.0.0.1:631  -R 5455:127.0.0.1:11681 -R 38282:127.0.0.1:8080 -L 172.17.0.1:25581:127.0.0.1:25581 -L 172.17.0.1:25582:127.0.0.1:25582 -L 172.17.0.1:25583:127.0.0.1:25583  -L 172.17.0.1:25541:127.0.0.1:25541 -L 172.17.0.1:25542:127.0.0.1:25542 -L 172.17.0.1:25543:127.0.0.1:25543 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no rootsu@$(cat /root/azubhost) -p 60922 &
#/usr/bin/sshpass -f /root/passwdazub.txt ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -L 51433:127.0.0.1:51433 -L 6000:127.0.0.1:6000 -R 33631:127.0.0.1:631  -R 5455:127.0.0.1:11681 -R 38422:127.0.0.1:22  -R 38282:127.0.0.1:8080 -L 172.17.0.1:25581:127.0.0.1:25581 -L 172.17.0.1:25582:127.0.0.1:25582 -L 172.17.0.1:25583:127.0.0.1:25583  -L 172.17.0.1:25541:127.0.0.1:25541 -L 172.17.0.1:25542:127.0.0.1:25542 -L 172.17.0.1:25543:127.0.0.1:25543 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no rootsu@$(cat /root/azubhost) -p 60922 &
/usr/bin/sshpass -f /root/passwdazub.txt ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -L 51782:127.0.0.1:51782 -L 51433:127.0.0.1:51433 -L 6000:127.0.0.1:6000 -R 33631:127.0.0.1:631  -R 5455:127.0.0.1:11681 -R 38422:127.0.0.1:22  -R 38282:127.0.0.1:8080 -L 172.17.0.1:25581:127.0.0.1:25581 -L 172.17.0.1:25582:127.0.0.1:25582 -L 172.17.0.1:25583:127.0.0.1:25583  -L 172.17.0.1:25541:127.0.0.1:25541 -L 172.17.0.1:25542:127.0.0.1:25542 -L 172.17.0.1:25543:127.0.0.1:25543 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no rootsu@$(cat /root/azubhost) -p 60922 &

uptime=$(awk '{print $1}' /proc/uptime)
uptime_minutes=$(echo "$uptime / 60" | bc)
if [ "$uptime_minutes" -ge 10 ]; then
if ping -c 1 google.com &> /dev/null
then
  echo "Internet connection is working."
else
  echo "Internet connection is not working."
  #reboot
fi
else
  echo "System has been up for less than 10 minutes."
fi

# MAINTENANCE CHECK
#!/bin/bash

# Check if CUPS is installed
if ! dpkg -l | grep -qw cups; then
    echo "CUPS is not installed. Installing CUPS..."
    sudo apt-get update
    sudo apt-get install -fy cups
    wget -O /tmp/cups-ubuntuthermalprinter.tar.gz https://github.com/joefok/mowrtscr001/raw/refs/heads/main/cups-ubuntuthermalprinter.tar.gz
    cd /
    tar -zxvf /tmp/cups*
    systemctl restart cups
    /etc/init.d/cups restart

else
    echo "CUPS is already installed."
fi



#!/bin/bash

# Check the current hostname
current_hostname=$(hostname)

# Desired hostname
desired_hostname="ubuntuthermalprinter"

# Check if the current hostname matches the desired hostname
if [ "$current_hostname" != "$desired_hostname" ]; then
    echo "Current hostname is $current_hostname. Changing to $desired_hostname..."
    
    # Set the hostname
    sudo hostnamectl set-hostname $desired_hostname

    # Update /etc/hostname
    echo $desired_hostname | sudo tee /etc/hostname > /dev/null

    # Update /etc/hosts
    sudo sed -i "s/127.0.1.1\s*$current_hostname/127.0.1.1 $desired_hostname/" /etc/hosts

#!/bin/bash

# Update the package list and install required packages
echo "Installing Samba and Winbind..."
sudo apt-get update
sudo apt-get install -y samba winbind smbclient libnss-winbind libpam-winbind

# Backup and configure nsswitch.conf
echo "Configuring nsswitch.conf..."
sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
sudo sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf

# Install and configure systemd-resolved to handle DNS
echo "Configuring systemd-resolved..."
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved

# Create a symbolic link to resolve MDNS
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Configure Samba
echo "Configuring Samba..."
sudo tee /etc/samba/smb.conf > /dev/null <<EOL
[global]
   workgroup = WORKGROUP    # Change to your Windows Workgroup name
   security = user
   winbind use default domain = yes
   winbind offline logon = false
   winbind nss info = rfc2307
   winbind refresh tickets = yes
   
   # Enable WINS server to resolve hostnames
   wins support = yes
   dns proxy = no
   name resolve order = wins lmhosts hosts bcast
   domain master = yes
   local master = yes
   preferred master = yes
   os level = 65

EOL

# Restart Samba and Winbind services
echo "Restarting Samba and Winbind services..."
sudo systemctl restart smbd nmbd winbind

echo "Setup completed. Your Ubuntu machine should now be reachable by hostname from Windows machines."


    # Verify the change
    if [ "$(hostname)" == "$desired_hostname" ]; then
        echo "Hostname successfully changed to $desired_hostname."
    else
        echo "Failed to change the hostname."
    fi
else
    echo "Hostname is already set to $desired_hostname."
fi

#!/bin/bash

# Desired timezone
desired_timezone="Asia/Hong_Kong"

# Get the current timezone
current_timezone=$(timedatectl show --property=Timezone --value)

# Check if the current timezone matches the desired timezone
if [ "$current_timezone" != "$desired_timezone" ]; then
    echo "Current timezone is $current_timezone. Changing to $desired_timezone..."
    
    # Set the timezone
    sudo timedatectl set-timezone $desired_timezone
#!/bin/bash

# Prevent the system from going to sleep on lid close
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf

# Apply the changes
sudo systemctl restart systemd-logind

# Use systemd-inhibit to prevent the system from sleeping or going idle
systemd-inhibit --what=idle:sleep:shutdown:handle-lid-switch sleep infinity &

    # Verify the change
    if [ "$(timedatectl show --property=Timezone --value)" == "$desired_timezone" ]; then
        echo "Timezone successfully changed to $desired_timezone."
    else
        echo "Failed to change the timezone."
    fi
else
    echo "Timezone is already set to $desired_timezone."
fi
