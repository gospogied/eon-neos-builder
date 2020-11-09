#!/bin/bash -e

PYTHON_MAJOR=`python -c "import platform; major, minor, patch = platform.python_version_tuple(); print(major)"`
if [ "$PYTHON_MAJOR" != "2" ]; then
  echo "Parts of the NEOS build still require \"python\" to be legacy Python 2!"
  echo "Install python 2.7 and 3.7 with pyenv then run 'pyenv local 2.7.x and 3.7.x'"
  exit
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

pushd $DIR
DEFAULT_TARGET="oneplus3"

TARGET="$1"

function build_all() {
	echo -e "\n\tBuilding ramdisks\n"; "${DIR}"/build_ramdisks.sh "${TARGET:-$DEFAULT_TARGET}"|| { echo "Failure in build_ramdisks: $?"; return; } && echo -e "\nSuccess build_ramdisks"
	echo -e "\n\tBuilding boot\n"; "${DIR}"/build_boot.sh "${TARGET:-$DEFAULT_TARGET}" || { echo "Failure in build_boot: $?"; return; } && echo -e "\nSuccess build_boot"
	echo -e "\n\tBuilding recovery\n"; "${DIR}"/build_recovery.sh "${TARGET:-$DEFAULT_TARGET}" || { echo "Failure in build_recovery: $?"; return; } && echo -e "\nSuccess build_recovery"
	echo -e "\n\tBuilding system\n"; "${DIR}"/build_system.sh "${TARGET:-$DEFAULT_TARGET}" || { echo "Failure in build_system: $?"; return; } && echo -e "\nSuccess build_system"
}

build_all

popd
