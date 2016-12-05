#!/bin/bash

echo "auto eth0:0
  iface eth0:0 inet static
  address 172.17.0.99">>/etc/network/interfaces

service networking restart