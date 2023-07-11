#!/bin/bash

CURRENT_DIR=`pwd`
KERNEL_VERSION=6.1.0
KERNEL_STABLE_VERSION=v6.1
LOCAL_VERSION=zynqmp-fpga-generic
BUILD_VERSION=1
KERNEL_RELEASE=$KERNEL_VERSION-$LOCAL_VERSION
LINUX_BUILD_DIR=linux-$KERNEL_RELEASE

echo "KERNEL_RELEASE  =" $KERNEL_RELEASE
echo "BUILD_VERSION   =" $BUILD_VERSION
echo "LINUX_BUILD_DIR =" $LINUX_BUILD_DIR

## Download Linux Kernel Source

### Clone from linux-stable.git

git clone --depth 1 -b $KERNEL_STABLE_VERSION git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git $LINUX_BUILD_DIR

### Make Branch linux-5.15.107-zynqmp-fpga-generic

cd $LINUX_BUILD_DIR
git checkout -b $KERNEL_RELEASE refs/tags/$KERNEL_STABLE_VERSION

## Patch to Linux Kernel

### Patch for linux-xlnx-v2023.1

sh ../patches/linux-$KERNEL_VERSION-xlnx-v2023.1/xxx_patch.sh

### Patch for builddeb

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-builddeb.diff 
git add --all
git commit -m "[update] scripts/package/builddeb to add tools/include and postinst script to header package."

### Add ATWILC3000 Linux Driver for Ultra96-V2

rm -rf drivers/staging/wilc3000
cp -r ../patches/microchip-wilc-driver/wilc1000 drivers/staging/wilc3000
patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-wilc3000.diff
patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-pwrseq-wilc.diff
git add --all
git commit -m "[add] drivers/staging/wilc3000"

### Patch for Ultra96

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-ultra96.diff
git add --all
git commit -m "[patch] for Ultra96."

### Patch for Ultra96-V2

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-ultra96v2.diff 
git add --all
git commit -m "[patch] for Ultra96-V2."

### Patch for UltraZed-EG IO Carrier Card

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-uz3eg-iocc.diff 
git add --all
git commit -m "[patch] for UltraZed-EG IO Carrier Card."

### Patch for Kria KV260

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-kv260.diff 
git add --all
git commit -m "[patch] for Kria KV260."

### Patch for Kria KR260

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-kr260.diff 
git add --all
git commit -m "[patch] for Kria KR260."

### Add zynqmp_fpga_generic_defconfig

cp ../files/zynqmp_fpga_generic_defconfig arch/arm64/configs/
git add arch/arm64/configs/zynqmp_fpga_generic_defconfig
git commit -m "[add] zynqmp_fpga_generic_defconfig to arch/arm64/configs"

## Build

### Create tag and .version

git tag -a $KERNEL_RELEASE-$BUILD_VERSION -m "release $KERNEL_RELEASE-$BUILD_VERSION"
echo `expr $BUILD_VERSION - 1` > .version

### Setup for Build 

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make zynqmp_fpga_generic_defconfig

### Build Linux Kernel and device tree

export DTC_FLAGS=--symbols
rm -rf debian
make deb-pkg

### Install kernel image to this repository

cp arch/arm64/boot/Image.gz ../vmlinuz-$KERNEL_RELEASE-$BUILD_VERSION
cp .config             ../files/config-$KERNEL_RELEASE-$BUILD_VERSION

### Install devicetree to this repository

install -d ../devicetrees/$KERNEL_RELEASE-$BUILD_VERSION
cp arch/arm64/boot/dts/xilinx/* ../devicetrees/$KERNEL_RELEASE-$BUILD_VERSION

