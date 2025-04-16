#!/bin/sh

: ${SIP:=SERVER}

if [ "$SIP" = "SERVER" ]; then
    sleep 3
    IP_S=$(dig +short sing-box)
    cp -f /etc/supervisor/conf.d/supervisord-server.conf.backup /etc/supervisor/conf.d/supervisord.conf
    sed -i "s#sing-box#$IP_S#g" /etc/supervisor/conf.d/supervisord.conf
else
    cp -f /etc/supervisor/conf.d/supervisord-client.conf.backup /etc/supervisor/conf.d/supervisord.conf
    sed -i "s#SERVER_IP#$SIP#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
