#!/bin/bash

### prepare server-side
# Have a file with the keys
# assign server accounts to the keys
# provide means to make more server accounts
# copy keys to .ssh/authorized_keys

### prepare client side
# make available skrip on website
# script contains instructor-home, key - server account-mapping, startup-template.txt
# script (on laptop) finds server username (base on key), and makes startup.sh

instructor=$(head -n1 clients.txt)
instructor=${instructor%%@*}
insthome=$(cat /etc/passwd |grep $instructor |cut -d: -f6)

no_keys=$(cat laptop-keys.txt |wc -l)
no_serv_accs=$(grep "personal_laptop" clients.txt |wc -l)

if [ "$no_keys" -gt "$no_serv_accs" ]; then
    echo -e "More laptop-users' keys then server-accounts\nFix manually, add accounts in clients.txt"
    exit 1
fi

count=0
while read key; do
    keys[$count]="$key"
    count=$((count + 1))
done <<< "$(cat laptop-keys.txt)"

clients=$(cat clients.txt |grep personal_laptop |cut -d" " -f3)
count=0
while read ac; do
    acc[$count]="\"${ac%%@*}\""
    count=$((count + 1))
done <<<"$clients"


count=0
for key in "${keys[@]}"; do
    line[$count]="\"${acc[$count]}\" \"$key\""
    count=$((count + 1))
done

