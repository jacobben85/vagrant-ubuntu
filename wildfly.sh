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
cp $conf_folder/wildfly-conf/wildfly.conf /etc/default/wildfly

echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0\"" >> /opt/wildfly/bin/standalone.conf

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

#    <xa-datasource
#            jndi-name="java:jboss/datasources/authority_admin_wirs"
#            pool-name="authority_admin_wirs"
#            enabled="true">
#        <xa-datasource-property name="url">jdbc:postgresql://localhost:5432/vagrant</xa-datasource-property>
#        <driver>postgres</driver>
#        <xa-pool>
#            <min-pool-size>10</min-pool-size>
#            <max-pool-size>20</max-pool-size>
#            <prefill>true</prefill>
#        </xa-pool>
#        <security>
#            <user-name>vagrant</user-name>
#            <password>vagrant</password>
#        </security>
#    </xa-datasource>
#    <drivers>
#        <driver name="postgres" module="org.postgresql">
#            <xa-datasource-class>org.postgresql.xa.PGXADataSource</xa-datasource-class>
#        </driver>
#    </drivers>

# https://developer.jboss.org/blogs/amartin-blog/2012/02/08/how-to-set-up-a-postgresql-jdbc-driver-on-jboss-7
#<?xml version="1.0" encoding="UTF-8"?>
#<module xmlns="urn:jboss:module:1.0" name="org.postgresql">
# <resources>
# <resource-root path="postgresql-9.3-1103.jdbc4.jar"/>
# </resources>
# <dependencies>
# <module name="javax.api"/>
# <module name="javax.transaction.api"/>
# </dependencies>
#</module>
