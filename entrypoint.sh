#!/bin/sh
set -e

: "${SERVER:=SERVER}"
: "${IPV4_MODE:=faketcp}"
: "${IPV6_MODE:=udp}"

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

if [ "$SERVER" = "SERVER" ]; then
    echo "Waiting for DNS resolution..."
    sleep 3
    SERVER=$(dig +short sing-box)
    if [ -z "$SERVER" ]; then
        echo "Failed to resolve sing-box address"
        exit 1
    fi
fi

sed -i "s#SERVER#$SERVER#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#IPV4_MODE#$IPV4_MODE#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#IPV6_MODE#$IPV6_MODE#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
