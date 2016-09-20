#!/bin/sh -e

export JAVA_HOME="/usr/lib/jvm/java-8-oracle"

echo "Added JAVA_HOME"

sudo -H -u vagrant bash -c "touch ~/aps.log"
sudo -H -u vagrant bash -c "touch ~/pep.log"

sudo -H -u vagrant bash -c "nohup sh /vagrant/aps/aps-express-edition/start_server.sh &> ~/aps.log &"
sudo -H -u vagrant bash -c "java -jar /vagrant/pep/target/pep.jar &> ~/pep.log &"
