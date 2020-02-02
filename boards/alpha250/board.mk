# Linux and U-boot
ZYNQ_TYPE ?= zynq
VIVADO_VER = 2017.4
VIVADO_VER2 = 2017.2
UBOOT_TAG := koheron-v$(VIVADO_VER)
LINUX_TAG := koheron-v$(VIVADO_VER2)-kernel-module
DTREE_TAG := xilinx-v$(VIVADO_VER)

UBOOT_URL := https://github.com/Koheron/u-boot-xlnx/archive/$(UBOOT_TAG).tar.gz
LINUX_URL := https://github.com/Koheron/linux-xlnx/archive/$(LINUX_TAG).tar.gz
DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/$(DTREE_TAG).tar.gz
