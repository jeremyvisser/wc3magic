#!/bin/bash

set -o errexit
set -o nounset

usage() {
  cat <<EOF
usage: $0 < input.textproto

Reads an AuthEnvelope textproto as input, and sends it to the TWC3.
See examples/request-config.textproto as an example.

TWC3 web admin must be enabled (e.g. hold down charger button for 5 seconds).
EOF
  exit 0
}

if [[ -t 0 ]]; then
  usage
fi

PROTO="$(dirname $0)/wc3.proto"

protoc \
  "${PROTO}" \
  --encode=AuthEnvelope \
| curl \
    -v \
    --data-binary @- \
    -H 'Content-Type: application/octet-stream' \
    http://192.168.92.1/tedapi/v1 \
| protoc \
  "${PROTO}" \
  --decode=AuthEnvelope

