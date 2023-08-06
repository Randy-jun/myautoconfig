#! /bin/bash

IPDIR=~/.ip
IPHOLD=~/.ip/iphold
LOGFILE=~/.ip/ip.log
[ ! -d "$IPDIR" ] && mkdir "$IPDIR"
[ ! -f "$IPHOLD" ] && touch "$IPHOLD"
[ ! -f "$LOGFILE" ] && touch "$LOGFILE"
# echo "" > $IPHOLD

for (( i=0; i<5 ; i=i+1 ))
do
    netcheck=$(curl -s --retry 3 --retry-delay 2 test.ipw.cn);
    if [ 0 = $? ]; then
        sleep 5s
        iphold=$(cat $IPHOLD)
        echo $(date) $iphold
        localipv6=$(curl -s --retry 5 --retry-delay 2 6.ipw.cn);
        if [ 0 = $? ]; then
            if [ $localipv6 = $netcheck ]; then
                if [[ $iphold != $localipv6 ]]; then
                    echo $localipv6 > $IPHOLD
                    echo "$(date) Network connected, IPv6:$localipv6" | tee -a $LOGFILE | mail -s "Ubuntu yroot IPv6" 13669220555@139.com
                    echo "http://[$localipv6]:10086" | mail -s "Ubuntu yroot IPv6" 13669220555@139.com
                    exit 0
                else
                    echo "$(date) Network connected, IPv6:$localipv6" >> $LOGFILE
                    exit 0
                fi
            fi
        else
            echo "$(date) ipget:$localipv6 check:$netcheck" >> $LOGFILE
            if [ $iphold != $netcheck ]; then
                echo $netcheck > $IPHOLD
                echo "$(date) Network connected, But NOLY IPv4:$netcheck" | tee -a $LOGFILE | mail -s "Ubuntu yroot IPv4" 13669220555@139.com
            else
                echo "$(date) Network connected, But NOLY IPv4:$netcheck" >> $LOGFILE
            fi
        fi
    else
        echo "" > $IPHOLD
        echo "$(date) Network not connection" | tee -a $LOGFILE
    fi
    sleep 30s
done
