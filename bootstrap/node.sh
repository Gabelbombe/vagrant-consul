#!/bin/bash
apt-get update
apt-get install -y unzip
cp /vagrant/consul.conf /etc/init/consul.conf
cd /usr/local/bin
wget https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip
unzip *.zip
rm *.zip
mkdir -p /etc/consul.d
mkdir /var/consul
cp $1 /etc/consul.d/config.json
exec consul agent -config-file=/etc/consul.d/config.json
