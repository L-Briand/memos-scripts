#!/bin/sh
apk update
apk add bash curl

# fetch software
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
ln -s /usr/local/bin/filebrowser /usr/bin/filebrowser

apk del bash curl

# generate dir to store files
mkdir -p /etc/filebrowser/
mkdir -p /srv/files/

# init database
filebrowser config init \
    -d /etc/filebrowser/filebrowser.db \
    -r /srv/files \
    -a 0.0.0.0 \
    -p 80 \
    -l /var/run/filebrowser.log

# Set user that can't be deleted because of id 1.
filebrowser users add admin admin --perm.admin -d /etc/filebrowser/filebrowser.db 

# create a service
cat > /etc/init.d/filebrowser <<EOF 
#!/sbin/openrc-run

name="filebrowser"
description=""
pidfile="/run/\${RC_SVCNAME}.pid"

command="/usr/bin/filebrowser"
command_args="-d /etc/filebrowser/filebrowser.db"
command_background=true
EOF

# Make it launchable at startup
chmod +x /etc/init.d/filebrowser
rc-update add filebrowser default

# start it
/etc/init.d/filebrowser start