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

  // enable machine mode interrupts, mstatus.mie
  asm volatile ("csrs mstatus, 0x8");

  // enable fast interrupts 0-3
  int enable_fast_interrupts = 0x000F0000;
  asm volatile ("csrs mie, %0" :: "r" (enable_fast_interrupts));

  return 0;
}

void m_fast0_irq_handler() {
  printf("Interrupt!\n");
}
