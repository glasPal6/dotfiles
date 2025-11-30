#!/bin/bash

sudo cp /etc/systemd/network/20-eth0-dhcp.network /etc/systemd/network/20-eth0.network
sudo systemctl restart systemd-networkd
