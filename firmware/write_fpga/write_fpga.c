#include <stdio.h>
#include <stdint.h>
#include <soc.h>

#include "all_ones.h"

const static uint32_t fpga_all_ones_bitstream_alter[] = {
  0x00aaff01, 0x00000003, 0x00000000, 0x00000000, 0xfab0fab1, 0x00000001,
  0x00000000, 0xcb940000, 0xc9900000, 0xc9900000, 0xc3840000, 0xc1800000, 
  0xcb940000, 0xc3840000, 0xc3840000, 0xc9900000, 0xcf9c0000, 0xc1800000,
  0xcb940000, 0xc5880000, 0xcb940000, 0xc3840000, 0xcd980000, 0x00000000,
  0x00100000
};

int main()
{
  // Write bitstream to fpga
  for (uint32_t i = 0; i < sizeof(fpga_all_ones_bitstream)/sizeof(uint32_t); i++) {
    *REG_BITSTREAM = fpga_all_ones_bitstream[i];
  }

  // Wait for FPGA to finish configuration
  while (*REG_FABRIC_CONFIG_BUSY) {;}

  // Do nothing for some time so tb can start to write over jtag
  for (uint16_t  i = 0; i < 0x400; i++) {
    asm volatile ("nop");
  }

  // Wait for FPGA to finish configuration
  while (*REG_FABRIC_CONFIG_BUSY) {;}

  // Change bitstream version number only
  for (uint32_t i = 0; i < sizeof(fpga_all_ones_bitstream_alter)/sizeof(uint32_t); i++) {
    *REG_BITSTREAM = fpga_all_ones_bitstream_alter[i];
  }

  // Wait for FPGA to finish configuration
  while (*REG_FABRIC_CONFIG_BUSY) {;}

  return 0;
}
