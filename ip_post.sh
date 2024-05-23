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
for (( i=0; i<2 ; i=i+1 ))
do
  iphold=$(cat $IPHOLD);
  if [[ $iphold != $localipv6 ]]; then
      echo $localipv6 > $IPHOLD
       # echo "$(date -R) Network connected, IPv6:$localipv6" | tee -a $LOGFILE | mail -s "Debian yroot IP" yangjun.randy@139.com
       echo "$(date -R) Network connected, IPv6:$localipv6" | tee -a $LOGFILE
      if [ -n $localipv6 ]; then
          echo $localipv6 > $TEMP
          echo "http://[$localipv6]:5678" >> $TEMP
          echo "http://[$localipv6]:2283" >> $TEMP
          echo "http://[$localipv6]:7575" >> $TEMP
          echo "http://[$localipv6]:8123" >> $TEMP
          echo "https://[$localipv6]:9443" >> $TEMP
          echo "https://[$localipv6]:9090" >> $TEMP
          mail -s "Debian yroot IP" yangjun.randy@139.com < $TEMP
      else
          exit 0
      fi
      exit 0
  else
      echo "$(date -R) Network connected, IPv6:$localipv6" >> $LOGFILE
      exit 0
  fi
  sleep 30s
done
