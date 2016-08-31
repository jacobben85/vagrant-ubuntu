#!/usr/bin/env bash

echo "Prepping shell scripts"

apt-get --assume-yes update -qq
apt-get install -y python-software-properties debconf-utils -qq
add-apt-repository ppa:webupd8team/java -y -qq
apt-get --assume-yes update -qq
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
apt-get install -y oracle-java8-installer -qq
apt-get install -y oracle-java8-set-default -qq

echo "Shell scripts completed"