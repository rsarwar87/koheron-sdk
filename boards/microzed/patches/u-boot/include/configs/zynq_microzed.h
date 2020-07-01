#include <configs/zynq-common.h>
#define CONFIG_EXTRA_ENV_SETTINGS \
      "fdt_high=0x10000000\0" \
      "preboot=env import -t 0xFFFFFC00\0" \
      "sdboot=echo Importing environment from SD... && mmcinfo && fatload mmc 0 0x2000000 uEnv.txt && env import -t 0x2000000 ${filesize} && boot"
