#!/bin/bash

make_client_keys() {
    tail -n +2 clients.txt | \
    while read client; do
	cl_acc=$(echo $client |cut -f 1 -d " ")
	if [ "$cl_acc" == "personal_laptop" ]; then
	    continue
	fi
	cl_pw=$(echo $client |cut -f 2 -d " ")
	SSHPASS=$cl_pw sshpass -e \
	    ssh -n -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $cl_acc \
	    "mkdir .ssh; chmod 700 .ssh; ssh-keygen -q -t rsa -N \"\" -f .ssh/id_rsa"
    done
}

collect_client_keys() {
    mkdir tmp
    tail -n +2 clients.txt | \
    while read client; do
	cl_acc=$(echo $client |cut -f 1 -d " ")
	if [ "$cl_acc" == "personal_laptop" ]; then
	    continue
	fi
	cl_pw=$(echo $client |cut -f 2 -d " ")
	SSHPASS=$cl_pw sshpass -e \
	    scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
	    ${cl_acc}:.ssh/id_rsa.pub tmp/${cl_acc}_id.pub
    done
}

mk_server_auth_keys() {
    tail -n +2 clients.txt | \
    while read client; do
	serv_acc=$(echo $client |cut -f 3 -d " ")
	cl_acc=$(echo $client |cut -f 1 -d " ")
	if [ "$cl_acc" == "personal_laptop" ]; then
	    continue
	fi
	uname=${serv_acc%%@*}
	uhome=$(cat /etc/passwd |grep $uname |cut -d: -f6)
	ugroup=$(cat /etc/group |grep ":$(sudo id -g $uname):" |cut -d: -f1)
	target=${uhome}/.ssh/authorized_keys
	sudo mkdir ${uhome}/.ssh
	sudo cp tmp/${cl_acc}_id.pub $target
	sudo chmod 600 $target
	sudo chown ${uname}:${ugroup} $target
	sudo chmod 700 ${uhome}/.ssh
	sudo chown ${uname}:${ugroup} ${uhome}/.ssh
    done
}

rm_tmp() { rm -rf tmp; }

make_client_keys
collect_client_keys
mk_server_auth_keys
rm_tmp
