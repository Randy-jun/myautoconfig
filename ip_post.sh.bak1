#! /bin/bash

IPDIR=~/.ip
IPHOLD=~/.ip/iphold
LOGFILE=~/.ip/ip.log
TEMP=~/.ip/temp

[ ! -d "$IPDIR" ] && mkdir "$IPDIR"
[ ! -f "$IPHOLD" ] && touch "$IPHOLD"
[ ! -f "$LOGFILE" ] && touch "$LOGFILE"
# echo "" > $IPHOLD
localipv6=$(ip -o addr show | grep -v deprecated | grep ' inet6 [^f:]'| sed -nr 's#^.+? + inet6 ([a-f0-9:]+)/.+? scope global .*? valid_lft ([0-9]+sec) .*#\2 \1#p' | grep 'ff:fe'| sort -nr| head -n1| cut -d' ' -f2);
iphold=$(cat $IPHOLD);
for (( i=0; i<2 ; i=i+1 ))
do
    netcheck=$(curl -s --retry 3 --retry-delay 2 6.ipw.cn 2> /dev/null || curl -s -6 --retry 3 retry-delay 2 api64.ipify.org 2> /dev/null);
    if [ $localipv6 = $netcheck ]; then
        if [[ $iphold != $localipv6 ]]; then
            echo $localipv6 > $IPHOLD
            echo "$(date -R) Network connected, IPv6:$localipv6" | tee -a $LOGFILE | mail -s "Debian yroot IP" yangjun.randy@139.com
            echo "http://[$localipv6]:5678" > $TEMP
            echo "http://[$localipv6]:2283" >> $TEMP
            echo "https://[$localipv6]:9443" >> $TEMP
            echo "https://[$localipv6]:9090" >> $TEMP
            mail -s "Debian yroot IP" yangjun.randy@139.com < $TEMP
            exit 0
        else
            echo "$(date -R) Network connected, IPv6:$localipv6" >> $LOGFILE
            exit 0
        fi
    else
        echo "$(date -R) ipget:$localipv6 check:$netcheck" >> $LOGFILE
        echo "$(date -R) netchaek:$netcheck localIPv6:$localipv6" | tee -a $LOGFILE | mail -s "Debian yroot IP" yangjun.randy@139.com
    fi
    sleep 30s
done
