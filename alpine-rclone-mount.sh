#!/bin/sh
apk update
apk upgrade
apk add rclone

# Vars for service to serve
if [ -z $RCLONE_MOUNT_PATH ];  then "/mnt"; fi
if [ -z $RCLONE_CONFIG ]; then 
    echo "RCLONE_CONFIG must be provided"
    exit 1
fi

# make sure the mount path is created
mkdir -p "${RCLONE_MOUNT_PATH}"

# create a service
cat > "/etc/init.d/rclone-mount-${RCLONE_CONFIG}" <<EOF
#!/sbin/openrc-run

name="rclone-${RCLONE_CONFIG}"
description="Mount ${RCLONE_CONFIG} with rclone"
pidfile="/run/\${RC_SVCNAME}.pid"

command="/usr/bin/rclone"
command_args="mount ${RCLONE_CONFIG}:/ ${RCLONE_MOUNT_PATH}"
command_background=true
EOF

# Make it launchable at startup
chmod +x "/etc/init.d/rclone-mount-${RCLONE_CONFIG}"
rc-update add "rclone-mount-${RCLONE_CONFIG}" default

# start it
rc-service "rclone-mount-${RCLONE_CONFIG}" start