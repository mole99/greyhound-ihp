CV_SW_TOOLCHAIN  ?= /opt/riscv
RISCV            ?= $(CV_SW_TOOLCHAIN)
RISCV_EXE_PREFIX ?= $(RISCV)/bin/riscv32-unknown-elf-
RISCV_CC         ?= gcc
RISCV_GCC = $(RISCV_EXE_PREFIX)$(RISCV_CC)
RISCV_AR = $(RISCV_EXE_PREFIX)ar
RISCV_MARCH ?= rv32ima_zicsr #rv32imc_zicsr
SRC = crt0.S handlers.S syscalls.c vectors.S drivers/EF_UART/EF_UART.c
OBJ = crt0.o handlers.o syscalls.o vectors.o drivers/EF_UART/EF_UART.o
BSP = bsp.a
CFLAGS ?= -Os -g -static -mabi=ilp32 -march=$(RISCV_MARCH) -Wall -pedantic $(RISCV_CFLAGS) -I . -I drivers/EF_UART

all: $(BSP)

$(BSP): $(OBJ)
	$(RISCV_AR) rcs $@ $(OBJ)

%.o : %.c
	$(RISCV_GCC) $(CFLAGS) -c $< -o $@

%.o : %.S
	$(RISCV_GCC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(BSP)


vars:
	@echo "make bsp variables:"
	@echo "   CV_SW_TOOLCHAIN  = $(CV_SW_TOOLCHAIN)"
	@echo "   RISCV            = $(RISCV)"
	@echo "   RISCV_EXE_PREFIX = $(RISCV_EXE_PREFIX)"
	@echo "   RISCV_GCC        = $(RISCV_GCC)"
	@echo "   RISCV_MARCH      = $(RISCV_MARCH)"
	@echo "   RISCV_CFLAGS     = $(RISCV_CFLAGS)"
	@echo "   CFLAGS           = $(CFLAGS)"
