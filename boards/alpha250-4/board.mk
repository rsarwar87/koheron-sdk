# Linux and U-boot
<<<<<<< HEAD
UBOOT_CONFIG = zynq_alpha250_defconfig  
ZYNQ_TYPE ?= zynq
UBOOT_TAG := xilinx-uboot-v$(VIVADO_VERSION)
LINUX_TAG := xilinx-linux-v$(VIVADO_VERSION)
=======
UBOOT_TAG := koheron-v$(VIVADO_VERSION)
LINUX_TAG := koheron-v$(VIVADO_VERSION)-kernel-module-fix-dma
>>>>>>> d8bf2165890c46bf522f1053ba7f3597f99ddbb7
DTREE_TAG := xilinx-v$(VIVADO_VERSION)

UBOOT_URL := https://github.com/Xilinx/u-boot-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
LINUX_URL := https://github.com/Xilinx/linux-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/$(DTREE_TAG).tar.gz
