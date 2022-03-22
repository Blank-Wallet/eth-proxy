#!/bin/bash
set -eu

export PORT="${PORT:-80}"

export DNS="${DNS}"
export BODY_BUFFER_SIZE="${BODY_BUFFER_SIZE:-16k}"

export FAIL_TIMEOUT="${FAIL_TIMEOUT:-10s}"
export MAX_FAILS="${MAX_FAILS:-1}"

export ENDPOINT="${ENDPOINT}"
export ENDPOINT_FAILOVER="${ENDPOINT_FAILOVER:-}"

if [[ ! -z "${ENDPOINT_FAILOVER:-}"  ]]; then
    envsubst '${ENDPOINT} ${ENDPOINT_FAILOVER} ${FAIL_TIMEOUT} ${MAX_FAILS}' < /etc/nginx/conf.d/failover.conf.template > /etc/nginx/conf.d/default.conf
else
    envsubst '${ENDPOINT}' < /etc/nginx/conf.d/non-failover.conf.template > /etc/nginx/conf.d/default.conf
fi

envsubst '${PORT}' < /etc/nginx/conf.d/server.conf.template >> /etc/nginx/conf.d/default.conf
envsubst '${DNS} ${BODY_BUFFER_SIZE}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

exec "$@"