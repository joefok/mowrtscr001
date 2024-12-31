#!/bin/ash
echo HelloWorld;
# attempt to ssh session from console
# SSH CONSOLE MANUALLY ->    sshpass -f /root/ubpwd ssh -y rootsu@$(cat /root/ubhost) -p 60922
# sshpass -f /root/ubpwd autossh -M 41381 rootsu@$(cat /root/ubhost)
# sshpass -f /root/ubpwd autossh -M 41381 -o StrictHostKeyChecking=no rootsu@$(cat /root/ubhost)
# rm /root/.ssh/known_hosts
# rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd autossh -M 41381 -y rootsu@$(cat /root/ubhost);

# for loop
strrev=""
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255
do
  strrev=$strrev" -R $(expr 25000 + $i):10.8.25.$i:554 "
done
echo $strrev
#strrev=""

rm -rf /tmp/index_azub.html;
wget   http://127.0.0.1:39284/  -O /tmp/index_azub.html -T 15;

if [[ ! -f /tmp/index_azub.html ]]; then

# rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd autossh -M 41381 -y -N -R 39285:127.0.0.1:80  -L 0.0.0.0:39286:127.0.0.1:8080  rootsu@$(cat /root/ubhost)&
# rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd autossh -M 41381 -y -N -R 39285:127.0.0.1:80 $strrev -L 0.0.0.0:39286:127.0.0.1:8080  rootsu@$(cat /root/ubhost)&
# rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd autossh -M 41381 -y -N -o ExitOnForwardFailure yes -R 39285:127.0.0.1:80 $strrev -L 0.0.0.0:39286:127.0.0.1:8080  rootsu@$(cat /root/ubhost) -p 60922&
# rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd ssh -y -N -o ExitOnForwardFailure=yes -R 39285:127.0.0.1:80 -R 39282:127.0.0.1:22 -L 0.0.0.0:51722:127.0.0.1:51722 -L 0.0.0.0:8080:127.0.0.1:51782 -L 0.0.0.0:51782:127.0.0.1:51782 rootsu@$(cat /root/ubhost) -p 60922&
# rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd ssh -y -N -o ExitOnForwardFailure=yes -R 39282:127.0.0.1:22 -L 0.0.0.0:631:127.0.0.1:33631 -L 0.0.0.0:51722:127.0.0.1:51722 -L 0.0.0.0:8080:127.0.0.1:51782 -L 0.0.0.0:51782:127.0.0.1:51782 rootsu@$(cat /root/ubhost) -p 60922&
rm /root/.ssh/known_hosts; sshpass -f /root/ubpwd ssh -y -N -o ExitOnForwardFailure=yes -L 0.0.0.0:51080:127.0.0.1:51080 -R 39282:127.0.0.1:22 -L 0.0.0.0:631:127.0.0.1:33631 -L 0.0.0.0:51722:127.0.0.1:51722 -L 0.0.0.0:8080:127.0.0.1:51782 -L 0.0.0.0:51782:127.0.0.1:51782 rootsu@$(cat /root/ubhost) -p 60922&

# sshpass -p p ssh -y -N -o ExitOnForwardFailure=yes  $strrev  u@127.0.0.1 -p 51722&
sshpass -p p ssh -y -N -o ConnectTimeout=10 -o ExitOnForwardFailure=yes  -L 39284:127.0.0.1:39285 -R 39285:127.0.0.1:80 $strrev  u@127.0.0.1 -p 51722&

fi;
