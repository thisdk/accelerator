#!/bin/sh

: ${SERVER:=SERVER}

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

if [ "$SERVER" = "SERVER" ]; then
    sleep 3
    SERVER_IP=$(dig +short sing-box)
    sed -i "s#sing-box#$SERVER_IP#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#SERVER#$SERVER#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
