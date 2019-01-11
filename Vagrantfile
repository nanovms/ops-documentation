# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # this is added so we can git clone the ops repo if desired. Once the ops
  # repo is open source and public, we can remove this line.
  config.ssh.forward_agent = true

  # Ensure we have access to public internet...
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    v.memory = 4048
    v.cpus = 2
  end

  config.vm.define "ubuntu16" do |ubuntu|
    ubuntu.vm.box = "ubuntu/xenial64"

    ubuntu.vm.provision "shell", inline: "apt-get update && apt-get -y install qemu"
    ubuntu.vm.provision "shell", privileged: false, path: "https://gist.githubusercontent.com/tijoytom/076dbf088549844692c883539de4260e/raw"
  end

  config.vm.define "centos7" do |centos|
    centos.vm.box = "centos/7"

    centos.vm.provision "shell", inline: "yum -y update && yum -y install which qemu-kvm qemu-img"
    centos.vm.provision "shell", privileged: false, path: "https://gist.githubusercontent.com/tijoytom/076dbf088549844692c883539de4260e/raw"
  end
  
end
