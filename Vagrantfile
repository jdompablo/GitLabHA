# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.define "LoadBalancer1" do |lb1|
    lb1.vm.box = "centos/7"
    lb1.vm.host_name = 'loadbalancer1'
    #VirtualBox
    lb1.vm.provider "virtualbox" do |machine|
      # Display the VirtualBox GUI when booting the machine
      #machine.gui = true
      machine.name = "HA_LB_1"
      machine.memory = 512
      machine.cpus = 2
    end
    lb1.vm.network "private_network", ip: "192.168.7.2", virtualbox__intnet: "heartbeat_network"
  end

  config.vm.define "LoadBalancer2" do |lb2|
    lb2.vm.box = "centos/7"
    lb2.vm.host_name = 'loadbalancer2'
    #VirtualBox
    lb2.vm.provider "virtualbox" do |machine|
      # Display the VirtualBox GUI when booting the machine
      #machine.gui = true
      machine.name = "HA_LB_2"
      machine.memory = 512
      machine.cpus = 2
    end
    lb2.vm.network "private_network", ip: "192.168.7.3", virtualbox__intnet: "heartbeat_network"
  end

  # Provisioning the machine with ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provision/playbook-01-vms.yml"
    ansible.host_key_checking = false
    ansible.sudo = true
    ansible.tags = ['common', 'nginx']
  end


  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end
