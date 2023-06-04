# -*- mode: ruby -*- 
# vi: set ft=ruby : vsa
Vagrant.configure(2) do |config| 
 config.vm.box = "generic/centos8s" 
 config.vm.box_version = "4.2.16" 
 config.vm.synced_folder ".", "/vagrant", disabled: true
 config.vbguest.auto_update = false
 config.vm.provider "virtualbox" do |v| 
 v.memory = 256 
 v.cpus = 1 
 end 
 config.vm.define "sys" do |sys| 
 sys.vm.hostname = "systemd" 
 sys.vm.provision "shell", path: "systemd1_script.sh" 
 sys.vm.provision "shell", path: "systemd2_script.sh" 
 sys.vm.provision "shell", path: "systemd3_script.sh" 
 end 
end 

