#!/bin/bash

CURRENT_DIR=`pwd`
KERNEL_VERSION=6.1.72
KERNEL_STABLE_VERSION=v6.1.72
LOCAL_VERSION=zynqmp-fpga-trial
BUILD_VERSION=1
KERNEL_RELEASE=$KERNEL_VERSION-$LOCAL_VERSION
LINUX_BUILD_DIR=linux-$KERNEL_RELEASE

echo "KERNEL_RELEASE  =" $KERNEL_RELEASE
echo "BUILD_VERSION   =" $BUILD_VERSION
echo "LINUX_BUILD_DIR =" $LINUX_BUILD_DIR

## Download Linux Kernel Source

### Clone from linux-stable.git

git clone --depth 1 -b $KERNEL_STABLE_VERSION git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git $LINUX_BUILD_DIR

### Make Branch

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

### Patch for Lima

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-lima-drv.diff
git add --update
git commit -m "[add] CONFIG_DRM_LIMA_OF_ID_PREFIX to drivers/gpu/drm/lima/Kconfig and lima_drv.c" \
           -m "[add] CONFIG_DRM_LIMA_OF_ID_PARAMETERIZE to drivers/gpu/drm/lima/Kconfig and lima_drv.c"

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-lima-clk.diff
git add --update
git commit -m "[change] clk of lima_device to use clk_bulk."

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-lima-irq.diff
git add --update
git commit -m "[change] lima_device to be able to specify multiple IRQ names."

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-drm-xlnx-align.diff
git add --all
git commit -m "[add] Dumb Buffer Alignment Size to Xilinx DRM KMS Driver for Lima support."

patch -p1 < ../patches/linux-$KERNEL_VERSION-zynqmp-fpga-drm-xlnx-gem.diff
git add --all
git commit -m "[update] Xilinx DRM KMS Driver to enable data cache for Lima support."

### Add zynqmp_fpga_trial_defconfig

cp ../files/zynqmp_fpga_trial_defconfig arch/arm64/configs/
git add arch/arm64/configs/zynqmp_fpga_trial_defconfig
git commit -m "[add] zynqmp_fpga_trial_defconfig to arch/arm64/configs"

## Build

### Create tag and .version

git tag -a $KERNEL_RELEASE-$BUILD_VERSION -m "release $KERNEL_RELEASE-$BUILD_VERSION"
echo `expr $BUILD_VERSION - 1` > .version

### Setup for Build 

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make zynqmp_fpga_trial_defconfig

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

