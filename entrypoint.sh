#!/bin/sh
set -e

: "${l:=0.0.0.0}"
: "${p:=8585}"
: "${s:=SERVER}"
: "${m:=faketcp}"

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

RANDOM_PORT=$(shuf -i 10000-60000 -n 1)
echo "Generated random port for internal service: $RANDOM_PORT"

sed -i "s#LISTENER_ADDRESS#$l#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#LISTENER_PORT#$p#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#TARGET_SERVER#$s#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#UDP2RAW_MODE#$m#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#INTERNAL_PORT#$RANDOM_PORT#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
