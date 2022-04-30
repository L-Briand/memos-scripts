#!/bin/sh
apk update
apk upgrade
apk add rclone

# create an empty config to remove notice.
mkdir -p /root/.config/rclone/
touch /root/.config/rclone/rclone.conf

# Vars for service to serve
if [ -z $RCLONE_PATH ];     then RCLONE_PATH="/"; fi
if [ -z $RCLONE_PORT ];     then RCLONE_PORT="21"; fi
if [ -z $RCLONE_USER ];     then RCLONE_USER="admin"; fi
if [ -z $RCLONE_PASSWORD ]; then RCLONE_PASSWORD="admin"; fi

# create a service
cat > /etc/init.d/rclone-serve <<EOF
#!/sbin/openrc-run

name="rclone"
description="Serve ${RCLONE_PATH} directory with rclone"
pidfile="/run/\${RC_SVCNAME}.pid"

command="/usr/bin/rclone"
command_args="serve ftp --vfs-cache-mode minimal --buffer-size 8M --dir-cache-time 30s --user ${RCLONE_USER} --pass ${RCLONE_PASSWORD} --addr :${RCLONE_PORT} ${RCLONE_PATH}"
command_background=true
EOF

# Make it launchable at startup
chmod +x /etc/init.d/rclone-serve
rc-update add rclone-serve default

# start it
rc-service rclone-serve start