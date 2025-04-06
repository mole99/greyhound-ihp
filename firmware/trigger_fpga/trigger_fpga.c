#include <stdio.h>

#include <soc.h>

int main()
{
  // Trigger configuration from slot 0
  *REG_TRIGGER_SLOT = 0;

  // Wait for FPGA to finish configuration
  while (*REG_FABRIC_CONFIG_BUSY) {;}

  // Trigger configuration from slot 1
  *REG_TRIGGER_SLOT = 1;

  // Wait for FPGA to finish configuration
  while (*REG_FABRIC_CONFIG_BUSY) {;}

  return 0;
}
