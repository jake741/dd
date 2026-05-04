#!/bin/bash

while read wildcard; do
  if ./recon.sh $wildcard > /dev/null; then
      echo "done : $wildcard";
  fi
done
