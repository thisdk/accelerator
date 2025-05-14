#!/bin/sh
set -e

: "${LISTENER_ADDRESS:=0.0.0.0}"
: "${LISTENER_PORT:=8585}"
: "${TARGET_SERVER:=SERVER}"
: "${UDP2RAW_MODE:=faketcp}"

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

if [ "$TARGET_SERVER" = "SERVER" ]; then
    echo "Waiting for DNS resolution..."
    sleep 3
    TARGET_SERVER=$(dig +short sing-box)
    if [ -z "$TARGET_SERVER" ]; then
        echo "Failed to resolve sing-box address"
        exit 1
    fi
fi

RANDOM_PORT=$(shuf -i 10000-60000 -n 1)
echo "Generated random port for internal service: $RANDOM_PORT"

sed -i "s#LISTENER_ADDRESS#$LISTENER_ADDRESS#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#LISTENER_PORT#$LISTENER_PORT#g" /etc/supervisor/conf.d/supervisord.conf  
sed -i "s#TARGET_SERVER#$TARGET_SERVER#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#UDP2RAW_MODE#$UDP2RAW_MODE#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#INTERNAL_PORT#$RANDOM_PORT#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
