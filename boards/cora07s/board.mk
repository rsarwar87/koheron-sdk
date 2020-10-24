# Linux and U-boot
UBOOT_CONFIG = zynq_cora_defconfig
ZYNQ_TYPE = zynq
DTREE_OVERRIDE = arch/arm/boot/dts/zynq-cora7s7.dtb
DTREE_LOC = linux  
UBOOT_TAG := xilinx-uboot-v$(VIVADO_VERSION)
LINUX_TAG := xilinx-linux-v$(VIVADO_VERSION)
DTREE_TAG := xilinx-v$(VIVADO_VERSION)

UBOOT_URL := https://github.com/Xilinx/u-boot-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
LINUX_URL := https://github.com/Xilinx/linux-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
TREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
