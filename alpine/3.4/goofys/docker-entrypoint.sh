#!/bin/sh

# Default setting
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-""}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-""}
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-""}
AWS_S3_BUCKET=${AWS_S3_BUCKET:-""}
AWS_S3_PREFIX=${AWS_S3_PREFIX:-""}

GOOFYS_MOUNT_PATH=${GOOFYS_MOUNT_PATH:-/mnt/s3}
GOOFYS_DIR_MODE=${GOOFYS_DIR_MODE:-""}
GOOFYS_FILE_MODE=${GOOFYS_FILE_MODE:-""}
GOOFYS_UID=${GOOFYS_UID:-""}
GOOFYS_GID=${GOOFYS_GID:-""}
GOOFYS_ENDPOINT=${GOOFYS_ENDPOINT:-""}
GOOFYS_REGION=${GOOFYS_REGION:-""}
GOOFYS_STORAGE_CLASS=${GOOFYS_STORAGE_CLASS:-""}
GOOFYS_USE_CONTENT_TYPE=${GOOFYS_USE_CONTENT_TYPE:-""}
GOOFYS_STAT_CACHE_TTL=${GOOFYS_STAT_CACHE_TTL:-""}
GOOFYS_TYPE_CACHE_TTL=${GOOFYS_TYPE_CACHE_TTL:-""}
GOOFYS_GLOBAL_OPTION=${GOOFYS_GLOBAL_OPTION:-""}
GOOFYS_ETC_MIME=${GOOFYS_ETC_MIME:-""}

# AWS credentials and config setting
if [[ -z "$AWS_ACCESS_KEY_ID" -o -z "$AWS_SECRET_ACCESS_KEY" ]]; then
  echo "Place set environment variables(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)"
  exit 1;
fi

if [[ -n "$AWS_S3_PREFIX" -a "${AWS_S3_PREFIX:0:1}" == "/" ]]; then
 AWS_S3_PREFIX=${AWS_S3_PREFIX:1}
 echo "AWS_S3_PREFIX can not start with '/'."
fi

if [[ -z "$AWS_S3_BUCKET" ]]; then
  echo "Place set environment variables(AWS_S3_BUCKET)"
  exit 1;
elif [[ -n "$AWS_S3_BUCKET" -a -n "$AWS_S3_PREFIX" ]]; then
  GOOFYS_FROM_PATH="${AWS_S3_BUCKET}:${AWS_S3_PREFIX}"
else
  GOOFYS_FROM_PATH="$AWS_S3_BUCKET"
fi

mkdir -p ~/.aws

cat <<- EOF > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF

if [[ -n "$AWS_DEFAULT_REGION" ]]; then
  cat <<- EOF > ~/.aws/config
[profile default]
region = $AWS_DEFAULT_REGION
EOF
fi

if [[ -n "$GOOFYS_ETC_MIME" ]]; then
  cat <<- EOF > /etc/mime.types
$GOOFYS_ETC_MIME
EOF
fi

if [[ -z "$GOOFYS_REGION" -a -n "$AWS_DEFAULT_REGION" ]]; then
  GOOFYS_REGION="$AWS_DEFAULT_REGION"
fi

# goofys global option setting
[[ -n "$GOOFYS_DIR_MODE" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --dir-mode ${GOOFYS_DIR_MODE}"
[[ -n "$GOOFYS_FILE_MODE" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --file-mode ${GOOFYS_FILE_MODE}"
[[ -n "$GOOFYS_UID" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --uid ${GOOFYS_UID}"
[[ -n "$GOOFYS_GID" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --gid ${GOOFYS_GID}"
[[ -n "$GOOFYS_ENDPOINT" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --endpoint ${GOOFYS_ENDPOINT}"
[[ -n "$GOOFYS_ENDPOINT" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --endpoint ${GOOFYS_ENDPOINT}"
[[ -n "$GOOFYS_REGION" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --region ${GOOFYS_REGION}"
[[ -n "$GOOFYS_STORAGE_CLASS" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --storage-class ${GOOFYS_STORAGE_CLASS}"
[[ -n "$GOOFYS_USE_CONTENT_TYPE" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --use-content-type ${GOOFYS_USE_CONTENT_TYPE}"
[[ -n "$GOOFYS_STAT_CACHE_TTL" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --stat-cache-ttl ${GOOFYS_STAT_CACHE_TTL}"
[[ -n "$GOOFYS_TYPE_CACHE_TTL" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --type-cache-ttl ${GOOFYS_TYPE_CACHE_TTL}"

if [[ ! -d $GOOFYS_MOUNT_PATH ]]; then
  mkdir -p $GOOFYS_MOUNT_PATH
fi

syslog-ng
/usr/local/bin/goofys ${GOOFYS_GLOBAL_OPTION} -f ${GOOFYS_FROM_PATH} ${GOOFYS_MOUNT_PATH}