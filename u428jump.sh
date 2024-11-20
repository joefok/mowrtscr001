#!/bin/bash
echo HelloWorld;

# env file list
# /root/tenhost
# /root/passwdten.txt
# /root/azubhost
# /root/passwdazub.txt

ip428address=$(nslookup info-428 | grep Address | tail -n 1 | cut -d ' ' -f 2)
test -z "$ip428address" && ip428address=127.0.0.1
echo $ip428address

/usr/bin/sshpass -f /root/passwdten.txt ssh -o ExitOnForwardFailure=yes -N -R 8082:127.0.0.1:8080 -L 51681:127.0.0.1:51681  -L 38181:127.0.0.1:8099  -R 8097:127.0.0.1:22 -R 31681:127.0.0.1:11681 -L 127.0.0.1:30022:127.0.0.1:30022  -R 33890:$ip428address:3389 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no rootsu@$(cat /root/tenhost) &
/usr/bin/sshpass -f /root/passwdazub.txt ssh -o ExitOnForwardFailure=yes -N -L 6000:127.0.0.1:6000 -R 33631:127.0.0.1:631  -R 5455:127.0.0.1:11681 -R 38282:127.0.0.1:8080 -L 172.17.0.1:25581:127.0.0.1:25581 -L 172.17.0.1:25582:127.0.0.1:25582 -L 172.17.0.1:25583:127.0.0.1:25583  -L 172.17.0.1:25541:127.0.0.1:25541 -L 172.17.0.1:25542:127.0.0.1:25542 -L 172.17.0.1:25543:127.0.0.1:25543 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no rootsu@$(cat /root/azubhost) -p 60922 &
