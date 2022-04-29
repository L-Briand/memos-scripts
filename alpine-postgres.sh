#!/bin/sh
apk update
apk upgrade
apk add postgresql

# create required postgres directory
mkdir /run/postgresql
chown postgres:postgres /run/postgresql/


# Commands executed by postgres user
cat  > postgres.sh <<EOF
#!/bin/sh
mkdir /var/lib/postgresql/data
chmod 0700 /var/lib/postgresql/data

initdb -D /var/lib/postgresql/data

echo "host all all 0.0.0.0/0 md5" >> /var/lib/postgresql/data/pg_hba.conf
echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf

pg_ctl start -D /var/lib/postgresql/data
EOF

su -c '$pwd/postgres.sh' postgres

# Service at restart
cat > /etc/local.d/postgres-custom.start <<EOF 
#!/bin/sh
su postgres -c 'pg_ctl start -D /var/lib/postgresql/data'
EOF

# launch service at start
chmod +x /etc/local.d/postgres-custom.start
rc-update add local default
openrc
