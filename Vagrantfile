# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX = "centos/7"

LOCALHOST = "127.0.0.1"
HOSTNAME = "nginx.local"

Vagrant.configure("2") do |config|  
  config.vm.box = "#{BOX}"
  config.vm.box_check_update = false
  config.vm.hostname = "#{HOSTNAME}"
  config.vm.provider "vmware_desktop" do |vmware|
    vmware.linked_clone = false
    vmware.gui = false
    vmware.allowlist_verified = true
    vmware.vmx["numvcpus"] = "1"
    vmware.vmx["memsize"] = "512"
    config.vm.network "forwarded_port", guest: 80, host: 80, host_ip: "127.0.0.1"
    config.vm.network "forwarded_port", guest: 7001, host: 7001, host_ip: "127.0.0.1"
  end
  # config.vm.provision "INSTALL_NGINX", type: "shell", path: "./install_nginx.sh"
  # config.vm.provision "INSTALL_CUSTOM_NGINX_LUA", type: "shell", path: "./install_custom_nginx_lua.sh"
end
