#!/bin/sh
set -e

: "${LISTENER_ADDRESS:=0.0.0.0}"
: "${LISTENER_PORT:=8585}"
: "${TARGET_SERVER:=SERVER}"
: "${UDP2RAW_MODE:=faketcp}"
: "${KCP_DS:=2}"
: "${KCP_PS:=4}"

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

if [ "$TARGET_SERVER" = "SERVER" ]; then
    sleep 3
    TARGET_SERVER=$(dig +short sing-box)
fi

RANDOM_PORT=$(shuf -i 10000-60000 -n 1)

sed -i "s#LISTENER_ADDRESS#$LISTENER_ADDRESS#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#LISTENER_PORT#$LISTENER_PORT#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#TARGET_SERVER#$TARGET_SERVER#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#UDP2RAW_MODE#$UDP2RAW_MODE#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#INTERNAL_PORT#$RANDOM_PORT#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#KCP_DS#$KCP_DS#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#KCP_PS#$KCP_PS#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
