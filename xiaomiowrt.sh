#!/bin/ash
echo HelloWorld;
rm -rf /tmp/index_azub.html;
rm -rf /tmp/index_ten.html;
wget   http://127.0.0.1:58000/html/index.html?origin=xxx  -O /tmp/index_azub.html -T 50;
wget   http://127.0.0.1:8002/html/index.html?noredirect  -O /tmp/index_ten.html -T 90;

port=$(tr -cd 0-9 </dev/urandom | head -c 3);

if [[ ! -f /tmp/index_azub.html ]]; then
sshpass -f /root/passwdazub.txt autossh -M 22$port -y -y -o "ExitOnForwardFailure yes" -N -L 0.0.0.0:25541:127.0.0.1:38282 -R 25581:192.168.8.103:80   -R 25582:192.168.8.106:80  -R 25583:192.168.8.176:80  -R 25541:192.168.8.103:554  -R 25542:192.168.8.106:554 -R 25543:192.168.8.176:554 -L 58000:127.0.0.1:58001 -R 58001:192.168.8.1:80 -R 51681:192.168.8.100:11681 -R 41681:192.168.8.114:11681 rootsu@$(cat /root/azubhost) -p 60922&
fi;

port=$(tr -cd 0-9 </dev/urandom | head -c 3);
if [[ ! -f /tmp/index_ten.html ]]; then
sshpass -f /root/passwdten.txt autossh -M 22$port -y -y -o "ExitOnForwardFailure yes" -N  -R 51681:192.168.8.100:11681 -R 25539:127.0.0.1:25540 -L 0.0.0.0:25540:127.0.0.1:8080 -R 25581:192.168.8.103:80   -R 25582:192.168.8.106:80  -R 25583:192.168.8.176:80  -R 25541:192.168.8.103:554  -R 25542:192.168.8.106:554 -R 25543:192.168.8.176:554 - -R 30022:192.168.8.100:22 -L 8002:127.0.0.1:8001  -R 3389:192.168.8.105:3389 -R 8001:192.168.8.1:80 rootsu@$(cat /root/tenhost) &
fi;
