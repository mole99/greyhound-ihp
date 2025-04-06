#ifndef __CHIP_H__
#define __CHIP_H__

#define FLASH_BASE      0x00000000
#define SRAM_BASE       0x10000000
#define PSRAM_BASE      0x20000000
#define UART0_BASE      0x30000000

#define FABRIC_CONFIG_BASE      0x40000000


#define REG_XIF_OR_PERIPH       (volatile int*)(FABRIC_CONFIG_BASE + 0)
#define REG_FABRIC_CONFIG_BUSY  (volatile int*)(FABRIC_CONFIG_BASE + 4)
#define REG_BITSTREAM           (volatile int*)(FABRIC_CONFIG_BASE + 8)
#define REG_TRIGGER_SLOT        (volatile int*)(FABRIC_CONFIG_BASE + 12)

#define FABRIC_BASE      0x50000000

#endif
