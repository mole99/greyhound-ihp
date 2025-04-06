/*! \file EF_UART.h
    \brief C header file for UART APIs which contains the function prototypes 
    
*/


#ifndef EF_UART_H
#define EF_UART_H

#include <EF_UART_regs.h>
#include <stdint.h>
#include <stdbool.h>

enum parity_type {NONE = 0, ODD = 1, EVEN = 2, STICKY_0 = 4, STICKY_1 = 5};

void EF_UART_setGclkEnable (uint32_t uart_base, int value);

//! enables using uart by setting "en" bit in the control register to 1 
    /*!
      \param uart_base The base memory address of UART registers.
    */
void EF_UART_enable(uint32_t uart_base);


//! disables using uart by clearing "en" bit in the control register
    /*!
    \param uart_base The base memory address of UART registers.
    */  
void EF_UART_disable(uint32_t uart_base);


//! enables using uart RX by setting uart "rxen" bit in the control register to 1 
    /*!
    \param uart_base The base memory address of UART registers.
    */
void EF_UART_enableRx(uint32_t uart_base);


//! disables using uart RX by clearing uart "rxen" bit in the control register
    /*!
    \param uart_base The base memory address of UART registers.
    */
void EF_UART_disableRx(uint32_t uart_base);


//! enables using uart TX by setting uart "txen" bit in the control register to 1 
    /*!
    \param uart_base The base memory address of UART registers.
    */
void EF_UART_enableTx(uint32_t uart_base);


//! disables using uart TX by clearing uart "txen" bit in the control register
    /*!
    \param uart_base The base memory address of UART registers.
*/
void EF_UART_disableTx(uint32_t uart_base);


//! enables loopback (connecting TX to RX signal) by setting "lpen" bit in the control register to 1 
    /*!
    \param uart_base The base memory address of UART registers.
*/
void EF_UART_enableLoopBack(uint32_t uart_base);


//! disables loopback (connecting TX to RX signal) by clearing "lpen" bit in the control register
    /*!
    \param uart_base The base memory address of UART registers.
*/
void EF_UART_disableLoopBack(uint32_t uart_base);


//! enables glitch filter (filter out noise or glitches on the received signal) by setting "gfen" bit in the control register to 1 
    /*!
    \param uart_base The base memory address of UART registers.
*/
void EF_UART_enableGlitchFilter(uint32_t uart_base);


//! disables glitch filter (filter out noise or glitches on the received signal) by clearing "gfen" bit in the control register
    /*!
    \param uart_base The base memory address of UART registers.
*/
void EF_UART_disableGlitchFilter(uint32_t uart_base);


//! sets the control register to a certain value where
//! *  bit 0: UART enable
//! *  bit 1: UART Transmitter enable
//! *  bit 2: UART Receiver enable
//! *  bit 3: Loopback (connect RX and TX pins together) enable
//! *  bit 4: UART Glitch Filer on RX enable
    /*!
      \param uart_base The base memory address of UART registers.
      \param value The value of the control register

    */
void EF_UART_setCTRL(uint32_t uart_base, int value);


//! returns the value of the control register
    /*!
      \param uart_base The base memory address of UART registers.
      \return control register value 
    */
int EF_UART_getCTRL(uint32_t uart_base);


//! sets the Data Size (Data word length: 5-9 bits ) by setting the "wlen" field in configuration register 
    /*!
      \param uart_base The base memory address of UART registers.
      \param value The value of the required data word length  

    */
void EF_UART_setDataSize(uint32_t uart_base, int value);


//! sets the "stp2" bit in configuration register (whether the stop boits are two or one)
    /*!
      \param uart_base The base memory address of UART registers.
      \param is_two_bits bool value, if "true", the stop bits are two and if "false", the stop bit is one

    */
void EF_UART_setTwoStopBitsSelect(uint32_t uart_base, bool is_two_bits);


//! sets the "parity" field  in configuration register (could be none, odd, even, sticky 0 or sticky 1)
    /*!
      \param uart_base The base memory address of UART registers.
      \param parity enum parity_type could be "NONE" , "ODD" , "EVEN" ,  "STICKY_0" , or  "STICKY_1"

    */
void EF_UART_setParityType(uint32_t uart_base, enum parity_type parity);


//! sets the "timeout" field in configuration register which is receiver timeout measured in number of bits at which the timeout flag will be raised
    /*!
      \param uart_base The base memory address of UART registers.
      \param value timeout bits value 

    */
void EF_UART_setTimeoutBits(uint32_t uart_base, int value);


//! sets the configuration register to a certain value where
//! *  bit 0-3: Data word length: 5-9 bits
//! *  bit 4: Two Stop Bits Select
//! *  bit 5-7: Parity Type: 000: None, 001: odd, 010: even, 100: Sticky 0, 101: Sticky 1
//! *  bit 8-13: Receiver Timeout measured in number of bits
    /*!
      \param uart_base The base memory address of UART registers.
      \param config The value of the configuration register

    */
void EF_UART_setConfig(uint32_t uart_base, int config);


//! returns the value of the configuration register
    /*!
      \param uart_base The base memory address of UART registers.
      \return configuration register value 
    */
int EF_UART_getConfig(uint32_t uart_base);


//! sets the RX FIFO threshold to a certain value at which "RXA" interrupt will be raised 
    /*!
      \param uart_base The base memory address of UART registers.
      \param threshold The value of the required threshold 

    */
void EF_UART_setRxFIFOThreshold(uint32_t uart_base, int threshold);


//! returns the current value of the RX FIFO  threshold
    /*!
      \param uart_base The base memory address of UART registers.
      \return RX FIFO threshold register
    */
int EF_UART_getRxFIFOThreshold(uint32_t uart_base);


//! sets the TX FIFO threshold to a certain value at which "TXB" interrupt will be raised 
    /*!
      \param uart_base The base memory address of UART registers.
      \param threshold The value of the required threshold 

    */
void EF_UART_setTxFIFOThreshold(uint32_t uart_base, int threshold);


//! returns the current value of the TX FIFO  threshold
    /*!
      \param uart_base The base memory address of UART registers.
      \return TX FIFO threshold register
    */
int EF_UART_getTxFIFOThreshold(uint32_t uart_base);



//! sets the matchData to a certain value at which "MATCH" interrupt will be raised 
    /*!
      \param uart_base The base memory address of UART registers.
      \param matchData The value of the required match data  

    */
void EF_UART_setMatchData(uint32_t uart_base, int matchData);


//! returns the value of the match data register
    /*!
      \param uart_base The base memory address of UART registers.
      \return match data register value 
    */
int EF_UART_getMatchData(uint32_t uart_base);


//! returns the current level of the TX FIFO (the number of bytes in the FIFO)
    /*!
      \param uart_base The base memory address of UART registers.
      \return TX FIFO level register
    */
int EF_UART_getTxCount(uint32_t uart_base);


//! returns the current level of the RX FIFO (the number of bytes in the FIFO)
    /*!
      \param uart_base The base memory address of UART registers.
      \return RX FIFO level register
    */
int EF_UART_getRxCount(uint32_t uart_base);


//! sets the prescaler to a certain value where Baud_rate = Bus_Clock_Freq/((Prescaler+1)*16)
    /*!
      \param uart_base The base memory address of UART registers.
      \param prescaler The value of the required prescaler 

    */
void EF_UART_setPrescaler(uint32_t uart_base, int prescaler);


//! returns the value of the prescaler
    /*!
      \param uart_base The base memory address of UART registers.
      \return prescaler register value 
    */
int EF_UART_getPrescaler(uint32_t uart_base);


//! returns the value of the Raw Interrupt Status Register
//! *  bit 0 TXE : Transmit FIFO is Empty.
//! *  bit 1 RXF :  Receive FIFO is Full.
//! *  bit 2 TXB : Transmit FIFO level is Below Threshold.
//! *  bit 3 RXA : Receive FIFO level is Above Threshold.
//! *  bit 4 BRK : Line Break; 13 consecutive 0's have been detected on the line.
//! *  bit 5 MATCH : the receive data matches the MATCH register.
//! *  bit 6 FE : Framing Error, the receiver does not see a "stop" bit at the expected "stop" bit time.
//! *  bit 7 PRE : Parity Error; the receiver calculated parity does not match the received one.
//! *  bit 8 OR : Overrun; data has been received but the RX FIFO is full.
//! *  bit 9 RTO : Receiver Timeout; no data has been received for the time of a specified number of bits.
    /*!
      \param uart_base The base memory address of UART registers.
      \return RIS register value 
    */
int EF_UART_getRIS(uint32_t uart_base);


//! returns the value of the Masked Interrupt Status Register
//! *  bit 0 TXE : Transmit FIFO is Empty.
//! *  bit 1 RXF :  Receive FIFO is Full.
//! *  bit 2 TXB : Transmit FIFO level is Below Threshold.
//! *  bit 3 RXA : Receive FIFO level is Above Threshold.
//! *  bit 4 BRK : Line Break; 13 consecutive 0's have been detected on the line.
//! *  bit 5 MATCH : the receive data matches the MATCH register.
//! *  bit 6 FE : Framing Error, the receiver does not see a "stop" bit at the expected "stop" bit time.
//! *  bit 7 PRE : Parity Error; the receiver calculated parity does not match the received one.
//! *  bit 8 OR : Overrun; data has been received but the RX FIFO is full.
//! *  bit 9 RTO : Receiver Timeout; no data has been received for the time of a specified number of bits.
    /*!
      \param uart_base The base memory address of UART registers.
      \return MIS register value 
    */
int EF_UART_getMIS(uint32_t uart_base);


//! sets the value of the Interrupts Masking Register; which enable and disables interrupts
//! *  bit 0 TXE : Transmit FIFO is Empty.
//! *  bit 1 RXF :  Receive FIFO is Full.
//! *  bit 2 TXB : Transmit FIFO level is Below Threshold.
//! *  bit 3 RXA : Receive FIFO level is Above Threshold.
//! *  bit 4 BRK : Line Break; 13 consecutive 0's have been detected on the line.
//! *  bit 5 MATCH : the receive data matches the MATCH register.
//! *  bit 6 FE : Framing Error, the receiver does not see a "stop" bit at the expected "stop" bit time.
//! *  bit 7 PRE : Parity Error; the receiver calculated parity does not match the received one.
//! *  bit 8 OR : Overrun; data has been received but the RX FIFO is full.
//! *  bit 9 RTO : Receiver Timeout; no data has been received for the time of a specified number of bits.
    /*!
      \param uart_base The base memory address of UART registers.
      \param mask The required mask value
    */
void EF_UART_setIM(uint32_t uart_base, int mask);


//! returns the value of the Interrupts Masking Register; which enable and disables interrupts
//! *  bit 0 TXE : Transmit FIFO is Empty.
//! *  bit 1 RXF :  Receive FIFO is Full.
//! *  bit 2 TXB : Transmit FIFO level is Below Threshold.
//! *  bit 3 RXA : Receive FIFO level is Above Threshold.
//! *  bit 4 BRK : Line Break; 13 consecutive 0's have been detected on the line.
//! *  bit 5 MATCH : the receive data matches the MATCH register.
//! *  bit 6 FE : Framing Error, the receiver does not see a "stop" bit at the expected "stop" bit time.
//! *  bit 7 PRE : Parity Error; the receiver calculated parity does not match the received one.
//! *  bit 8 OR : Overrun; data has been received but the RX FIFO is full.
//! *  bit 9 RTO : Receiver Timeout; no data has been received for the time of a specified number of bits.
    /*!
      \param uart_base The base memory address of UART registers.
      \return IM register value 
    */
int EF_UART_getIM(uint32_t uart_base);


//! sets the value of the Interrupts Clear Register; write 1 to clear the flag
//! *  bit 0 TXE : Transmit FIFO is Empty.
//! *  bit 1 RXF :  Receive FIFO is Full.
//! *  bit 2 TXB : Transmit FIFO level is Below Threshold.
//! *  bit 3 RXA : Receive FIFO level is Above Threshold.
//! *  bit 4 BRK : Line Break; 13 consecutive 0's have been detected on the line.
//! *  bit 5 MATCH : the receive data matches the MATCH register.
//! *  bit 6 FE : Framing Error, the receiver does not see a "stop" bit at the expected "stop" bit time.
//! *  bit 7 PRE : Parity Error; the receiver calculated parity does not match the received one.
//! *  bit 8 OR : Overrun; data has been received but the RX FIFO is full.
//! *  bit 9 RTO : Receiver Timeout; no data has been received for the time of a specified number of bits.
    /*!
      \param uart_base The base memory address of UART registers.
      \param mask The required mask value
    */
void EF_UART_setICR(uint32_t uart_base, int mask);


//! transmit an array of characters through uart 
    /*!
      \param uart_base The base memory address of UART registers.
      \param char_arr An array of characters to send 

    */
void EF_UART_writeCharArr(uint32_t uart_base, const char *char_arr);


//! transmit a single character through uart 
    /*!
      \param uart_base The base memory address of UART registers.
      \param data The character or byte required to send 

    */
void EF_UART_writeChar(uint32_t uart_base, char data);


//! recieve a single character through uart 
    /*!
      \param uart_base The base memory address of UART registers.
      \return the byte recieved 

    */
int EF_UART_readChar(uint32_t uart_base);

#endif