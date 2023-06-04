sudo echo START SECOND TASK: Установить spawn-fcgi и переписать init-скрипт на unit-файл. Дополнить unit-файл apache httpd возможностью запустить несколько инстансов сервера c разными конфигами.
sudo yum install epel-release -y && sudo yum install spawn-fcgi php php-cli mod_fcgid httpd -y
sudo grep 'SOCKET' -P -R -I -l /etc/sysconfig/spawn-fcgi | sudo xargs sed -ri "s/#SOCKET/SOCKET/g"
sudo grep 'OPTIONS' -P -R -I -l /etc/sysconfig/spawn-fcgi | sudo xargs sed -ri "s/#OPTIONS/OPTIONS/g"
sudo cat >> /etc/systemd/system/spawn-fcgi.service << EOF
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n \$OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl start spawn-fcgi
sudo systemctl status spawn-fcgi
sudo grep 'Environment=LANG=C' -P -R -I -l /usr/lib/systemd/system/httpd.service | sudo xargs sed -ri "/Environment=LANG=C/ a EnvironmentFile=/etc/sysconfig/httpd-\%i"
sudo cat >> /etc/sysconfig/httpd-first << EOF
OPTIONS=-f conf/first.conf
EOF
sudo cat >> /etc/sysconfig/httpd-second << EOF
OPTIONS=-f conf/second.conf
EOF
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf
sudo grep '#Listen 12.34.56.78:80' -P -R -I -l /etc/httpd/conf/first.conf | sudo xargs sed -ri "/#Listen 12.34.56.78:80/ a PidFile /var/run/httpd-first.pid"
sudo grep 'Listen 80' -P -R -I -l /etc/httpd/conf/first.conf | sudo xargs sed -ri "s/Listen 80/Listen 8081/g"
sudo grep '#Listen 12.34.56.78:80' -P -R -I -l /etc/httpd/conf/second.conf | sudo xargs sed -ri "/#Listen 12.34.56.78:80/ a PidFile /var/run/httpd-second.pid"
sudo grep 'Listen 80' -P -R -I -l /etc/httpd/conf/second.conf | sudo xargs sed -ri "s/Listen 80/Listen 8082/g"
sudo systemctl start httpd@first
sudo systemctl start httpd@second
sudo ss -tnulp | sudo grep httpd
sudo echo curl -I http://0.0.0.0:8081 
curl -I http://0.0.0.0:8081 | grep Apache
sudo echo curl -I http://0.0.0.0:8082 
curl -I http://0.0.0.0:8082 | grep Apache
sudo echo END SECOND TASK