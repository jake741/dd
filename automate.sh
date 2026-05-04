#!/bin/bash

while read wildcard; do
  if /usr/local/bin/recon.sh $wildcard; then
      echo "done : $wildcard";
  fi
done
