#!/bin/bash
set -eu

export PORT="${RPC_PORT:-80}"
export STATUS_METHOD="${STATUS_METHOD:-net_version}"
export AUTHORIZATION_HEADER="${AUTHORIZATION_HEADER:-}"
export AUTHORIZATION_HEADER_VALUE="${AUTHORIZATION_HEADER_VALUE:-}"
export AUTHORIZATION=""

if [[ ! -z "${AUTHORIZATION_HEADER:-}" ]] && [[ ! -z "${AUTHORIZATION_HEADER_VALUE:-}" ]]; then
    AUTHORIZATION=$(echo -n "proxy_set_header ${AUTHORIZATION_HEADER} ${AUTHORIZATION_HEADER_VALUE};")    
fi
mv /tmp/rpc.conf.template /etc/nginx/conf.d/default.conf
envsubst '${PORT}' < /tmp/common.template  > /etc/nginx/conf.d/common.template 
envsubst '${STATUS_METHOD}' < /tmp/status.template  > /etc/nginx/conf.d/status.template 
envsubst '${AUTHORIZATION} ${ENDPOINT}' < /tmp/rpc.template  > /etc/nginx/conf.d/rpc.template 

exec "$@"