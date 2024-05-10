#!/bin/sh

sleep 3

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

if [ $LISTEN_ADDR ];then
    sed -i "s#LISTEN_ADDR#$LISTEN_ADDR#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#LISTEN_ADDR#0.0.0.0#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
