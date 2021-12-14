#!/usr/bin/env bash

set -eo pipefail

# import the deployment helpers
. $(dirname $0)/common.sh

# Deploy.
# Token1Addr=$(deploy MockERC721 '"Token1"' '"TOKEN1"')
# log "Token 1 deployed at:" $Token1Addr

# Token2Addr=$(deploy MockERC721 '"Token2"' '"TOKEN2"')
# log "Token 2 deployed at:" $Token2Addr

# Token3Addr=$(deploy MockERC721 '"Token3"' '"TOKEN3"')
# log "Token 3 deployed at:" $Token3Addr

# Token4Addr=$(deploy MockERC721 '"Token4"' '"TOKEN4"')
# log "Token 4 deployed at:" $Token4Addr

SantaswapAddr=$(deploy Santaswap 0x6c125584ea4fa566607f111d84be7280487a9e1001272ba5172795ca083529cd)
log "Santaswap deployed at:" $SantaswapAddr