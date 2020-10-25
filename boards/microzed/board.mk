# Linux and U-boot
UBOOT_CONFIG = zynq_microzed_defconfig  
ZYNQ_TYPE = zynq
UBOOT_TAG := xilinx-v$(VIVADO_VERSION)
LINUX_TAG := xilinx-v$(VIVADO_VERSION)
DTREE_TAG := xilinx-v$(VIVADO_VERSION)

UBOOT_URL := https://github.com/Xilinx/u-boot-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
LINUX_URL := https://github.com/Xilinx/linux-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
TREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
