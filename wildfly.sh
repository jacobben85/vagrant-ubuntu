#!/bin/bash

# reference http://developer-should-know.com/post/134394533957/how-to-install-wildfly-on-ubuntu

conf_folder=$1

function print_help() {
  echo "Usage: $0 conf_folder"
}

if [ -z "$conf_folder" ]; then
  print_help
  exit 1
fi

#install vim
apt-get update
apt-get install -y vim

#install wildfly
cd /tmp
wget http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.zip
unzip wildfly-9.0.2.Final.zip -d /opt/
ln -s /opt/wildfly-9.0.2.Final /opt/wildfly
cp $conf_folder/wildfly-conf/wilfly.conf /etc/default/wildfly

cp /opt/wildfly/bin/init.d/wildfly-init-debian.sh /etc/init.d/wildfly
chown root:root /etc/init.d/wildfly
chmod +X /etc/init.d/wildfly

sudo update-rc.d wildfly defaults
sudo update-rc.d wildfly enable

sudo mkdir -p /var/log/wildfly

sudo useradd --system --shell /bin/false wildfly

sudo chown -R wildfly:wildfly /opt/wildfly-9.0.2.Final/
sudo chown -R wildfly:wildfly /opt/wildfly
sudo chown -R wildfly:wildfly /var/log/wildfly

sudo service wildfly start

#waiting for boot
while ! /opt/wildfly/bin/jboss-cli.sh -c "ls" 2>&1 >/dev/null ; do echo Waiting for wildfly... ; sleep 1; done

#deploy all projects found in deploy/
# for proj_war in $conf_folder/deploy/*.war; do
#   echo "deplying $proj_war"
#   /opt/wildfly/bin/jboss-cli.sh -c "deploy $proj_war"
# done
