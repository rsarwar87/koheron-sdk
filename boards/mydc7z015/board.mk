# Linux and U-boot
UBOOT_CONFIG = zynq_mydc7z015_defconfig  
ZYNQ_TYPE ?= zynq
UBOOT_TAG := xilinx-uboot-v$(VIVADO_VERSION)
LINUX_TAG := xilinx-linux-v$(VIVADO_VERSION)
DTREE_TAG := xilinx-v$(VIVADO_VERSION)

UBOOT_URL := https://github.com/Xilinx/u-boot-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
LINUX_URL := https://github.com/Xilinx/linux-xlnx/archive/xilinx-v$(VIVADO_VERSION).tar.gz
DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/$(DTREE_TAG).tar.gz

ver_ge = $(shell \
  if [ "$$(printf '%s\n%s\n' "$(2)" "$(1)" | sort -V | tail -n1)" = "$(1)" ]; then \
    echo 1; \
  else \
    echo 0; \
  fi \
)

# -------------------------
# DTREE changes at 2023.1
# -------------------------
ifeq ($(call ver_ge,$(VIVADO_VERSION),2023.1),1)
  # VIVADO_VERSION >= 2023.1
  DTREE_TAG := xilinx_v$(VIVADO_VERSION)
  DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/refs/tags/$(DTREE_TAG).tar.gz
else
  # VIVADO_VERSION < 2023.1
  DTREE_TAG := xilinx-v$(VIVADO_VERSION)
  DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/$(DTREE_TAG).tar.gz
endif


