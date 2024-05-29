#!/bin/sh

sleep 3

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

SING_BOX_IP=$(dig +short sing-box)

sed -i "s#TARGET_ADDR#$SING_BOX_IP#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
