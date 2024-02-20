#!/bin/sh

sleep 2

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

if [ $UDP2RAW_PORT ];then
    sed -i "s#udp2raw_port#$UDP2RAW_PORT#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#udp2raw_port#8585#g" /etc/supervisor/conf.d/supervisord.conf
fi

WIREGUARD_IP=$(dig +short wireguard)

sed -i "s#wireguard#$WIREGUARD_IP#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
