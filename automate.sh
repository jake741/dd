#!/bin/bash

while read wildcard; do
  if recon.sh $wildcard > /dev/null ; then
      echo "done : $wildcard" | notify ;
  fi
done
