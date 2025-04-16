#!/bin/sh

: ${SIP:=SERVER}

if [ "$SIP" = "SERVER" ]; then
    cp -f /etc/supervisor/conf.d/supervisord-server.conf.backup /etc/supervisor/conf.d/supervisord.conf
else
    cp -f /etc/supervisor/conf.d/supervisord-client.conf.backup /etc/supervisor/conf.d/supervisord.conf
    sed -i "s#SIP#$SIP#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
