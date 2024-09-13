# Build Linux Kernel

There are two ways

1. run scripts/build-linux-6.1.108-zynqmp-fpga-trial.sh (easy)
2. run this chapter step-by-step (annoying)

## Download Linux Kernel Source

### Clone from linux-stable.git

```console
shell$ git clone --depth 1 -b v6.1.108 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.108-zynqmp-fpga-trial
```

### Make Branch linux-6.1.108-zynqmp-fpga-trial

```console
shell$ cd linux-6.1.108-zynqmp-fpga-trial
shell$ git checkout -b 6.1.108-zynqmp-fpga-trial refs/tags/v6.1.108
```

## Patch to Linux Kernel

### Patch for linux-xlnx-v2023.1

```console
shell$ sh ../patches/linux-6.1.108-xlnx-v2023.1/xxx_patch.sh
```

### Patch for builddeb

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-builddeb.diff 
shell$ git add --all
shell$ git commit -m "[update] scripts/package/builddeb to add tools/include and postinst script to header package."
```

### Add ATWILC3000 Linux Driver for Ultra96-V2

```console
shell$ rm -rf drivers/staging/wilc3000
shell$ cp -r ../patches/microchip-wilc-driver/wilc1000 drivers/staging/wilc3000
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-wilc3000.diff
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-pwrseq-wilc.diff
shell$ git add --all
shell$ git commit -m "[add] drivers/staging/wilc3000"
```

### Patch for Ultra96

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-ultra96.diff
shell$ git add --all
shell$ git commit -m "[patch] for Ultra96."
```

### Patch for Ultra96-V2

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-ultra96v2.diff 
shell$ git add --all
shell$ git commit -m "[patch] for Ultra96-V2."
```

### Patch for UltraZed-EG IO Carrier Card

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-uz3eg-iocc.diff 
shell$ git add --all
shell$ git commit -m "[patch] for UltraZed-EG IO Carrier Card."
```

### Patch for Kria KV260

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-kv260.diff 
shell$ git add --all
shell$ git commit -m "[patch] for Kria KV260."
```

### Patch for Kria KR260

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-kr260.diff 
shell$ git add --all
shell$ git commit -m "[patch] for Kria KR260."
```

### Patch for Lima

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-lima-drv.diff
shell$ git add --update
shell$ git commit -m "[add] CONFIG_DRM_LIMA_OF_ID_PREFIX to drivers/gpu/drm/lima/Kconfig and lima_drv.c" \
                  -m "[add] CONFIG_DRM_LIMA_OF_ID_PARAMETERIZE to drivers/gpu/drm/lima/Kconfig and lima_drv.c"
```

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-lima-clk.diff
shell$ git add --update
shell$ git commit -m "[change] clk of lima_device to use clk_bulk."
```

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-lima-irq.diff
shell$ git add --update
shell$ git commit -m "[change] lima_device to be able to specify multiple IRQ names."
```

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-drm-xlnx-align.diff
shell$ git add --all
shell$ git commit -m "[add] Dumb Buffer Alignment Size to Xilinx DRM KMS Driver for Lima support."
```

```console
shell$ patch -p1 < ../patches/linux-6.1.108-zynqmp-fpga-drm-xlnx-gem.diff
shell$ git add --all
shell$ git commit -m "[update] Xilinx DRM KMS Driver to enable data cache for Lima support."
```

### Add zynqmp_fpga_trial_defconfig

```console
shell$ cp ../files/zynqmp_fpga_trial_defconfig arch/arm64/configs/
shell$ git add arch/arm64/configs/zynqmp_fpga_trial_defconfig
shell$ git commit -m "[add] zynqmp_fpga_trial_defconfig to arch/arm64/configs"
```

### Create tag and .version

```console
shell$ git tag -a 6.1.108-zynqmp-fpga-trial-1 -m "release 6.1.108-zynqmp-fpga-trial-1"
shell$ echo 0 > .version
```

## Build

### Setup for Build 

```console
shell$ cd linux-6.1.108-zynqmp-fpga-trial
shell$ export ARCH=arm64
shell$ export CROSS_COMPILE=aarch64-linux-gnu-
shell$ make zynqmp_fpga_trial_defconfig
```

### Build Linux Kernel and device tree

```console
shell$ export DTC_FLAGS=--symbols
shell$ rm -rf debian
shell$ make deb-pkg
```

### Install kernel image to this repository

```console
shell$ cp arch/arm64/boot/Image.gz ../vmlinuz-6.1.108-zynqmp-fpga-trial-1
shell$ cp .config             ../files/config-6.1.108-zynqmp-fpga-trial-1
```

### Install devicetree to this repository

```console
shell$ install -d ../devicetrees/6.1.108-zynqmp-fpga-trial-1
shell$ cp arch/arm64/boot/dts/xilinx/* ../devicetrees/6.1.108-zynqmp-fpga-trial-1
```
