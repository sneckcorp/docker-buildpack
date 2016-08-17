#!/bin/sh

# Goofys Entrypoint
/entrypoint.sh &


# waiting for goofy
echo "Whating for goofys mount(${GOOFYS_MOUNT_PATH})"
JOBS="`jobs`"
JOBS_COUNT=`echo "$JOBS" | grep 'Running' | wc -l`
COUNT=0
while [[ $COUNT -lt 10 -a $JOBS_COUNT -ge 1 -a `mount | grep "on ${GOOFYS_MOUNT_PATH}" | wc -l` -eq 0 ]]; do
  COUNT=$((COUNT+1))
  sleep 0.5

  JOBS="`jobs`"
  JOBS_COUNT=`echo "$JOBS" | grep 'Running' | wc -l`
done

if [[ `mount | grep "on ${GOOFYS_MOUNT_PATH}" | wc -l` -eq 0 ]]; then
  echo "The goofy mount failed."
  kill 1 # kill /sbin/init
  exit 1
fi

GOOFYS_MOUNT_PATH=${GOOFYS_MOUNT_PATH:-/mnt/s3}

if [[ ! -d $GOOFYS_MOUNT_PATH ]]; then
  mkdir -p $GOOFYS_MOUNT_PATH
fi

if [[ -z "$NFSD_EXPORTS" -a -n "$GOOFYS_MOUNT_PATH" ]]; then
  NFSD_EXPORTS=${NFSD_EXPORTS:-"$GOOFYS_MOUNT_PATH *(rw,fsid=0,insecure,no_root_squash,sync,no_subtree_check)"}
fi

if [[ -n "$NFSD_EXPORTS" ]]; then
  echo -e "$NFSD_EXPORTS" > /etc/exports
fi