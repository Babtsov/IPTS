#!/bin/sh
echo 'CONFIGURING NETWORK'
rm /etc/network/interfaces
touch /etc/network/interfaces
cp /root/provisioning_config/provisioning_network_interfaces /etc/network/interfaces
ifdown eth0 && ifup eth0
apk update && apk upgrade

rc-update add networking

# Configure remote administration
apk update && apk upgrade
setup-sshd -c openssh
apk add postgresql-dev python python-dev libpq gcc build-base zlib postgresql postgresql-client

# Setup postgresql
/etc/init.d/postgresql setup
sed "/^[# ]*log_destination/clog_destination = 'syslog'" -i /var/lib/postgresql/9.5/data/postgresql.conf
/etc/init.d/postgresql start
rc-update add postgresql
wget http://initd.org/psycopg/tarballs/PSYCOPG-2-5/psycopg2-2.5.2.tar.gz
tar -xzvf psycopg2-2.5.2.tar.gz
cd psycopg2-2.5.2
python setup.py install
echo 'MODIFY pg_hba.conf'
cp /root/provisioning_config/pg_hba.conf /var/lib/postgresql/9.5/data/pg_hba.conf
echo 'MODIFY postgresql.conf'
cp /root/provisioning_config/postgresql.conf /var/lib/postgresql/9.5/data/postgresql.conf

lbu include /usr/lib/python2.7/
/etc/init.d/postgresql restart
echo nameserver 10.2.0.1 > /etc/resolv.conf
echo 'CONFIGURING ACF modules'
setup-acf
apk add acf-provisioning                      # add the provisioning module to ACF
cp /root/provisioning_config/passwd /etc/acf/ # add an account to ACF so we can login
echo -e "list\nlist" | passwd                 # set the default password of root to "list"
mkdir /etc/ssl/mini_httpd
cp /root/provisioning_config/server.pem /etc/ssl/mini_httpd/
cp /root/provisioning_config/mini_httpd.conf /etc/mini_httpd/

cd /var/www/localhost            # cd into mini_httpd's old home dir
rm -rf htdocs                    # remove it since we are about to symlink it to acf
ln -s /usr/share/acf/www/ htdocs # do the sybolink linking
/etc/init.d/mini_httpd restart