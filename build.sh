#!/usr/bin/env bash

#
#   This script depends on:
#   rpl and zip
#

function _usage() {
	cat <<-EOF

	Build kernel for device
	Usage: $0 [device-codename] [toolchain]

	EOF
}

function _flashable_zip() {
    rpl "%%DO_CHECK%%" "$1" anykernel.sh
    if [ $1 -eq 1 ]; then
        FINAL_ZIP="$FINAL_ZIP_S""check""$FINAL_ZIP_E"
    elif [ $1 -eq 0 ]; then
        FINAL_ZIP="$FINAL_ZIP_S""no_check""$FINAL_ZIP_E"
    fi
    zip $KERNEL_DIR/$FINAL_ZIP $(ls) -r &>/dev/null
}

function _set_device_zip() {
    rpl "%%DEVICE%%" "$DEVICE" anykernel.sh
}

function _clean() {
    rm -rf $TMP_DIR
}

# parse positional parameters
if [ "$#" -lt 2 ] || [ "$#" -gt 2 ]; then
	_usage
	exit 1
fi

echo "Preparing Files"
git clone https://github.com/IkerST/AnyKernel2 || (cd AnyKernel2 && git pull)
git clone -b oreo-8.0.0-release-jeter https://github.com/MotorolaMobilityLLC/vendor-qcom-opensource-wlan-prima drivers/staging/prima || ( cd drivers/staging/prima && git pull)

echo "Starting build"

KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2/msm8937
TOOLCHAINDIR=$2
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Kernel"
DEVICE="$1"
VER=$(cat version)
FINAL_ZIP_S="$KERNEL_NAME""-""$DEVICE""-""$DATE""-"
FINAL_ZIP_E="-""$VER".zip
CORES=$( nproc --all)
THREADS=$( echo $CORES + $CORES | bc )
TMP_DIR=$(mktemp -d .zip.XXX)

export ARCH=arm
export KBUILD_BUILD_USER="ist"
export KBUILD_BUILD_HOST="jenkins"
export CROSS_COMPILE=$TOOLCHAINDIR/bin/arm-eabi-
export USE_CCACHE=1

if [ -e  arch/arm/boot/zImage ];then
    #Just to make sure it doesn't make flashable zip with previous zImage
    rm arch/arm/boot/zImage
fi

if [ ! -d $ANYKERNEL_DIR ]; then
    echo "Please create a anykernel dir for your device/Or select another one"
    exit 1
fi

if [ ! -d $TOOLCHAINDIR ]; then
    echo "Please select a valid toolchain directory"
    exit 1
fi

echo "Preparing build"
make $1_defconfig
echo "Building with " $CORES " CPU(s)"
echo "And " $THREADS " threads"
make -j$THREADS -s

if [ -e  arch/arm/boot/zImage ];
then
echo "Kernel compilation completed"
echo "Making Flashable zip"
echo "Generating changelog"
git log --graph --pretty=format:'%s' --abbrev-commit -n 100  > $TMP_DIR/changelog.txt
echo "Changelog generated"
cd $TMP_DIR
echo "Creating check zip"
cp -R $ANYKERNEL_DIR/* $KERNEL_DIR/$TMP_DIR/
cp $KERNEL_DIR/arch/arm/boot/zImage $KERNEL_DIR/$TMP_DIR/
_set_device_zip
_flashable_zip 1
echo "Creating no check zip"
cp -R $ANYKERNEL_DIR/* $KERNEL_DIR/$TMP_DIR/
cp $KERNEL_DIR/arch/arm/boot/zImage $ANYKERNEL_DIR/$TMP_DIR/
_set_device_zip
_flashable_zip 0
echo "Cleaning"
_clean
echo "Flashable zips Created"

else
echo "Kernel not compiled,fix errors and compile again"
fi
