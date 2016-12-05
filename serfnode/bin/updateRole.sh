#!/bin/bash

SERF_HOME=/usr/local/serfnode
SERF_BIN=$SERF_HOME/bin/serf

$SERF_BIN members > /tmp/members.txt
sort -n /tmp/members.txt > /tmp/sorted-members.txt
while read p; do
    if [ "alive" = "`echo $p | awk {'print $3'}`" ]; then
        if [ "`hostname`" = "`echo $p | awk {'print $1'}`" ]; then
        	$SERF_BIN tags -set role=primary
        	service apache2 start
        	/usr/local/serfnode/bin/attachIP.sh
        fi;
        break;
    fi;
done </tmp/sorted-members.txt
