sudo echo Disabling SElinux and firewalld.
sudo setenforce 0
sudo grep 'SELINUX=enforcing' -P -R -I -l /etc/selinux/config | sudo xargs sed -ri "s/SELINUX=enforcing/SELINUX=disabled/g"
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld
sudo echo Completed.