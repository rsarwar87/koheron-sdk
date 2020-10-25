#ifndef __CONFIG_ZYNQ_ALPHA250_H
#define __CONFIG_ZYNQ_ALPHA250_H
#include <configs/zynq-common.h>
#ifdef CONFIG_EXTRA_ENV_SETTINGS
#undef CONFIG_EXTRA_ENV_SETTINGS
#endif
#define CONFIG_EXTRA_ENV_SETTINGS \
      "fdt_high=0x10000000\0" \
      "preboot=env import -t 0xFFFFFC00\0" \
      "sdboot=echo Importing environment from SD... && mmcinfo && fatload mmc 0 0x2000000 uEnv.txt && env import -t 0x2000000 ${filesize} && boot"
#endif /* __CONFIG_ZYNQ_ALPHA250_H */
