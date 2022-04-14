#!/bin/sh
apk update
apk add bash curl

# fetch software
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
ln -s /usr/local/bin/filebrowser /usr/bin/filebrowser

apk del bash curl

# generate dir to store files
mkdir -p /srv/files/public

# create a service
cat > /etc/init.d/filebrowser <<EOF 
#!/sbin/openrc-run

name="filebrowser"
description=""
pidfile="/run/${RC_SVCNAME}.pid"

command="/usr/bin/filebrowser"
command_args="-a 0.0.0.0 -p 80 -d /srv/files/filebrowser.db -r /srv/files/public/"
command_background=true
EOF

# Make it launchable at startup
chmod +x /etc/init.d/filebrowser
rc-update add filebrowser default

# startit
/etc/init.d/filebrowser start