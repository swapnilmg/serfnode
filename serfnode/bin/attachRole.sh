#!/bin/bash

SERF_HOME=/usr/local/serfnode
SERF_BIN=$SERF_HOME/bin/serf

$SERF_BIN tags -set role=$1