# -*- mode: ruby -*-
# vi: set ft=ruby :
#^syntax detection
nodes_config = (JSON.parse(File.read("config/nodes.json"))) ['nodes']

Vagrant.configure(2) do |config|
  config.vm.box = "hashicorp/precise64"

  config.ssh.forward_agent = true

  nodes_config.each do | node |
   node_name   = node[0]
   node_values = node[1]

   config.vm.define node_name do | config |
     config.vm.hostname = node_name

     ports = node_values['ports']
     ports.each do | port |
       config.vm.network :forwarded_port,
         host:  port[':host'],
         guest: port[':guest'],
         id:    port[':id']
     end

     config.vm.provider :virtualbox do | vb |
       #vb.gui = true
       vb.customize ["modifyvm", :id, "--memory",  node_values[':memory']]
       vb.customize ["modifyvm", :id, "--name",    node_name]
     end

     config.vm.network :private_network, ip: node_values[':ip']

     config.vm.provision "shell" do | script |
        script.path = node_values[':bootstrap']
        script.args = node_values[':config']
     end

    end
   end
end
