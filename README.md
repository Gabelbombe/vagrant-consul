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


### Notes

Some basic test cases from your local.


##### DNS interface.

Let's look for an external search service that we hypothetically depend on but which we have not yet added to consul.
```
  ehime:Vagrant Consul$ dig @172.20.20.20 -p 8600 search.service.consul.

  ; <<>> DiG 9.8.3-P1 <<>> @172.20.20.20 -p 8600 search.service.consul.
  ; (1 server found)
  ;; global options: +cmd
  ;; Got answer:
  ;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 49383
  ;; flags: qr aa rd; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 0
  ;; WARNING: recursion requested but not available

  ;; QUESTION SECTION:
  ;search.service.consul.		IN	A

  ;; AUTHORITY SECTION:
  consul.			0	IN	SOA	ns.consul. postmaster.consul. 1453193803 3600 600 86400 0

  ;; Query time: 6 msec
  ;; SERVER: 172.20.20.20#8600(172.20.20.20)
  ;; WHEN: Tue Jan 19 22:15:03 2016
  ;; MSG SIZE  rcvd: 107
```

Now lets add the external service to consul.
```
  curl -X PUT -d '{"Datacenter": "dc1", "Node": "google", "Address": "www.google.com", "Service": {"Service": "search", "Port": 80}}' http://172.20.20.20:8500/v1/catalog/register
  curl -X PUT -d '{"Datacenter": "dc1", "Node": "bing", "Address": "www.bing.com", "Service": {"Service": "search", "Port": 80}}' http://172.20.20.20:8500/v1/catalog/register
```

If we now use query consul via DNS, we get two results.
```
  ehime:Vagrant Consul$ dig @172.20.20.10 -p 8600 search.service.consul.

  ; <<>> DiG 9.8.3-P1 <<>> @172.20.20.10 -p 8600 search.service.consul.
  ; (1 server found)
  ;; global options: +cmd
  ;; Got answer:
  ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 59334
  ;; flags: qr aa rd; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 0
  ;; WARNING: recursion requested but not available

  ;; QUESTION SECTION:
  ;search.service.consul.		IN	A

  ;; ANSWER SECTION:
  search.service.consul.	0	IN	CNAME	www.google.com.
  search.service.consul.	0	IN	CNAME	www.bing.com.

  ;; Query time: 2 msec
  ;; SERVER: 172.20.20.10#8600(172.20.20.10)
  ;; WHEN: Tue Jan 19 22:27:20 2016
  ;; MSG SIZE  rcvd: 135
```

Given that high level service health checking is a part of consul, it is simple
to make this a highly available constantly expanding/shrinking node pool.
