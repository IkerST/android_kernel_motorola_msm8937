#!/usr/bin/env bash

function _usage() {
	cat <<-EOF

	Build kernel for device
	Usage: $0 [device-codename] [toolchain]

	EOF
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
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2/$1
TOOLCHAINDIR=$2
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Kernel"
DEVICE="-$1-"
VER=$(cat version)
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$VER".zip
CORES=$( nproc --all)
THREADS=$( echo $CORES + $CORES | bc )

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
make -j$THREADS

if [ -e  arch/arm/boot/zImage ];
then
echo "Kernel compilation completed"
cp $KERNEL_DIR/arch/arm/boot/zImage $ANYKERNEL_DIR/
cd $ANYKERNEL_DIR
echo "Making Flashable zip"
echo "Generating changelog"
git log --graph --pretty=format:'%s' --abbrev-commit -n 200  > $ANYKERNEL_DIR/changelog.txt
echo "Changelog generated"
cp arch/arm/boot/zImage $ANYKERNEL_DIR
cd $ANYKERNEL_DIR
zip ../$FINAL_ZIP $(ls) -r &>/dev/null
echo "Flashable zip Created"
else
echo "Kernel not compiled,fix errors and compile again"
fi