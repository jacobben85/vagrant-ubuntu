# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.56.103"
  
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end
  
  port1 = 8080

  config.vm.network(:forwarded_port, guest: port1, host: port1)

  config.vm.provision :shell,
    path: "bootstrap.sh",
    run: "always"
end