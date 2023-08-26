# Build Linux Kernel

There are two ways

1. run scripts/build-linux-6.1.47-zynqmp-fpga-generic.sh (easy)
2. run this chapter step-by-step (annoying)

## Download Linux Kernel Source

### Clone from linux-stable.git

```console
shell$ git clone --depth 1 -b v6.1.47 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.47-zynqmp-fpga-generic
```

### Make Branch linux-6.1.47-zynqmp-fpga-generic

```console
shell$ cd linux-6.1.47-zynqmp-fpga-generic
shell$ git checkout -b 6.1.47-zynqmp-fpga-generic refs/tags/v6.1.47
```

## Patch to Linux Kernel

### Patch for linux-xlnx-v2023.1

```console
shell$ sh ../patches/linux-6.1.47-xlnx-v2023.1/xxx_patch.sh
```

### Patch for builddeb

```console
shell$ patch -p1 < ../patches/linux-6.1.47-zynqmp-fpga-builddeb.diff 
shell$ git add --all
shell$ git commit -m "[update] scripts/package/builddeb to add tools/include and postinst script to header package."
```

### Add ATWILC3000 Linux Driver for Ultra96-V2

```console
shell$ rm -rf drivers/staging/wilc3000
shell$ cp -r ../patches/microchip-wilc-driver/wilc1000 drivers/staging/wilc3000
shell$ patch -p1 < ../patches/linux-6.1.47-zynqmp-fpga-wilc3000.diff
shell$ patch -p1 < ../patches/linux-6.1.47-zynqmp-fpga-pwrseq-wilc.diff
shell$ git add --all
shell$ git commit -m "[add] drivers/staging/wilc3000"
```

### Patch for Ultra96

```console
shell$ patch -p1 < ../patches/linux-6.1.47-zynqmp-fpga-ultra96.diff
shell$ git add --all
shell$ git commit -m "[patch] for Ultra96."
```

### Patch for Ultra96-V2

```console
shell$ patch -p1 < ../patches/linux-6.1.47-zynqmp-fpga-ultra96v2.diff 
shell$ git add --all
shell$ git commit -m "[patch] for Ultra96-V2."
```

### Patch for UltraZed-EG IO Carrier Card

```console
shell$ patch -p1 < ../patches/linux-6.1.47-zynqmp-fpga-uz3eg-iocc.diff 
shell$ git add --all
shell$ git commit -m "[patch] for UltraZed-EG IO Carrier Card."
```

### Patch for Kria KV260

```console
shell$ patch -p1 < ../patches/linux-6.1.47-zynqmp-fpga-kv260.diff 
shell$ git add --all
shell$ git commit -m "[patch] for Kria KV260."
```

### Patch for Kria KR260

```console
shell$ patch -p1 < ../patches/linux-6.1.47-zynqmp-fpga-kr260.diff 
shell$ git add --all
shell$ git commit -m "[patch] for Kria KR260."
```

### Add zynqmp_fpga_generic_defconfig

```console
shell$ cp ../files/zynqmp_fpga_generic_defconfig arch/arm64/configs/
shell$ git add arch/arm64/configs/zynqmp_fpga_generic_defconfig
shell$ git commit -m "[add] zynqmp_fpga_generic_defconfig to arch/arm64/configs"
```

### Create tag and .version

```console
shell$ git tag -a 6.1.47-zynqmp-fpga-generic-1 -m "release 6.1.47-zynqmp-fpga-generic-1"
shell$ echo 0 > .version
```

## Build

### Setup for Build 

```console
shell$ cd linux-6.1.47-zynqmp-fpga-generic
shell$ export ARCH=arm64
shell$ export CROSS_COMPILE=aarch64-linux-gnu-
shell$ make zynqmp_fpga_generic_defconfig
```

### Build Linux Kernel and device tree

```console
shell$ export DTC_FLAGS=--symbols
shell$ rm -rf debian
shell$ make deb-pkg
```

### Install kernel image to this repository

```console
shell$ cp arch/arm64/boot/Image.gz ../vmlinuz-6.1.47-zynqmp-fpga-generic-1
shell$ cp .config             ../files/config-6.1.47-zynqmp-fpga-generic-1
```

### Install devicetree to this repository

```console
shell$ install -d ../devicetrees/6.1.47-zynqmp-fpga-generic-1
shell$ cp arch/arm64/boot/dts/xilinx/* ../devicetrees/6.1.47-zynqmp-fpga-generic-1
```
