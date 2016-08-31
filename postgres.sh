#!/bin/sh -e

POSTGRES_USER=root
POSTGRES_DB=myapp
POSTGRES_PASS=pass

apt-get install -y postgresql
#sudo -u postgres createuser -P $POSTGRES_USER
#sudo -u postgres createdb -O $POSTGRES_USER $POSTGRES_DB
#service postgresql reload