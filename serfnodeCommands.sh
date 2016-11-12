#!/bin/bash

: ${NODE_PREFIX=serfnode}
: ${MYDOMAIN:=swapnilmg.sjsu.edu}
: ${IMAGE:=swapnilmg/serfnode}
: ${DOCKER_OPTS:="--dns 127.0.0.1 -p 7373 -p 7946"}
: ${DEBUG:=1}

serfnode-settings() {
  cat <<EOF
  NODE_PREFIX=$NODE_PREFIX
  MYDOMAIN=$MYDOMAIN
  IMAGE=$IMAGE
  DOCKER_OPTS=$DOCKER_OPTS
  SERF_JOIN_IP=$SERF_JOIN_IP
EOF
}

debug() {
  [ -z $DEBUG ] || echo [DEBUG] $@
}

serf-start-first() {
  CMD="docker run -d $DOCKER_OPTS --name ${NODE_PREFIX}0 -h ${NODE_PREFIX}0.$MYDOMAIN $IMAGE"
  debug $CMD
  $CMD
  CMD="docker exec -t ${NODE_PREFIX}0 /usr/local/serfnode/bin/attachRole.sh primary"
  debug $CMD
  $CMD
}

get-join-ip() {
  : ${SERF_JOIN_IP:=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" ${NODE_PREFIX}0)}
  #"
  debug SERF_JOIN_IP=$SERF_JOIN_IP
}

serf-start-node() {
  get-join-ip
  : ${SERF_JOIN_IP:?"SERF_JOIN_IP is needed"}
  NUMBER=${1:?"please give a <NUMBER> parameter it will be used as node<NUMBER>"}
  if [ $# -eq 1 ] ;then
    MORE_OPTIONS="-d"
  else
    shift
    MORE_OPTIONS="$@"
  fi
  CMD="docker run $MORE_OPTIONS -e SERF_JOIN_IP=$SERF_JOIN_IP $DOCKER_OPTS --name ${NODE_PREFIX}$NUMBER -h ${NODE_PREFIX}${NUMBER}.$MYDOMAIN $IMAGE"
  debug $CMD
  $CMD
  CMD="docker exec -t ${NODE_PREFIX}$NUMBER /usr/local/serfnode/bin/attachRole.sh standby"
  debug $CMD
  $CMD
}

serf-start-cluster() {
  NUM_OF_NODES=${1:-3}
  echo starting $NUM_OF_NODES docker container

  serf-start-first
  for i in $(seq $((NUM_OF_NODES - 1))); do
    serf-start-node $i
  done
}