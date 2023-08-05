#! /bin/bash

netcheck=$(curl -m 15 -s test.ipw.cn);
# echo $netcheck
if [ 0 = $? ]; then
    sleep 3
    localipv6=$(curl -m 15 -s 6.ipw.cn);
    if [ 0 = $? ]; then
        if [ $localipv6 = $netcheck ]; then
            echo $localipv6 > ~/.iphold
            echo "$(date) Network connected, IPv6:$localipv6" | tee -a ~/.ip.log | mail -s "Ubuntu yroot IPv6" 13669220555@139.com
        fi
    else
        echo "$(date) ipget:$localipv6 check:$netcheck" >> ~/.ip.check
        echo "$(date) Network connected, But NOLY IPv4:$netcheck" | tee -a ~/.ip.log | mail -s "Ubuntu yroot IPv4" 13669220555@139.com
    fi
else
    echo "$(date) Network not connection" | tee -a ~/.ip.log
fi
