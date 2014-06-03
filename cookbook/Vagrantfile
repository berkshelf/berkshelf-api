# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "berkshelf-berkshelf"
  config.vm.box      = "opscode_ubuntu-12.04_provisionerless"
  config.vm.box_url  = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.network :private_network, type: "dhcp"
  config.vm.network :forwarded_port, guest: 80, host: 8084

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
  end

  config.berkshelf.enabled    = true
  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      "recipe[berkshelf-api-server::default]"
    ]
  end
end
