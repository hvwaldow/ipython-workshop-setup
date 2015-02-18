#!/bin/bash

instructor=$(head -n1 clients.txt)
instructor=${instructor%%@*}
insthome=$(cat /etc/passwd |grep $instructor |cut -d: -f6)
tail -n +2 clients.txt | \
    while read client; do
    cl_acc=$(echo $client |cut -f 1 -d " ")
    serv_acc=$(echo $client |cut -f 3 -d " ")
    if [ "$cl_acc" == "personal_laptop" ]; then
	continue
    fi
    echo $cl_acc
    cl_pw=$(echo $client |cut -f 2 -d " ")
    cat startup_template.txt |sed "s,__user__,$serv_acc," \
	|sed "s,__instructor_home__,$insthome,"  >startup_${cl_acc}.sh
    SSHPASS=$cl_pw sshpass -e \
	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
	startup_${cl_acc}.sh ${cl_acc}:startup.sh
    SSHPASS=$cl_pw sshpass -e \
	ssh -n -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
	$cl_acc "chmod u+x startup.sh"
    rm startup_${cl_acc}.sh
done








