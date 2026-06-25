# Linux and U-Boot defaults for TEB0911
UBOOT_CONFIG = xilinx_zynqmp_virt_defconfig
ZYNQ_TYPE := zynqmp

UBOOT_TAG := xilinx-uboot-v$(VIVADO_VERSION)
LINUX_TAG := xilinx-linux-v$(VIVADO_VERSION)
DTREE_TAG := xilinx_v$(VIVADO_VERSION)

UBOOT_URL := https://github.com/Xilinx/u-boot-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
LINUX_URL := https://github.com/Xilinx/linux-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/refs/tags/$(DTREE_TAG).tar.gz
