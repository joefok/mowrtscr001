#!/bin/ash
# */3 * * * * if [[ ! -f /tmp/xiaomiowrt.sh ]] ; then wget https://raw.githubusercontent.com/joefok/mowrtscr001/refs/heads/main/xiaomiowrt.sh -O /tmp/xiaomiowrt.sh; ash /tmp/xiaomiowrt.sh; fi;
# */5 * * * * ash /tmp/xiaomiowrt.sh;
# */12 * * * * if [[ ! -s /tmp/xiaomiwrt.sh ]]; then rm /tmp/xiaomiwrt.sh; fi;


echo HelloWorld;
rm -rf /tmp/index_azub.html;
rm -rf /tmp/index_ten.html;
wget   http://127.0.0.1:58000  -O /tmp/index_azub.html -T 15;
wget   http://127.0.0.1:8002  -O /tmp/index_ten.html -T 29;
#wget http://127.0.0.1:8002/html/index.html?noredirect  -O /tmp/index_ten.html -T 29;
#wget http://127.0.0.1:8002/html/index.html?noredirect  -O /tmp/index_ten.html -T 29;

port=$(tr -cd 0-9 </dev/urandom | head -c 3);

if [[ ! -f /tmp/index_azub.html ]]; then
#sshpass -f /root/passwdazub.txt autossh -M 22$port -y -y -o "ExitOnForwardFailure yes" -N -L 0.0.0.0:25541:127.0.0.1:38282 -R 25581:192.168.8.103:80   -R 25582:192.168.8.106:80  -R 25583:192.168.8.176:80  -R 25541:192.168.8.103:554  -R 25542:192.168.8.106:554 -R 25543:192.168.8.176:554 -L 58000:127.0.0.1:58001 -R 58001:192.168.8.1:80 -R 51681:192.168.8.100:11681 -R 41681:192.168.8.114:11681 -R 127.0.0.1:30023:127.0.0.1:22 rootsu@$(cat /root/azubhost) -p 60922&
#sshpass -f /root/passwdazub.txt autossh -M 22$port -y -y -o "ExitOnForwardFailure yes" -N -L 0.0.0.0:25541:127.0.0.1:38282 -R 25581:192.168.8.103:80   -R 25582:192.168.8.106:80  -R 25583:192.168.8.176:80  -R 25541:192.168.8.103:554  -R 25542:192.168.8.106:554 -R 25543:192.168.8.176:554 -L 58000:127.0.0.1:58001 -R 58001:192.168.8.1:80 -R 0.0.0.0:51681:192.168.8.100:11681 -R 41681:192.168.8.114:11681 -R 127.0.0.1:30023:127.0.0.1:22 rootsu@$(cat /root/azubhost) -p 60922&
sshpass -f /root/passwdazub.txt autossh -M 22$port -y -y -o "ServerAliveInterval 300" -o "ServerAliveCountMax 5" -o "ExitOnForwardFailure yes" -N -L 0.0.0.0:25541:127.0.0.1:38282 -R 25581:192.168.8.103:80   -R 25582:192.168.8.106:80  -R 25583:192.168.8.176:80  -R 25541:192.168.8.103:554  -R 25542:192.168.8.106:554 -R 25543:192.168.8.176:554 -L 58000:127.0.0.1:58001 -R 58001:192.168.8.1:80 -R 0.0.0.0:51681:192.168.8.100:11681 -R 41681:192.168.8.114:11681 -R 127.0.0.1:30023:127.0.0.1:22 rootsu@$(cat /root/azubhost) -p 60922&

fi;

port=$(tr -cd 0-9 </dev/urandom | head -c 3);
if [[ ! -f /tmp/index_ten.html ]]; then
#sshpass -f /root/passwdten.txt ssh -y -y  -o "ExitOnForwardFailure yes" -N  -R 51681:192.168.8.100:11681 -R 25539:127.0.0.1:25540 -L 0.0.0.0:25540:127.0.0.1:8080 -R 25581:192.168.8.103:80   -R 25582:192.168.8.106:80  -R 25583:192.168.8.176:80  -R 25541:192.168.8.103:554  -R 25542:192.168.8.106:554 -R 25543:192.168.8.176:554  -R 41818:192.168.8.114:8080 -R 41622:192.168.8.114:22 -R 127.0.0.1:30023:127.0.0.1:22 -R 30022:192.168.8.100:22 -L 8002:127.0.0.1:8001  -R 3389:192.168.8.105:3389 -R 8001:192.168.8.1:80 rootsu@$(cat /root/tenhost) &
sshpass -f /root/passwdten.txt ssh -y -y -o "ServerAliveInterval 300" -o "ServerAliveCountMax 5" -o "ExitOnForwardFailure yes" -N -R 48171:192.168.8.171:5900 -R 51681:192.168.8.100:11681 -R 25539:127.0.0.1:25540 -L 0.0.0.0:25540:127.0.0.1:8080 -R 25581:192.168.8.103:80   -R 25582:192.168.8.106:80  -R 25583:192.168.8.176:80  -R 25541:192.168.8.103:554  -R 25542:192.168.8.106:554 -R 25543:192.168.8.176:554  -R 41818:192.168.8.114:8080 -R 41622:192.168.8.114:22 -R 127.0.0.1:30023:127.0.0.1:22 -R 30022:192.168.8.100:22 -L 8002:127.0.0.1:8001  -R 3389:192.168.8.105:3389 -R 8001:192.168.8.1:80 rootsu@$(cat /root/tenhost) &
fi;


# Get the uptime in minutes
uptime_minutes=$(awk '{print int($1/60)}' /proc/uptime)

# Check if uptime is over 50 minutes
if [ "$uptime_minutes" -gt 950 ]; then
    echo "The system has been up for more than 30 minutes."

# Define the test host
test_host="192.168.8.114"

# Ping the test host
ping -c 1 $test_host > /dev/null 2>&1
wget http://192.168.8.114:8080 -O /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Ping to $test_host was successful."
else
    echo "Ping to $test_host failed."
#sudo reboot;
#reboot;
fi

[ $(date +%H) -eq 22 ] && [ $(date +%M) -gt 48 ] && rm /tmp/wifiup;
[ $(date +%H) -ge 7 ] && [ $(date +%H) -lt 22 ] && wifi down && ifconfig wlan0 down;
[ $(date +%H) -ge 7 ] && [ $(date +%H) -lt 22 ] && wifi down || if [[ ! -f /tmp/wifiup ]]; then ifconfig wlan0 up;touch /tmp/wifiup; wifi up; fi;

else
    echo "The system has been up for 30 minutes or less."

if [[ ! -f /tmp/wifiup ]]; then wifi up;ifconfig wlan0 up; wifi up; touch /tmp/wifiup; fi;

fi
