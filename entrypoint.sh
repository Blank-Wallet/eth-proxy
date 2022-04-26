#!/bin/bash
set -eu

export DNS="${DNS}"
export PORT="${RPC_PORT:-80}"
export WS="${WS:-"NO"}"
export STATUS_METHOD="${STATUS_METHOD:-net_version}"
export AUTHORIZATION_HEADER="${AUTHORIZATION_HEADER:-}"

if [[ ! -z "${WS_ENDPOINT:-}"  ]]; then
    export WS="YES"
fi

if [[ ! -z "${ENDPOINT:-}"  ]]; then
    export RPC_ENDPOINT="${ENDPOINT}"
    export WS_ENDPOINT="${ENDPOINT}"
else
    export RPC_ENDPOINT="${RPC_ENDPOINT}"
    export WS_ENDPOINT="${WS_ENDPOINT}"
fi

if [[ -z "${USERNAME:-}" || -z "${PASSWORD:-}" ]] && [[ "$WS" = "YES" ]]; then
    # WS and no auth
    file=/tmp/rpc.ws.conf.template
    #envsubst '${AUTHORIZATION_HEADER}' < /tmp/rpc.ws.conf.template > /etc/nginx/conf.d/default.conf
elif [[ -z "${USERNAME:-}" || -z "${PASSWORD:-}" ]]; then
    # no ws and no auth
    file=/tmp/rpc.conf.template
    #envsubst '${AUTHORIZATION_HEADER}' < /tmp/rpc.conf.template > /etc/nginx/conf.d/default.conf
else
    AUTHORIZATION=$(echo -n "${USERNAME}:${PASSWORD}" | base64 | tr -d \\n)
    AUTHORIZATION_HEADER=$(echo -n "proxy_set_header Authorization \"Basic ${AUTHORIZATION}\";")    
    if [[ "$WS" = "YES" ]]; then
        # ws and auth
        file=/tmp/rpc.ws.conf.template
        #envsubst '${AUTHORIZATION_HEADER}' < /tmp/rpc.ws.conf.template > /etc/nginx/conf.d/default.conf
    else
        # no ws and auth
        file=/tmp/rpc.conf.template
        #envsubst '${AUTHORIZATION_HEADER}' < /tmp/rpc.conf.template > /etc/nginx/conf.d/default.conf
    fi
fi
envsubst '${AUTHORIZATION_HEADER}' < $file > /etc/nginx/conf.d/default.conf
envsubst '${DNS} ${PORT}' < /tmp/common.template  > /etc/nginx/conf.d/common.template 
envsubst '${STATUS_METHOD}' < /tmp/status.template  > /etc/nginx/conf.d/status.template 
envsubst '${RPC_ENDPOINT}' < /tmp/rpc.template  > /etc/nginx/conf.d/rpc.template 
envsubst '${WS_ENDPOINT}' < /tmp/ws.template  > /etc/nginx/conf.d/ws.template 

exec "$@"