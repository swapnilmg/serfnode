#!/bin/bash

BODY=$(cat)
echo
echo ==================
for var in ${!SERF*}; do echo $var=${!var} ; done
echo ------------------
echo "$BODY"
echo ==================
cat -ve <<<"$BODY"
