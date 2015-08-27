# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'
Vagrant.require_version '>= 1.5.0'


Vagrant.configure("2") do |config|
  config.vm.box = "trusty32"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  config.vm.network "forwarded_port", guest: 5004, host: 5004
  config.vm.provision "shell", path: "provision.sh"
end
