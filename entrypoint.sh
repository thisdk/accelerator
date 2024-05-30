#!/bin/sh

echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -t nat -A PREROUTING -p tcp --dport 8585 -j DNAT --to-destination sing-box:8585

iptables -t nat -A POSTROUTING -p tcp --dport 8585 -j MASQUERADE

exec "$@"
