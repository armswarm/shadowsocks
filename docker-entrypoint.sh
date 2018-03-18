#!/usr/bin/env sh

set -o errexit

_usage() {
    echo "usage: /docker-entrypoint.sh <server|local>" && exit 1
}

[ "$#" -ne 1 ] || [ "${1}" != "server" ] && [ "${1}" != "local" ] && _usage

[ -z "${SS_PASSWORD}" ] && echo "SS_PASSWORD must be set" && exit 1

# defaults
_ss_server_addr=${SS_SERVER_ADDR:-0.0.0.0}
_ss_local_addr=${SS_LOCAL_ADDR:-0.0.0.0}
_ss_server_port=${SS_SERVER_PORT:-8388}
_ss_local_port=${SS_LOCAL_PORT:-1080}
_ss_method=${SS_METHOD:-aes-256-cfb}
_ss_timeout=${SS_TIMEOUT:-300}
_ss_args=${SS_ARGS:---fast-open -u}

if [ "${1}" = "server" ]; then
    ss-server \
      -s ${_ss_server_addr} \
      -p ${_ss_server_port} \
      -k ${SS_PASSWORD} \
      -m ${_ss_method} \
      -t ${_ss_timeout} \
      ${_ss_args}
elif [ "${1}" = "local" ]; then
    [ -z "${SS_SERVER_ADDR}" ] && echo "SS_SERVER_ADDR must be set" && exit 1

    ss-local \
      -s ${SS_SERVER_ADDR} \
      -p ${_ss_server_port} \
      -b ${_ss_local_addr} \
      -l ${_ss_local_port} \
      -k ${SS_PASSWORD} \
      -m ${_ss_method} \
      -t ${_ss_timeout} \
      ${_ss_args}
else
    _usage
fi
