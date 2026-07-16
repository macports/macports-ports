#!/bin/bash

# Count attacks on the PF firewall

num=0

res=$(sudo pfctl -t bruteforce -Ts 2>&1 | sed -e 1,2d | wc -l)
num=$((num + res))

res=$(sudo pfctl -a blockips -t compromised_ips -Ts -v 2>&1 | sed -e 1,2d | egrep -e 'Packets: [^0]' | wc -l)
num=$((num + res))

res=$(sudo pfctl -a blockips -t dshield_block_ip -Ts -v 2>&1 | sed -e 1,2d | egrep -e 'Packets: [^0]' | wc -l)
num=$((num + res))

res=$(sudo pfctl -a blockips -t emerging_threats -Ts -v 2>&1 | sed -e 1,2d | egrep -e 'Packets: [^0]' | wc -l)
num=$((num + res))

echo $num
