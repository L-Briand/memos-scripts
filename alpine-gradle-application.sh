#!/bin/sh
apk update
apk upgrade
apk add openjdk17-jre openssh-client openssh-server openntpd netcat-openbsd

rc-update add openntpd default
rc-service openntpd start

AUTHORIZED_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDN0BeE70ayfzzrU2kjMfsdaAlV8ol1LvVHuF1aPl9Ex2Cgb6Cs2YNzEPEbYHTP8Th1vUJ3cjWk9TcHR6PdcgPbHRPa2Xd+VP7R5xeOwrhleQYegFqLBIoElNhuZtSHbqLh4n2j+0TYmOn++HEIHE6T0a5Y0+5rN4YhbufTsdNpMpVdggWUofXuVPAMynv+VS3wHbuVgDBV59bTVnvCEQFyBO0UYSQKXbkyFAxkAoiDSYg4j1t4gZwVvhQ/P5HxLtkL0DoojZiSn2QZQjR10ftklLyjcBC/kELyR8wwFO26hyIqTTv563Qv+tK8r3ZsE/EeC/jaIzWvNWRqPk1Vc/TcTAv6PfYGkbWKILePpV5xtYU+2X4MOLNZFlKG+eObWk/hS9NvE93zf4TwpJoaEY8+BgZZesRJj+4DmlFcR8q+jyifMyleQY4ZReAETpuBCt7aUN01d3r7OiyD0L3XKDSjwKvN/QV1orU6UxF2Rta8F9ZiLGkWT3SpvjEmvi9Jd3E= root@gitlab-runner-local-1"
echo $AUTHORIZED_KEY >> ~/.ssh/authorized_keys

rc-service sshd start
rc-update add sshd

mkdir /var/log/application/
mkdir /var/application/

# upload you app into /opt/application/

# create a service
cat > /etc/init.d/application <<EOF 
#!/sbin/openrc-run

name="Application"
description="Java application generated by gradle"
pidfile="/run/\${RC_SVCNAME}.pid"

command="/opt/application/bin/application"
command_args=""
command_background=true
EOF

chmod +x /etc/init.d/application
rc-update add application

rc-service application start