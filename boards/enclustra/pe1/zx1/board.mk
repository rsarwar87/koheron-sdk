# Linux and U-boot
UBOOT_CONFIG = zynq_pe1_zx1_defconfig
DTREE_OVERRIDE = arch/arm/boot/dts/zynq-mercury-zx1.dtb
DTREE_LOC = linux  
UBOOT_TAG := enclustra-uboot-v$(VIVADO_VERSION)
LINUX_TAG := enclustra-linux-v$(VIVADO_VERSION)
DTREE_TAG := xilinx-v$(VIVADO_VERSION)

UBOOT_URL := https://github.com/Xilinx/u-boot-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
LINUX_URL := https://github.com/Xilinx/linux-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/$(DTREE_TAG).tar.gz
