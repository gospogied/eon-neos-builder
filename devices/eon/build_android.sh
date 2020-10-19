#!/bin/bash -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
ROOT=$DIR/../..
TOOLS=$ROOT/tools
DEFAULT_TARGET="oneplus3"

TARGET="$1"

cd $DIR
source build_env.sh

# install build tools
if [[ -z "${SKIP_DEPS}" ]]; then
  source $DIR/install_deps.sh
fi

if [[ -z "${LIMIT_CORES}" ]]; then
  JOBS=$(nproc --all)
else
  JOBS=8
fi

# build mindroid
mkdir -p $DIR/mindroid/system
cd $DIR/mindroid/system

# By default, check out the "repeatable-build-mindroid" manifest with locked
# hashes for each Comma-forked component. If doing active development, check
# out "mindroid" instead, update the repeatable-build-mindroid manifest hashes
# when finished, and update the commit hash here.
$TOOLS/repo init -u https://github.com/gospogied/android.git -b f785661b56b535c4f58736b840043727526c3ce4
$TOOLS/repo sync -c -j$JOBS

export PATH=$PWD/bin:$PATH
(source build/envsetup.sh && breakfast "${TARGET:-$DEFAULT_TARGET}" && make -j$JOBS)
