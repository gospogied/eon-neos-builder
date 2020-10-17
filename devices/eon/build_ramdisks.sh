#!/bin/bash -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
cd "$DIR"
DEFAULT_TARGET="oneplus3"

TARGET="$1"

./build_ramdisk_boot.sh "${TARGET:-$DEFAULT_TARGET}"
cp "mindroid/system/out/target/product/"${TARGET:-$DEFAULT_TARGET}"/ramdisk-recovery.img" ramdisk-recovery.gz

