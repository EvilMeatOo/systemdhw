sudo echo START FIRST TASK: Написать service!
sudo cat >> /etc/sysconfig/watchlog << EOF
# Configuration file for my watchlog service
# Place it to /etc/sysconfig

# File and word in that file that we will be monit
WORD="ALERT"
LOG=/var/log/watchlog.log
EOF
sudo cat >> /var/log/watchlog.log << EOF
66.249.65.159 - - [06/Nov/2014:19:10:38 +0600] "GET /news/53f8d72920ba2744fe873ebc.html HTTP/1.1" 404 177 "-" "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
66.249.65.3 - - [06/Nov/2014:19:11:24 +0600] "GET /?q=%E0%A6%AB%E0%A6%BE%E0%A7%9F%E0%A6%BE%E0%A6%B0 HTTP/1.1" 200 4223 "-" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" "ALERT"
66.249.65.62 - - [06/Nov/2014:19:12:14 +0600] "GET /?q=%E0%A6%A6%E0%A7%8B%E0%A7%9F%E0%A6%BE HTTP/1.1" 200 4356 "-" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
EOF
sudo cat >> /opt/watchlog.sh << EOF
#!/bin/bash

WORD=\$1
LOG=\$2
DATE=\`date\`

if grep \$WORD \$LOG &> /dev/null
then
logger "\$DATE: I found word, Master!"
else
exit 0
fi
EOF
sudo chmod +x /opt/watchlog.sh  
sudo cat >> /usr/lib/systemd/system/watchlog.service << EOF
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh \$WORD \$LOG
EOF
sudo cat >> /usr/lib/systemd/system/watchlog.timer << EOF
[Unit]
Description=Run watchlog script every 5 second

[Timer]
# Run every 5 second
OnUnitActiveSec=5
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl restart watchlog.timer
sudo systemctl restart watchlog.service
sudo echo Please wait 30 seconds.
sudo sleep 30
sudo less /var/log/messages | sudo grep Master
sudo echo END FIRST TASK
