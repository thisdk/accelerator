#!/bin/sh

sleep 3

: ${TCN:=wireguard}
: ${TCP:=51820}
: ${FEC:=1:1,2:2,8:6,20:10}

CIP=$(dig +short $TCN)

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

sed -i "s#CIP#$CIP#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#TCP#$TCP#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#FEC#$FEC#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
