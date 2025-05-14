#!/bin/sh
set -e

: "${LISTENER:=0.0.0.0:8585}"
: "${SERVER:=SERVER}"
: "${MODE:=faketcp}"

RANDOM_PORT=$(shuf -i 10000-60000 -n 1)
echo "Generated random port for internal service: $RANDOM_PORT"

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

sed -i "s#RANDOM_PORT#$RANDOM_PORT#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#LISTENER#$LISTENER#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#SERVER#$SERVER#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#MODE#$MODE#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
