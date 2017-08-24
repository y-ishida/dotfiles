#! /bin/sh

#sudo nmcli c m "有線接続 1" connection.id enp0s8
sudo nmcli c m enp0s8 ipv4.addresses "192.168.56.11/24"
sudo nmcli c m enp0s8 ipv4.method "manual"
sudo nmcli c m enp0s8 connection.autoconnect "yes"
sudo nmcli c d enp0s8
sudo nmcli c u enp0s8

