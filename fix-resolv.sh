#! /bin/sh

cat /etc/resolv.conf | sed '3d' | sed '3inameserver 192.168.1.1' > /tmp/resolv.conf
sudo unlink /etc/resolv.conf
sudo mv /tmp/resolv.conf /etc/
