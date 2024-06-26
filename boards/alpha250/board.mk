# Linux and U-boot
UBOOT_CONFIG = zynq_alpha250_defconfig
ZYNQ_TYPE ?= zynq
UBOOT_TAG := xilinx-uboot-v$(VIVADO_VERSION)
LINUX_TAG := xilinx-linux-v$(VIVADO_VERSION)
DTREE_TAG := xilinx-v$(VIVADO_VERSION)
ifeq ($(shell echo "$(VIVADO_VERSION) > 2021.0" | bc), 1)
   DTREE_TAG := xilinx_v$(VIVADO_VERSION)
endif

UBOOT_URL := https://github.com/Xilinx/u-boot-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
LINUX_URL := https://github.com/Xilinx/linux-xlnx/archive/refs/tags/xilinx-v$(VIVADO_VERSION).tar.gz
DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/refs/tags/$(DTREE_TAG).tar.gz

FSBL_PATH := $(OS_PATH)/alpha/fsbl
