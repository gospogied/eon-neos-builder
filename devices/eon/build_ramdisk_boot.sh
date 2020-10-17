#!/bin/bash -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
cd "$DIR"
source build_env.sh
DEFAULT_TARGET="oneplus3"

TARGET="$1"

BOOT_RAMDISK="mindroid/system/out/target/product/"${TARGET:-$DEFAULT_TARGET}"/ramdisk.img"
[ ! -f $BOOT_RAMDISK ] && ./build_android.sh "${TARGET:-$DEFAULT_TARGET}"

# extract ramdisk
sudo rm -rf boot_ramdisk
mkdir -p boot_ramdisk

pushd boot_ramdisk
  gunzip -c ../$BOOT_RAMDISK | sudo cpio -i

  echo "running populate ramdisk"

  # copy ramdisk files, include symlinks
  ln -s /system/bin bin
  ln -s /data/data/com.termux/files/home home
  ln -s /data/data/com.termux/files/tmp tmp
  ln -s /data/data/com.termux/files/usr usr
  sudo cp -v "$DIR"/ramdisk_common/* .
  echo "$NEOS_BUILD_VERSION" > VERSION
  touch EON

  # repack ramdisk
  rm -f ../ramdisk-boot.gz
  sudo find . | sudo cpio -o -H newc -O ../ramdisk-boot
  gzip ../ramdisk-boot
popd
