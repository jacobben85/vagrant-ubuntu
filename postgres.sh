#!/bin/sh -e

echo "Setting up postgres"

export POSTGRES_USER=vagrant
export POSTGRES_DB=vagrant
export POSTGRES_PASS=vagrant

dpkg-reconfigure locales
apt-get install -y postgresql postgresql-contrib 
sudo -u postgres bash -c "psql -c \"CREATE ROLE $POSTGRES_USER WITH SUPERUSER CREATEDB CREATEROLE LOGIN ENCRYPTED PASSWORD '$POSTGRES_PASS'\""
sudo -u postgres createdb -O $POSTGRES_USER $POSTGRES_DB

PG_VERSION=$(psql -V | sed 's/[a-z() ]//gi' | sed 's/...$//g')

PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"
echo "host    all             all             all                     md5" >> "$PG_HBA"
echo "client_encoding = utf8" >> "$PG_CONF"

service postgresql reload
service postgresql restart

# apt-get --assume-yes install postgres-xc-client -qq

echo "Postgres setup complete"