#!/bin/sh

if [ $(id -u) -ne 0 ]; then
    echo "Must be run as root"
    exit 1
fi

lxc init images:ubuntu/xenial/i386 xenial
lxc init images:ubuntu/zesty/i386  zesty
lxc init images:ubuntu/artful/i386 artful

lxc init images:debian/stretch/i386 stretch
lxc init images:debian/jessie/i386  jessie

lxc init images:centos/7/amd64 centos7

# See https://github.com/systemd/systemd/issues/719#issuecomment-176168379
lxc config set jessie 'security.privileged' true

for i in xenial zesty artful stretch jessie centos7; do
    lxc start $i
done

cat > servers <<EOF
[containers]
xenial  ansible_connection=lxd
zesty   ansible_connection=lxd
artful  ansible_connection=lxd

stretch ansible_connection=lxd
jessie  ansible_connection=lxd

centos7 ansible_connection=lxd
EOF

mkdir -p ../group_vars
cat > ../group_vars/all << EOF
---
skip_ssl: True
EOF

sleep 15
for i in xenial zesty artful stretch jessie centos7; do
    while [ -z "$(lxc list $i -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}')" ]; do
        sleep 1;
    done
done

for i in xenial zesty artful stretch jessie; do
    lxc exec $i -- apt-get -qq update
    lxc exec $i -- apt-get -y -qq install python
done
lxc exec centos7 -- yum update
lxc exec centos7 -- yum install python

( cd ../; ansible-playbook -i tests/servers site.yml )

for i in xenial zesty artful stretch jessie centos7; do
    echo -n "$i: "
    GET http://$(lxc list $i -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}')/ -H "Host: example.com" | grep -F '<title>' | grep -F "Just Another WordPress Site"
done

for i in xenial zesty artful stretch jessie centos7; do
    lxc delete $i --force
done

rm -rf ../group_vars servers
