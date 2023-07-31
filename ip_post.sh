#! /bin/bash

ipv6_get(){
    ip -6 addr | grep "inet6 24" | awk -F " " '{ print $2 }' | awk -F"/" '{ print $1 }'
}

ipv6_net_get(){
    curl -s 6.ipw.cn
}

net_get(){
    curl -s test.ipw.cn
}
echo "$(date)    $(ipv6_get)   $(ipv6_net_get)  $(net_get)" | mail -s "Ubuntu yroot IPv6" 13669220555@139.com
