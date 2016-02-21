#!/bin/bash
apt-get update
apt-get install -y unzip
cp /vagrant/config/consul.conf /etc/init/consul.conf

cd /usr/local/bin
wget https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip -O consul.zip
unzip consul.zip ; rm -f consul.zip

mkdir -p /etc/consul.d /var/consul
cp $1 /etc/consul.d/config.json

exec consul agent -config-file=/etc/consul.d/config.json > /tmp/consul.log 2>&1 &
