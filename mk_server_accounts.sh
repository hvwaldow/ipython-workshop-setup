#!/bin/bash

create_server_users() {
    instructor=$(head -n1 clients.txt)
    instructor=${instructor%%@*}
    unames="$instructor"
    particip=$(cat clients.txt |tail -n +2 |cut -d" " -f3)
    while read line; do
	unames="$unames ${line%%@*}"
    done <<<"$particip"
    unames=$(echo $unames |tr " " "\n" |sort |uniq |tr "\n" " ")
    for unam in $unames; do
	sudo /usr/sbin/useradd -m $unam
    done
    sleep 1
    sudo su -c 'cd; mkdir pyws' $instructor
}

install_virtenv() {
    instructor=$(head -n1 clients.txt)
    instructor=${instructor%%@*}
    insthome=$(cat /etc/passwd |grep $instructor |cut -d: -f6)
    instgroup=$(cat /etc/group |grep ":$(sudo id -g $instructor):" |cut -d: -f1)
    cat << EOF >install.tmp
cd
cd pyws
virtualenv -p /usr/bin/python2.7 venv # check whether path to system Python is correct
cd venv
wget https://raw.githubusercontent.com/C2SM/ipython-workshop-setup/master/requirements.txt
source bin/activate
for pack in \$(cat requirements.txt); do pip install \$pack; done
deactivate
cd
EOF
sudo mv install.tmp ${insthome}/pyws/install_virtenv.sh
sudo chmod 711 ${insthome}/pyws/install_virtenv.sh
sudo chown $instructor:$instgroup ${insthome}/pyws/install_virtenv.sh
sudo su -c "cd; cd pyws; ./install_virtenv.sh" $instructor
}

create_server_users
install_virtenv
