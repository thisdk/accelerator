#!/bin/sh

sleep 3

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

: ${TCN:=sing-box}

TARGET_IP=$(dig +short $TCN)

iptables -t nat -A PREROUTING -p tcp --dport 8585 -j DNAT --to-destination $TARGET_IP:8585

iptables -t nat -A POSTROUTING -d $TARGET_IP -p tcp --dport 8585 -j MASQUERADE

if [ $UDP_FEC ]; then
    sed -i "s#UDP_FEC#$UDP_FEC#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#UDP_FEC#1:1,2:2,8:6,20:10#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
