# Linux and U-boot
UBOOT_CONFIG = enclustra_zynqmp_mercury_xu1_defconfig  
ZYNQ_TYPE ?= zynqmp
DTREE_OVERRIDE = arch/arm64/boot/dts/xilinx/zynqmp-enclustra-xu1.dtb
DTREE_LOC = linux  
UBOOT_TAG := enclustra-uboot-v$(VIVADO_VERSION)
LINUX_TAG := enclustra-linux-v$(VIVADO_VERSION)
DTREE_TAG := xilinx-v$(VIVADO_VERSION)
ZYNQ_TYPE := zynqmp

BOOT_MEDIUM := mmcblk1

UBOOT_URL := https://github.com/enclustra-bsp/xilinx-uboot/archive/v1.8.2.tar.gz
LINUX_URL := https://github.com/rsarwar87/enclustra_kernel_xilinx/archive/2020.1-2.tar.gz
DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/xilinx-v2020.1.tar.gz
