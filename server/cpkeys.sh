#!/bin/bash
while read client; do
    cl_acc=$(echo $client |cut -f 1 -d " ");
    cl_pw=$(echo $client |cut -f 2 -d " ");
    serv_acc=$(echo $client |cut -f 3 -d " ");
    serv_pw=$(echo $client |cut -f 4 -d " ");
    SSHPASS=$cl_pw sshpass -e ssh -n -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $cl_acc \
	"mkdir .ssh; chmod 700 .ssh; ssh-keygen -q -t rsa -N \"\" -f .ssh/id_rsa"
    SSHPASS=$cl_pw sshpass -e ssh -n -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $cl_acc \
	"SSHPASS=$serv_pw sshpass -e ssh-copy-id -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $serv_acc"
done <clients.txt
