ZynqMP-FPGA-Linux-Kernel-6.1
====================================================================================

Overview
------------------------------------------------------------------------------------

### Introduction

This Repository provides a Linux Kernel (v6.1.x) Image and Device Trees for Zynq MPSoC.

### Note

**The Linux Kernel Image provided in this repository is not official.**
**I modified it to my liking. Please handle with care.**

### Features

  * Linux Kernel Version v6.1.x
  * Enable Device Tree Overlay with Configuration File System
  * Enable FPGA Manager
  * Enable FPGA Bridge
  * Enable FPGA Reagion
  * Enable ATWILC3000 Linux Driver for Ultra96-V2

Release
------------------------------------------------------------------------------------

The main branch contains only Readme.md.     
For Linux Kernel image and Debian Packages, please refer to the respective release tag listed below.

| Version  | Local Name          | Build Version | Release Tag |
|:---------|:--------------------|:--------------|:------------|
| 6.1.108  | zynqmp-fpga-generic | 1             | [6.1.108-zynqmp-fpga-generic-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.108-zynqmp-fpga-generic-1) |
| 6.1.93   | zynqmp-fpga-generic | 1             | [6.1.93-zynqmp-fpga-generic-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.93-zynqmp-fpga-generic-1) |
| 6.1.84   | zynqmp-fpga-generic | 1             | [6.1.84-zynqmp-fpga-generic-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.84-zynqmp-fpga-generic-1) |
| 6.1.70   | zynqmp-fpga-trial   | 2             | [6.1.70-zynqmp-fpga-trial-2](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.70-zynqmp-fpga-trial-2) |
| 6.1.70   | zynqmp-fpga-generic | 2             | [6.1.70-zynqmp-fpga-generic-2](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.70-zynqmp-fpga-generic-2) |
| 6.1.57   | zynqmp-fpga-trial   | 1             | [6.1.57-zynqmp-fpga-trial-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.57-zynqmp-fpga-trial-1) |
| 6.1.57   | zynqmp-fpga-generic | 1             | [6.1.57-zynqmp-fpga-generic-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.57-zynqmp-fpga-generic-1) |
| 6.1.47   | zynqmp-fpga-trial   | 1             | [6.1.47-zynqmp-fpga-trial-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.47-zynqmp-fpga-trial-1) |
| 6.1.47   | zynqmp-fpga-generic | 1             | [6.1.47-zynqmp-fpga-generic-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.47-zynqmp-fpga-generic-1) |
| 6.1.42   | zynqmp-fpga-trial   | 1             | [6.1.42-zynqmp-fpga-trial-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.42-zynqmp-fpga-trial-1) |
| 6.1.42   | zynqmp-fpga-generic | 1             | [6.1.42-zynqmp-fpga-generic-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.42-zynqmp-fpga-generic-1) |
| 6.1.41   | zynqmp-fpga-generic | 1             | [6.1.41-zynqmp-fpga-generic-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.41-zynqmp-fpga-generic-1) |
| 6.1.38   | zynqmp-fpga-trial   | 1             | [6.1.38-zynqmp-fpga-trial-1](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.38-zynqmp-fpga-trial-1) |
| 6.1.38   | zynqmp-fpga-generic | 2             | [6.1.38-zynqmp-fpga-generic-2](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.38-zynqmp-fpga-generic-2) |
| 6.1.0    | zynqmp-fpga-generic | 4             | [6.1.0-zynqmp-fpga-generic-4](https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/tree/6.1.0-zynqmp-fpga-generic-4) |

Download
------------------------------------------------------------------------------------

```console
shell$ export RELEASE_TAG=6.1.70-zynqmp-fpga-trial-2
shell$ wget https://github.com/ikwzm/ZynqMP-FPGA-Linux-Kernel-6.1/archive/refs/tags/$RELEASE_TAG.tar.gz
shell$ tar xfz $RELEASE_TAG.tar.gz
shell$ cd ZynqMP-FPGA-Linux-Kernel-6.1-$RELEASE_TAG
```
