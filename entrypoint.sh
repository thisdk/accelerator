#!/bin/sh

sleep 3

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

WIREGUARD_IP=$(dig +short wireguard)

if [ $UDP_FEC ];then
    sed -i "s#UDP_FEC#$UDP_FEC#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#UDP_FEC#2:4#g" /etc/supervisor/conf.d/supervisord.conf
fi

if [ $LISTENER_ADDR ];then
    sed -i "s#LISTENER_ADDR#$LISTENER_ADDR#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#LISTENER_ADDR#0.0.0.0#g" /etc/supervisor/conf.d/supervisord.conf
fi

if [ $TARGET_ADDR ];then
    sed -i "s#TARGET_ADDR#$TARGET_ADDR#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#TARGET_ADDR#$WIREGUARD_IP:51820#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
