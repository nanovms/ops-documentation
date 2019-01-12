# -*- mode: ruby -*-
# vi: set ft=ruby :

# This vagrant file is here so we have an easy means of create temporary
# sandbox environments to test various installation and configuration
# documentation.

$aptget_install = <<-SCRIPT
apt-get update && apt-get -y install qemu
SCRIPT

$yum_install = <<-SCRIPT
yum -y update && yum -y install which qemu-kvm qemu-img
SCRIPT

$install_script_url = "https://gist.githubusercontent.com/tijoytom/076dbf088549844692c883539de4260e/raw"

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

  config.vm.define "ubuntu16" do |v|
    v.vm.box = "ubuntu/xenial64"

    v.vm.provision "shell", inline: $aptget_install
    v.vm.provision "shell", privileged: false, path: $install_script_url
  end

  config.vm.define "ubuntu18" do |v|
    v.vm.box = "ubuntu/bionic64"

    v.vm.provision "shell", inline: $aptget_install
    v.vm.provision "shell", privileged: false, path: $install_script_url
  end

  config.vm.define "debian8" do |v|
    v.vm.box = "debian/jessie64"

    v.vm.provision "shell", inline: $aptget_install
    v.vm.provision "shell", privileged: false, path: $install_script_url
  end

  config.vm.define "centos7" do |v|
    v.vm.box = "centos/7"

    v.vm.provision "shell", inline: $yum_install
    v.vm.provision "shell", privileged: false, path: $install_script_url
  end
 
  config.vm.define "fedora28" do |v|
    v.vm.box = "generic/fedora28"

    v.vm.provision "shell", inline: $yum_install
    v.vm.provision "shell", privileged: false, path: $install_script_url
  end
   
end
