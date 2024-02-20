#!/bin/sh

sleep 2

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

WIREGUARD_IP=$(dig +short wireguard)

sed -i "s#wireguard#$WIREGUARD_IP#g" /etc/supervisor/conf.d/supervisord.conf

if [ $UDP_FEC ];then
    sed -i "s#udp_fec#$UDP_FEC#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#udp_fec#2:6#g" /etc/supervisor/conf.d/supervisord.conf
fi

if [ $UDP2RAW_PORT ];then
    sed -i "s#udp2raw_port#$UDP2RAW_PORT#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#udp2raw_port#8585#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
