#!/bin/bash

sudo cp /etc/systemd/network/20-eth0-static.network /etc/systemd/network/20-eth0.network
sudo systemctl restart systemd-networkd
