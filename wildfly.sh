#!/bin/bash

echo "Setting up Wildfly"
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
WILDFLY_CONF="/etc/default/wildfly"
cp /opt/wildfly/bin/init.d/wildfly.conf $WILDFLY_CONF

sed -i "s/# JAVA_HOME=\"\/usr\/lib\/jvm\/default-java\"/JAVA_HOME=\"\/usr\/lib\/jvm\/java-8-oracle\"/" $WILDFLY_CONF
sed -i "s/# JBOSS_HOME=\"\/opt\/wildfly\"/JBOSS_HOME=\"\/opt\/wildfly\"/" $WILDFLY_CONF
sed -i "s/# JBOSS_USER=wildfly/JBOSS_USER=wildfly/" $WILDFLY_CONF
sed -i "s/# JBOSS_MODE=standalone/JBOSS_MODE=standalone/" $WILDFLY_CONF
sed -i "s/# JBOSS_CONFIG=standalone.xml/JBOSS_CONFIG=standalone.xml/" $WILDFLY_CONF
sed -i "s/# STARTUP_WAIT=60/STARTUP_WAIT=60/" $WILDFLY_CONF
sed -i "s/# SHUTDOWN_WAIT=60/SHUTDOWN_WAIT=60/" $WILDFLY_CONF
sed -i "s/# JBOSS_CONSOLE_LOG=\"\/var\/log\/wildfly\/console.log\"/JBOSS_CONSOLE_LOG=\"\/var\/log\/wildfly\/console.log\"/" $WILDFLY_CONF

echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0\"" >> /opt/wildfly/bin/standalone.conf

cp /opt/wildfly/bin/init.d/wildfly-init-debian.sh /etc/init.d/wildfly
chown root:root /etc/init.d/wildfly
chmod +X /etc/init.d/wildfly

update-rc.d wildfly defaults
update-rc.d wildfly enable

mkdir -p /var/log/wildfly

useradd --system --shell /bin/false wildfly

mkdir -p /opt/wildfly/modules/org/postgresql/main
cp $conf_folder/wildfly-conf/postgresql-9.3-1103.jdbc4.jar /opt/wildfly/modules/org/postgresql/main
cp $conf_folder/wildfly-conf/module.xml /opt/wildfly/modules/org/postgresql/main

mv /opt/wildfly/standalone/configuration/standalone.xml /opt/wildfly/standalone/configuration/standalone-old.xml
cp $conf_folder/wildfly-conf/standalone.xml /opt/wildfly/standalone/configuration/standalone.xml
chown -R wildfly:wildfly /opt/wildfly-9.0.2.Final/
chown -R wildfly:wildfly /var/log/wildfly
chown -R wildfly:wildfly /opt/wildfly

service wildfly start

#waiting for boot
while ! /opt/wildfly/bin/jboss-cli.sh -c "ls" 2>&1 >/dev/null ; do echo Waiting for wildfly... ; sleep 1; done

 for proj_war in $conf_folder/deploy/*.war; do
   echo "deploying $proj_war"
   /opt/wildfly/bin/jboss-cli.sh -c "deploy $proj_war"
 done

sudo -u postgres bash -c "psql vagrant -f $conf_folder/dynamic-forms-jndi/table.sql"

curl -X POST --header "Accept: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" -d @$conf_folder/dynamic-forms-jndi/agreement-excels/updated/Authority.xlsx http://localhost:8080/authority_admin_wirs/uploadAgreement
# https://developer.jboss.org/blogs/amartin-blog/2012/02/08/how-to-set-up-a-postgresql-jdbc-driver-on-jboss-7
