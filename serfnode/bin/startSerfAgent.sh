#!/bin/bash

SERF_HOME=/usr/local/serfnode
SERF_BIN=$SERF_HOME/bin/serf
SERF_CONFIG_DIR=$SERF_HOME/config
SERF_LOG_FILE=/var/log/serfnode.log

[[ -n $SERF_JOIN_IP ]] && cat > $SERF_CONFIG_DIR/join.json <<EOF
{
  "retry_join" : ["$SERF_JOIN_IP"],
  "retry_interval" : "5s"
}
EOF

unset SERF_HOSTNAME
while [ -z "$SERF_HOSTNAME" ]; do
  SERF_HOSTNAME=$(hostname -f 2>/dev/null)
  sleep 5
done;
cat > $SERF_CONFIG_DIR/node.json <<EOF
{
  "node_name" : "$SERF_HOSTNAME",
  "bind" : "$SERF_HOSTNAME"
}
EOF

# if SERF_ADVERTISE_IP env variable set generate a advertise.json for serf to advertise the given IP
[[ -n $SERF_ADVERTISE_IP ]] && cat > $SERF_CONFIG_DIR/advertise.json <<EOF
{
  "advertise" : "$SERF_ADVERTISE_IP"
}
EOF

$SERF_BIN agent -config-dir $SERF_CONFIG_DIR --log-level debug $@ | tee -a $SERF_LOG_FILE 