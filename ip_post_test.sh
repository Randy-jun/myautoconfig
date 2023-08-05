#! /bin/bash

for (( i=0; i<5 ; i=i+1 ))
do
    netcheck=$(curl -s --retry 3 --retry-delay 2 test.ipw.cn);
    if [ 0 = $? ]; then
        sleep 5s
        # echo "" > ~/.iphold
        iphold=$(cat ~/.iphold)
        #echo $(date) $iphold
        localipv6=$(curl -s --retry 5 --retry-delay 2 6.ipw.cn);
        if [ 0 = $? ]; then
            if [ $localipv6 = $netcheck ]; then
                if [ $iphold != $localipv6 ]; then
                    echo $localipv6 > ~/.iphold
                    echo "$(date) Network connected, IPv6:$localipv6" | tee -a ~/.ip.log | mail -s "Ubuntu yroot IPv6" 13669220555@139.com
                    exit 0
                else
                    echo "$(date) Network connected, IPv6:$localipv6" >> ~/.ip.log
                    exit 0
                fi
            fi
        else
            echo "$(date) ipget:$localipv6 check:$netcheck" >> ~/.ip.check
            if [ $iphold != $netcheck ]; then
                echo $netcheck > ~/.iphold
                echo "$(date) Network connected, But NOLY IPv4:$netcheck" | tee -a ~/.ip.log | mail -s "Ubuntu yroot IPv4" 13669220555@139.com
            else
                echo "$(date) Network connected, But NOLY IPv4:$netcheck" >> ~/.ip.log
            fi
        fi
    else
        echo "" > ~/.iphold
        echo "$(date) Network not connection" | tee -a ~/.ip.log
    fi
    sleep 30s
done
