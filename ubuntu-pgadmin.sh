#!/bin/sh
apt update
apt upgrade
apt install -y curl gnupg lsb-release

curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | apt-key add
echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update
apt install -y pgadmin4-web 
/usr/pgadmin4/bin/setup-web.sh
