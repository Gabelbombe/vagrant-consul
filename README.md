# README

This repository contains files for provisioning a Consul cluster using Vagrant. The cluster is intended for use as part of development or testing and allows you to run a cluster of 3 Consul servers plus a Consul client which runs the Consul Web UI.

Much of the content was derived from a blog post by Justin Ellingwood, [How to Configure Consul in a Production Environment on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-configure-consul-in-a-production-environment-on-ubuntu-14-04). There are diffences between Justin's implementation and that given here with the key difference being that Vagrant is used to provision the cluster with a JSON template. The virtual machines are also based on the `hashicorp/precise64` box, a packaged standard Ubuntu 12.04 LTS 64-bit box.

## Prerequisites

You will need to have installed Vagrant and VirtualBox.

## Usage

Once you have downloaded the files open a command prompt and change to the directory containing the Vagrantfile. To start the bootstrap server type the following:

`vagrant up node1`

Thereafter you can start the other 2 servers:

    vagrant up node2
    vagrant up node3

The client instance is started in much the same way:

`vagrant up client`

For full details please refer to the blog posts mentioned above.

### Accessing the Consul Web UI

Once the cluster is up-and-running you will be able to access the Consul Web UI from a browser running on your host workstation by going to the following URL: [http://172.20.20.40:8500/ui/](http://http://172.20.20.40:8500/ui/).
