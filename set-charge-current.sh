#!/bin/bash

set -o errexit
set -o nounset

usage() {
  cat <<EOF
usage: $0 <CHARGE-CURRENT>

Sets the max output current. Electrical safety warnings from the TWC
applies here: set only to values determined by qualified personnel.
EOF
  exit 0
}

CHARGE_CURRENT="${1:-}"

if [[ "${1:-}" = '' ]]; then
  usage
fi

PROTO="$(dirname $0)/wc3.proto"
TWC='http://192.168.92.1'
DIN=$(curl -s "${TWC}/tedapi/din")

protoc \
  "${PROTO}" \
  --encode=AuthEnvelope \
  <<EOF |
payload {
  delivery_channel: 1
  sender {
    local: 1
  }
  recipient {
    din: "${DIN}"
  }
  wc {
    configure_settings_request {
      settings {
        max_output_current_amps: ${CHARGE_CURRENT}
      }
    }
  }
}
external_auth {
  type: 1
}
EOF
curl \
    --data-binary @- \
    -H 'Content-Type: application/octet-stream' \
    "${TWC}/tedapi/v1" \
| protoc \
  "${PROTO}" \
  --decode=AuthEnvelope

