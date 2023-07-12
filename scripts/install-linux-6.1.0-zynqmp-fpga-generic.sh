#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
REPO_DIR=$(cd $(dirname $0); cd .. ; pwd)
KERNEL_VERSION=6.1.0
LOCAL_VERSION=zynqmp-fpga-generic
BUILD_VERSION=3

. "$SCRIPT_DIR/install-variables-zynqmp-fpga.sh"
. "$SCRIPT_DIR/install-command.sh"
