#!/bin/sh

sleep 2

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

WIREGUARD_IP=$(dig +short wireguard)

if [ $UDP_FEC ];then
    sed -i "s#udp_fec#$UDP_FEC#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#udp_fec#2:6#g" /etc/supervisor/conf.d/supervisord.conf
fi

if [ $TARGET_ADDR ];then
    sed -i "s#wireguard#$TARGET_ADDR#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#wireguard#$WIREGUARD_IP#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
