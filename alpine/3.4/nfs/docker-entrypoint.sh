#!/bin/sh

if [[ -n "$NFSD_EXPORTS" ]]; then
  echo -e "$NFSD_EXPORTS" > /etc/exports
fi