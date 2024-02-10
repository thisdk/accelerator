#!/bin/sh

if [ $UDP2RAW_PORT ];then
    sed -i "s#udp2raw_port#$UDP2RAW_PORT#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#udp2raw_port#8686#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
