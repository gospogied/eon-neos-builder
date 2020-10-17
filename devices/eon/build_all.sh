#!/bin/bash -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

cd $DIR
DEFAULT_TARGET="oneplus3"

TARGET="$1"

./build_ramdisks.sh "${TARGET:-$DEFAULT_TARGET}"
./build_boot.sh "${TARGET:-$DEFAULT_TARGET}"
./build_recovery.sh "${TARGET:-$DEFAULT_TARGET}"
./build_system.sh "${TARGET:-$DEFAULT_TARGET}"
