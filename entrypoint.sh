#!/bin/sh

sleep 3

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

TARGET_IP=$(dig +short sing-box)

sed -i "s#TARGET_ADDR#$TARGET_IP#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
