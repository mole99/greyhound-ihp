CV_SW_TOOLCHAIN  ?= /opt/riscv
RISCV            ?= $(CV_SW_TOOLCHAIN)
RISCV_EXE_PREFIX ?= $(RISCV)/bin/riscv32-unknown-elf-
RISCV_CC         ?= gcc
RISCV_GCC = $(RISCV_EXE_PREFIX)$(RISCV_CC)
RISCV_AR = $(RISCV_EXE_PREFIX)ar
RISCV_MARCH ?= rv32ima_zicsr #rv32imc_zicsr
PYTHON ?= python3
SRC = access_peripheral.c
OBJ = access_peripheral.o
CFLAGS ?= -Os -g -static -mabi=ilp32 -march=$(RISCV_MARCH) -Wall -pedantic $(RISCV_CFLAGS) -I ../bsp -I ../bsp/drivers/EF_UART

TARGET = access_peripheral
ELF_TARGET = $(TARGET).elf
BIN_TARGET = $(TARGET).bin
HEX_TARGET= $(TARGET).hex

BSP_PATH = ../bsp
LINKER_SCRIPT = $(BSP_PATH)/link.ld

LDFLAGS += -T $(LINKER_SCRIPT) -nostartfiles
LDFLAGS += -L$(ENV_DIR) --specs=nano.specs

all: $(HEX_TARGET)

%.o : %.c
	$(RISCV_GCC) $(CFLAGS) -c $< -o $@

%.o : %.S
	$(RISCV_GCC) $(CFLAGS) -c $< -o $@

$(ELF_TARGET): $(OBJ)
	$(RISCV_GCC) $(CFLAGS) $< -L$(BSP_PATH) -l:bsp.a -o $@ $(LDFLAGS)

$(BIN_TARGET): $(ELF_TARGET)
	$(RISCV_EXE_PREFIX)objcopy -O binary $< $@

$(HEX_TARGET): $(BIN_TARGET)
	$(PYTHON) ../makehex.py $< $@

dump: $(ELF_TARGET)
	$(RISCV_EXE_PREFIX)objdump -d -x $<
.phony: dump


clean:
	rm -f $(OBJ) $(ELF_TARGET) $(BIN_TARGET) $(HEX_TARGET)
.phony: clean

vars:
	@echo "make variables:"
	@echo "   CV_SW_TOOLCHAIN  = $(CV_SW_TOOLCHAIN)"
	@echo "   RISCV            = $(RISCV)"
	@echo "   RISCV_EXE_PREFIX = $(RISCV_EXE_PREFIX)"
	@echo "   RISCV_GCC        = $(RISCV_GCC)"
	@echo "   RISCV_MARCH      = $(RISCV_MARCH)"
	@echo "   RISCV_CFLAGS     = $(RISCV_CFLAGS)"
	@echo "   CFLAGS           = $(CFLAGS)"

.phony: vars
