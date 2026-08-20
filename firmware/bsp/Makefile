RISCV_EXE_PREFIX ?= riscv32-none-elf-
RISCV_CC         ?= gcc
RISCV_GCC = $(RISCV_EXE_PREFIX)$(RISCV_CC)
RISCV_AR = $(RISCV_EXE_PREFIX)ar
RISCV_MARCH ?= rv32imac_zicntr_zicsr_zifencei_zihpm_zca_zcb_zcmp_zcmt_zba_zbb_zbc_zbs
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
