# Linux and U-boot
UBOOT_CONFIG = zynq_mars_zx3_defconfig 
DTREE_OVERRIDE = arch/arm/boot/dts/zynq-mars-zx3.dtb
DTREE_LOC = linux  
UBOOT_TAG := enclustra-uboot-v1.8.tar.gz
LINUX_TAG := xilinx-linux-v$(VIVADO_VERSION)
DTREE_TAG := xilinx-v$(VIVADO_VERSION)
ZYNQ_TYPE := zynq

BOOT_MEDIUM := mmcblk0

UBOOT_URL := https://github.com/enclustra-bsp/xilinx-uboot/archive/v1.8.2.tar.gz
LINUX_URL := https://github.com/Xilinx/linux-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/xilinx-v2020.1.tar.gz
