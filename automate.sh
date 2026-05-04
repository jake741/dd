#!/bin/bash

while read wildcard; do
  if /usr/local/bin/recon.sh $wildcard > /dev/null ; then
      echo "done : $wildcard";
  fi
done
