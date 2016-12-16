#!/bin/bash

for proj_ear in /vagrant/tmp/*.ear; do
    echo "Starting deployment for $proj_ear"
    BASENAME=`basename ${proj_ear}`
    IS_DEPLOYED=`sudo /opt/wildfly/bin/jboss-cli.sh -c "deployment-info --name=$BASENAME" | wc -l`

    if [ ${IS_DEPLOYED} -gt 1 ]
    then
        echo "Un-deploying $BASENAME"
        sudo /opt/wildfly/bin/jboss-cli.sh -c "undeploy $BASENAME"
    fi

    echo "Deploying $BASENAME"
    sudo /opt/wildfly/bin/jboss-cli.sh -c "deploy $proj_ear"

    echo "Completed deployment for $proj_ear"
done
