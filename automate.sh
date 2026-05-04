#!/bin/bash

while read wildcard; do
  if recon.sh $wildcard ; then
      echo "done : $wildcard";
  fi
done
