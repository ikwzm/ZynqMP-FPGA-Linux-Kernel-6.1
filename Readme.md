ZynqMP-FPGA-Linux-Kernel-6.1
====================================================================================

Overview
------------------------------------------------------------------------------------

### Introduction

This Repository provides a Linux Kernel (v6.1.x) Image and Device Trees for Zynq MPSoC.

### Note

**The Linux Kernel Image provided in this repository is not official.**
**I modified it to my liking. Please handle with care.**

**Downloading the entire repository takes time, so download the files from URL**   

https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/releases/6.1.47-zynqmp-fpga-generic-1

### Features

  * Linux Kernel Version v6.1.x
  * Enable Device Tree Overlay with Configuration File System
  * Enable FPGA Manager
  * Enable FPGA Bridge
  * Enable FPGA Reagion
  * Enable ATWILC3000 Linux Driver for Ultra96-V2

Files
------------------------------------------------------------------------------------

* vmlinuz-6.1.47-zynqmp-fpga-generic-1
* linux-image-6.1.47-zynqmp-fpga-generic_6.1.47-zynqmp-fpga-generic-1_arm64.deb
* linux-headers-6.1.47-zynqmp-fpga-generic_6.1.47-zynqmp-fpga-generic-1_arm64.deb
* ./devicetrees/6.1.47-zynqmp-fpga-generic-1
  + avnet-ultra96-rev1.dtb
  + avnet-ultra96v2-rev1.dtb
  + zynqmp-uz3eg-iocc.dtb
  + zynqmp-kv260-revB.dtb
  + zynqmp-kr260-revB.dtb
* [./files/config-6.1.47-zynqmp-fpga-generic-1](./files/config-6.1.47-zynqmp-fpga-generic-1)

Build
------------------------------------------------------------------------------------

* [./doc/build/linux-6.1.47-zynqmp-fpga-generic.md](./doc/build/linux-6.1.47-zynqmp-fpga-generic.md)
