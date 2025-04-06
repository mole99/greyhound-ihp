/* Script for -z combreloc */
/* Copyright (C) 2014-2020 Free Software Foundation, Inc.
   Copyright (C) 2019 ETH Zürich and University of Bologna
   Copyright (C) 2020 OpenHW Group
   Copying and distribution of this script, with or without modification,
   are permitted in any medium without royalty provided the copyright
   notice and this notice are preserved.  */

/* This linker script is adapted from the default linker script for upstream
   RISC-V GCC.  It has been modified for use in verification of CORE-V cores.
*/

OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv",
        "elf32-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)

/* CORE-V */
MEMORY
{
  /* Our testbench is a bit weird in that we initialize the RAM (thus
     allowing initialized sections to be placed there). Infact we dump all
     sections to ram. */

  flash (irx!wa) : ORIGIN = 0x00000000, LENGTH = 0x400000 /* 4MB */
  sram  (rwxa!i) : ORIGIN = 0x10000000, LENGTH = 0x2000 /* 8kB */
  psram (rwxa!i) : ORIGIN = 0x20000000, LENGTH = 0x400000
  /*dbg (rwxai) : ORIGIN = 0x1A110800, LENGTH = 0x1000*/
}

SECTIONS
{
    /* CORE-V: we want a fixed entry point */
    PROVIDE(__boot_address = 0x80);

    /* CORE-V: interrupt vectors */
    .vectors (ORIGIN(flash)):
    {
      PROVIDE(__vector_start = .);
      KEEP(*(.vectors));
    } >flash

    /* CORE-V: crt0 init code */
    .init (__boot_address):
    {
      KEEP (*(SORT_NONE(.init)))
      KEEP (*(.text.start))
    } >flash

    /* NMI interrupt handler fixed entry point */
    /*PROVIDE(__nmi_address = 0x100000);*/

    .nmi : /*(__nmi_address):*/
    {
      KEEP(*(.nmi));
    } >flash

    /* The program code and other data goes into FLASH */
    .text :
    {
        . = ALIGN(4);
        *(.reset_vector*)
        *(.text)           /* .text sections (code) */
        *(.text*)          /* .text* sections (code) */
        *(.rodata)         /* .rodata sections (constants, strings, etc.) */
        *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
        *(.srodata)        /* .rodata sections (constants, strings, etc.) */
        *(.srodata*)       /* .rodata* sections (constants, strings, etc.) */
        . = ALIGN(4);
        _etext = .;        /* define a global symbol at end of code */
        _sidata = _etext;  /* This is used by the startup to initialize data */
    } >flash
    
    /* Initialized data section */
    .data : AT ( _sidata )
    {
        . = ALIGN(4);
        _sdata = .;
        _ram_start = .;
        *(.data)           /* .data sections */
        *(.data*)          /* .data* sections */
        *(.sdata)           /* .sdata sections */
        *(.sdata*)          /* .sdata* sections */
        . = ALIGN(4);
        _edata = .;        /* define a global symbol at data end */
    } >sram

    /* Uninitialized data section */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;         /* define a global symbol at bss start; used by startup code */
        *(.bss)
        *(.bss*)
        *(.sbss)
        *(.sbss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;         /* define a global symbol at bss end; used by startup code */
    } >sram

    __global_pointer$ = _sdata + 0x800;

    /* Define the start of the heap */
    .heap :
    {
        . = ALIGN(4);
        __heap_start = .;
    } >sram

    . = ALIGN(4);
    end = .;
}

PROVIDE(__heap_end = ORIGIN(sram) + LENGTH(sram));
PROVIDE(__stack_end = ORIGIN(sram) + LENGTH(sram));
