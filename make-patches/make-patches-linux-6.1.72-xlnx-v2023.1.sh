#!/bin/bash

BASE_KERNEL_RELEASE=6.1.70
BASE_KERNEL_DIR=linux-${BASE_KERNEL_RELEASE}
BASE_X_KERNEL_RELEASE=${BASE_KERNEL_RELEASE}-xlnx-2023.1
BASE_X_KERNEL_DIR=linux-${BASE_X_KERNEL_RELEASE}

GOAL_KERNEL_RELEASE=6.1.72
GOAL_KERNEL_DIR=linux-${GOAL_KERNEL_RELEASE}

#
# Download Base Kernel Source Tree
#
# git clone --depth 1 -b v${BASE_KERNEL_RELEASE} git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git ${BASE_KERNEL_DIR}

#
# Download and Make Source Kernel Source Tree
#
# git clone --depth 1 -b v${BASE_KERNEL_RELEASE} git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git ${BASE_X_KERNEL_DIR}
# cd ${BASE_X_KERNEL_DIR}
# git checkout -b ${BASE_X_KERNEL_RELEASE}
# sh ../patches/linux-${BASE_X_KERNEL_RELEASE}/xxx_patch.sh
# cd ..

#
# Make diff.txt ${BASE_KERNEL_DIR} and ${BASE_X_KERNEL_DIR} 
# 
ruby make-patches/source-tree-diff-list.rb -T linux-${BASE_KERNEL_RELEASE}-${BASE_X_KERNEL_RELEASE} -o make-patches/diff-linux-${BASE_KERNEL_RELEASE}-${BASE_X_KERNEL_RELEASE}.txt -v ${BASE_KERNEL_DIR} ${BASE_X_KERNEL_DIR} 

#
# Download Goal Kernel Source Tree
#
git clone --depth 1 -b v${GOAL_KERNEL_RELEASE} git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git ${GOAL_KERNEL_DIR}

#
# Make diff.txt ${BASE_KERNEL_DIR} and ${GOAL_KERNEL_DIR} 
#
ruby make-patches/source-tree-diff-list.rb -T linux-${BASE_KERNEL_RELEASE}-${GOAL_KERNEL_RELEASE} -o make-patches/diff-linux-${BASE_KERNEL_RELEASE}-${GOAL_KERNEL_RELEASE}.txt -v ${BASE_KERNEL_DIR} ${GOAL_KERNEL_DIR} 

#
#
#
ruby make-patches/compare-diff-list.rb make-patches/diff-linux-${BASE_KERNEL_RELEASE}-${BASE_X_KERNEL_RELEASE}.txt make-patches/diff-linux-${BASE_KERNEL_RELEASE}-${GOAL_KERNEL_RELEASE}.txt


