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
  
  #define BITSTREAM_LENGTH_WORDS 0xEA2
  #define BITSTREAM_FLASH_OFFSET_WORDS (0x10000>>2)
  
  for (int i=0; i<BITSTREAM_LENGTH_WORDS; i++) {
  
    int bitstream_data = *((volatile int*)FLASH_BASE + BITSTREAM_FLASH_OFFSET_WORDS + i);
  
    // Perform endiannes swap
    // FABulous: big-endian
    // RISC-V: little-endian
    
    int swapped = ((bitstream_data>>24) & 0x000000ff) | // move byte 3 to byte 0
                  ((bitstream_data<< 8) & 0x00ff0000) | // move byte 1 to byte 2
                  ((bitstream_data>> 8) & 0x0000ff00) | // move byte 2 to byte 1
                  ((bitstream_data<<24) & 0xff000000);  // byte 0 to byte 3
  
    *REG_BITSTREAM = swapped;
  }
  
  // Set CPU_IF to xif
  *REG_XIF_OR_PERIPH = 0;
  
  // Execute custom instruction
  int a = 0x258AE222;
  int b = 0x0EED42E6;
  int c;
  __asm__ volatile (".insn r 0x5b, 0, 13, %0, %1, %2" : "=r" (c)
                                                       : "r" (a),
                                                         "r" (b));

  // Write using UART
  printf("0x%X\n", c);

  return 0;
}
