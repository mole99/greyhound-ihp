#include <stdio.h>

#include <soc.h>
#include <EF_UART.h>

#define F_CPU 50000000
#define BAUDRATE 115200

int main()
{
  EF_UART_setGclkEnable(UART0_BASE, 1);
  EF_UART_enable(UART0_BASE);
  EF_UART_enableRx(UART0_BASE);
  EF_UART_enableTx(UART0_BASE);
  EF_UART_disableLoopBack(UART0_BASE);
  EF_UART_disableGlitchFilter(UART0_BASE);

  EF_UART_setDataSize(UART0_BASE, 8);
  EF_UART_setTwoStopBitsSelect(UART0_BASE, false);
  EF_UART_setParityType(UART0_BASE, NONE);
  EF_UART_setTimeoutBits(UART0_BASE, 0);
  // baudrate = clock_f / ((PR+1)*8)
  EF_UART_setPrescaler(UART0_BASE, F_CPU/(BAUDRATE*8)-1);

  // Wait for FPGA to finish configuration
  while (*REG_FABRIC_CONFIG_BUSY) {;}
  
  // Set CPU_IF to peripheral
  *REG_XIF_OR_PERIPH = 1;
  
  int* fabric_peripheral = (int*)FABRIC_BASE;
  
  int ok = 1;
  
  // For each SRAM
  for (int j=0; j<7; j++) {
  
    for (int i=0; i<32; i++) {
      *(fabric_peripheral + i + (j * (0x1000>>2))) = 0x21787456 + i + j;
    }
    
    for (int i=0; i<32; i++) {
      if (*(fabric_peripheral + i + (j * (0x1000>>2))) != 0x21787456 + i + j) {
        ok = 0;
      }
    }
  }
  
  if (ok) {
    printf("Ok!\n");
  } else {
    printf("Not ok!\n");
  }

  return 0;
}
