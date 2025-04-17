#!/bin/sh

: ${SIP:=SERVER}

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

if [ "$SIP" = "SERVER" ]; then
    sleep 3
    IP_S=$(dig +short sing-box)
    sed -i "s#sing-box#$IP_S#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#SERVER_IP#$SIP#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
