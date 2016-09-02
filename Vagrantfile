# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.56.103"
  config.vm.hostname = "ecfd.vagrant-local.jbj"
  
  config.vm.provider "virtualbox" do |v|
    v.memory = 3072
    v.cpus = 2
  end
  
  port1 = 9443
  port2 = 8280
  port3 = 8643
  port4 = 8205
  port5 = 5432
  port6 = 8080

  config.vm.network(:forwarded_port, guest: port1, host: port1)
  config.vm.network(:forwarded_port, guest: port2, host: port2)
  config.vm.network(:forwarded_port, guest: port3, host: port3)
  config.vm.network(:forwarded_port, guest: port4, host: port4)
  config.vm.network(:forwarded_port, guest: port5, host: port5)
  config.vm.network(:forwarded_port, guest: port6, host: port6)

  config.vm.provision "shell",
    path: "bootstrap.sh"
	
  config.vm.provision "shell",
    path: "postgres.sh"

  config.vm.provision "shell",
    path: "wildfly.sh",
    args: "/vagrant"
	
  config.vm.provision "shell",
    path: "startup.sh",
	run: "always"
end