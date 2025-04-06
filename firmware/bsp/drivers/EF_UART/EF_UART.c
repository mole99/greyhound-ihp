/*! \file EF_UART.c
    \brief C file for UART APIs which contains the function implmentations 
    
*/

#ifndef EF_UART_C
#define EF_UART_C

#include <EF_UART.h>

void EF_UART_setGclkEnable (uint32_t uart_base, int value){
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    uart->GCLK = value;
}

void EF_UART_enable(uint32_t uart_base){
   
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // set the enable bit to 1 at the specified offset
    uart->CTRL |= (1 << EF_UART_CTRL_REG_EN_BIT);
}

void EF_UART_disable(uint32_t uart_base){
   
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // Clear the enable bit using the specified  mask
    uart->CTRL &= ~EF_UART_CTRL_REG_EN_MASK;
}

void EF_UART_enableRx(uint32_t uart_base){
    
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // set the enable bit to 1 at the specified offset
    uart->CTRL |= (1 << EF_UART_CTRL_REG_RXEN_BIT);
}

void EF_UART_disableRx(uint32_t uart_base){
    
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // Clear the enable bit using the specified  mask
    uart->CTRL &= ~EF_UART_CTRL_REG_RXEN_MASK;
}

void EF_UART_enableTx(uint32_t uart_base){
    
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // set the enable bit to 1 at the specified offset
    uart->CTRL |= (1 << EF_UART_CTRL_REG_TXEN_BIT);
}

void EF_UART_disableTx(uint32_t uart_base){
    
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // Clear the enable bit using the specified  mask
    uart->CTRL &= ~EF_UART_CTRL_REG_TXEN_MASK;
}

void EF_UART_enableLoopBack(uint32_t uart_base){
    
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // set the enable bit to 1 at the specified offset
    uart->CTRL |= (1 << EF_UART_CTRL_REG_LPEN_BIT);
}

void EF_UART_disableLoopBack(uint32_t uart_base){
    
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // Clear the enable bit using the specified  mask
    uart->CTRL &= ~EF_UART_CTRL_REG_LPEN_MASK;
}

void EF_UART_enableGlitchFilter(uint32_t uart_base){
    
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // Clear the enable bit using the specified  mask
    uart->CTRL &= ~EF_UART_CTRL_REG_GFEN_MASK;

    // set the enable bit to 1 at the specified offset
    uart->CTRL |= (1 << EF_UART_CTRL_REG_GFEN_BIT);
}

void EF_UART_disableGlitchFilter(uint32_t uart_base){
    
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // Clear the enable bit using the specified  mask
    uart->CTRL &= ~EF_UART_CTRL_REG_GFEN_MASK;
}

void EF_UART_setCTRL(uint32_t uart_base, int value){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    uart->CTRL = value;
    
}

int EF_UART_getCTRL(uint32_t uart_base){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    return (uart->CTRL);
}

void EF_UART_setPrescaler(uint32_t uart_base, int prescaler){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    uart->PR = prescaler;
}

int EF_UART_getPrescaler(uint32_t uart_base){

   EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    return (uart->PR);
}


void EF_UART_setDataSize(uint32_t uart_base, int value){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // Clear the field bits in the register using the defined mask
    uart->CFG &= ~EF_UART_CFG_REG_WLEN_MASK;

    // Set the bits with the given value at the defined offset
    uart->CFG |= ((value << EF_UART_CFG_REG_WLEN_BIT) & EF_UART_CFG_REG_WLEN_MASK);
}

void EF_UART_setTwoStopBitsSelect(uint32_t uart_base, bool is_two_bits){

     EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
     
    if (is_two_bits){

        // set the enable bit to 1 at the specified offset
        uart->CFG |= (1 << EF_UART_CFG_REG_STP2_BIT);

    }
    else {
        // Clear the enable bit using the specified  mask
        uart->CFG &= ~EF_UART_CFG_REG_STP2_MASK;
    }
}

void EF_UART_setParityType(uint32_t uart_base, enum parity_type parity){

     EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // Clear the field bits in the register using the defined mask
    uart->CFG &= ~EF_UART_CFG_REG_PARITY_MASK;

    // Set the bits with the given value at the defined offset
    uart->CFG |= ((parity << EF_UART_CFG_REG_PARITY_BIT) & EF_UART_CFG_REG_PARITY_MASK);
}

void EF_UART_setTimeoutBits(uint32_t uart_base, int value){

     EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    // Clear the field bits in the register using the defined mask
    uart->CFG &= ~EF_UART_CFG_REG_TIMEOUT_MASK;

    // Set the bits with the given value at the defined offset
    uart->CFG |= ((value << EF_UART_CFG_REG_TIMEOUT_BIT) & EF_UART_CFG_REG_TIMEOUT_MASK);
}

void EF_UART_setConfig(uint32_t uart_base, int value){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    uart->CFG = value;
}

int EF_UART_getConfig(uint32_t uart_base){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    return (uart->CFG);
}

void EF_UART_setRxFIFOThreshold(uint32_t uart_base, int value){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    uart->RX_FIFO_THRESHOLD = value;
}

int EF_UART_getRxFIFOThreshold(uint32_t uart_base){

     EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    return (uart->RX_FIFO_THRESHOLD);

}

void EF_UART_setTxFIFOThreshold(uint32_t uart_base, int value){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    uart->TX_FIFO_THRESHOLD=value;
}

int EF_UART_getTxFIFOThreshold(uint32_t uart_base){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    return (uart->TX_FIFO_THRESHOLD);

}


int EF_UART_getTxCount(uint32_t uart_base){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    return(uart->TX_FIFO_LEVEL);
}

int EF_UART_getRxCount(uint32_t uart_base){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    return(uart->RX_FIFO_LEVEL);
}


void EF_UART_setMatchData(uint32_t uart_base, int matchData){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;

    uart->MATCH = matchData;
}

int EF_UART_getMatchData(uint32_t uart_base){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    return (uart->MATCH);
}

 // Interrupts bits in RIS, MIS, IM, and ICR
 // bit 0: TX FIFO is Empty
 // bit 1: TX FIFO level is below the value in the TX FIFO Level Threshold Register
 // bit 2: RX FIFO is Full
 // bit 3: RX FIFO level is above the value in the RX FIFO Level Threshold Register
 // bit 4: line break
 // bit 5: match
 // bit 6: frame error
 // bit 7: parity error
 // bit 8: overrun 
 // bit 9: timeout 

int EF_UART_getRIS(uint32_t uart_base){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    return (uart->RIS);
}

int EF_UART_getMIS(uint32_t uart_base){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    return (uart->MIS);
}

void EF_UART_setIM(uint32_t uart_base, int mask){
   
    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    uart->IM |= mask;
}

int EF_UART_getIM(uint32_t uart_base){

   EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    return (uart->IM);
}

void EF_UART_setICR(uint32_t uart_base, int mask){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    (uart->IC) |= mask;
}


void EF_UART_writeChar(uint32_t uart_base, char data){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    while((EF_UART_getRIS(uart_base) & EF_UART_TXE_FLAG) == 0x0); // wait until TX empty flag is 1  
    uart->TXDATA = data;
    EF_UART_setICR(uart_base, EF_UART_TXE_FLAG);
}

void EF_UART_writeCharArr(uint32_t uart_base, const char *char_arr){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    while (*char_arr){
        while((EF_UART_getRIS(uart_base) & EF_UART_TXB_FLAG) == 0x0); // wait until tx level below flag is 1
        uart->TXDATA = (*(char_arr++));
        EF_UART_setICR(uart_base, EF_UART_TXB_FLAG);
    }
}

/*void EF_UART_writeInt(uint32_t uart_base, char data){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    while((EF_UART_getRIS(uart_base) & 0x2) == 0x0); // wait when level is above threshold (fifo is full)
    uart->txdata = data;
    EF_UART_setICR(uart_base, 0x2);
}*/

int EF_UART_readChar(uint32_t uart_base){

    EF_UART_TYPE* uart = (EF_UART_TYPE*)uart_base;
    while((EF_UART_getRIS(uart_base) & EF_UART_RXA_FLAG) == 0x0); // wait over RX fifo level above flag to be 1
    int data = uart->RXDATA;
    EF_UART_setICR(uart_base, EF_UART_RXA_FLAG);

    return data;
}

#endif // EF_UART_C