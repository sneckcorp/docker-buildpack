#!/bin/sh

if [[ -n "$NFSD_EXPORTS" ]]; then
  echo -e "$NFSD_EXPORTS" >> /etc/exports
elif [[ $# -gt 0 ]]; then
  # prepare /etc/exports
  for i in "$@"; do
      # fsid=0: needed for NFSv4
      echo "$i *(rw,fsid=0,insecure,sync,no_root_squash,no_subtree_check)" >> /etc/exports
  done
elif [[ -d "/exports" ]]; then
  echo "/exports *(rw,fsid=0,insecure,sync,no_root_squash,no_subtree_check)" >> /etc/exports
fi