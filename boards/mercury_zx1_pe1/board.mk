# Linux and U-boot
UBOOT_CONFIG = zynq_pe1_zx1_defconfig
DTREE_OVERRIDE = arch/arm/boot/dts/zynq-mercury-zx1.dtb
DTREE_LOC = linux  
UBOOT_TAG := enclustra-uboot-v1.8.tar.gz
LINUX_TAG := xilinx-linux-v$(VIVADO_VERSION)
DTREE_TAG := xilinx-v$(VIVADO_VERSION)

UBOOT_URL := https://github.com/enclustra-bsp/xilinx-uboot/archive/v1.8.tar.gz
LINUX_URL := https://github.com/Xilinx/linux-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
TREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/xilinx-v2020.1.tar.gz
