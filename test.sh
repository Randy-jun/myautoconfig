#! /bin/bash
F=~/.iphold
a=cat $F
echo a
'
for((i=0;i<100;i=i+1))
do
    # echo "1111" > ~/.iphold
    iphold=$(cat ~/.iphold)
    echo $(date) $iphold
    sleep 3s
done
'
