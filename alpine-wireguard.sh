#!/bin/sh

apk add wireguard-tools

KEY=`wg genkey`

if [ -z "$INTERFACE" ] then 
    INTERFACE="eth0"
fi
if [ -z "$PORT" ] then 
    PORT="51234"
fi

cat > /etc/wireguard/wg0.conf << EOF
[Interface]
ListenPort = $PORT
PrivateKey = $KEY

# Route incoming request from wg interface to INTERFACE
PostUp = iptables -A FORWARD -i %i -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o $INTERFACE -j MASQUERADE
EOF

