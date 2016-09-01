#!/usr/bin/env bash

echo "Installing Java 8"

apt-get --assume-yes update -qq
apt-get install -y python-software-properties debconf-utils
add-apt-repository ppa:webupd8team/java -y
apt-get --assume-yes update -qq
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
apt-get install -y oracle-java8-installer -qq
apt-get install -y oracle-java8-set-default -qq

echo "Java 8 installation complete"

apt-get --assume-yes update -qq
apt-get install -y htop -qq
apt-get install -y maven -qq