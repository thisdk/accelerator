#!/bin/sh

sleep 3

TARGET_IP=$(dig +short sing-box)

iptables -t nat -A PREROUTING -p tcp --dport 8585 -j DNAT --to-destination $TARGET_IP:8585

iptables -t nat -A POSTROUTING -d $TARGET_IP -p tcp --dport 8585 -j MASQUERADE

exec "$@"
