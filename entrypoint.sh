#!/bin/sh

sleep 3

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

: ${TCN:=sing-box}

: ${TCP:=8585}

TARGET_IP=$(dig +short $TCN)

iptables -t nat -A PREROUTING -p tcp --dport $TCP -j DNAT --to-destination $TARGET_IP:$TCP

iptables -t nat -A POSTROUTING -d $TARGET_IP -p tcp --dport $TCP -j MASQUERADE

if [ $UDP_FEC ]; then
    sed -i "s#UDP_FEC#$UDP_FEC#g" /etc/supervisor/conf.d/supervisord.conf
else
    sed -i "s#UDP_FEC#1:3,2:4,8:6,20:10#g" /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
