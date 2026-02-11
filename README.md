# Greyhound: A RISC-V SoC with tightly coupled eFPGA on IHP SG13G2

Greyhound's embedded FPGA can be used as a custom instruction extension, as a peripheral or as a completely standalone FPGA with 32 I/Os. Custom tiles were created to enable warmboot functionality and allow communication with the SoC. Thanks to FABulous, the user bitstream for the FPGA can be generated using the upstream yosys and nextpnr toolchain.

Greyhound was designed with open source EDA tools and the [IHP Open Source PDK](https://github.com/IHP-GmbH/IHP-Open-PDK).

<p align="center">
  <a href="img/FMD_QNC_greyhound_ihp.png">
    <img src="img/FMD_QNC_greyhound_ihp_small.png" alt="chip layout" width=35%>
  </a>
</p>

## Feature Overview

- SoC
  - [CV32E40X](https://github.com/openhwgroup/cv32e40x) RISC-V core from the OpenHW group
    - RV32IMAC
    - `Zca_Zcb_Zcmp_Zcmt` (code-size reduction)
    - `Zba_Zbb_Zbc_Zbs` (bit manipulation)
    - `Zicntr`, `Zicsr`, `Zihpm`, `Zifencei`
  - 8 KiB SRAM
  - QSPI Flash Controller for XIP
    - Cache: 8 lines of 32 bytes, direct mapped
  - QSPI PSRAM controller
  - Highly Configurable UART
  - Fabric Config Peripheral
  - Fabric Peripheral
- [FABulous](https://github.com/FPGA-Research/FABulous) eFPGA
  - 32x I/Os
  - 1024x LUT4 + FF
    - w. carry chain
  - 128x MUX
    - Either 1xMUX8, 2xMUX4 or 4xMUX2
  - 4x SRAM
    - 32 bit-wide, 4kB deep
    - individual bit-enable
  - 4x BRAM
    - 16 bit-wide, 4kB deep
    - individual bit-enable
    - two read-write ports
  - 8x MAC
    - 8bit*8bit + 20bit
    - sign-extend
    - sync/async operands and/or ACC
  - 16x Register file
    - 32x4bit each
    - 1w1r1r
    - sync/async output
  - 1x Global clock network
  - 1x WARMBOOT
    - Trigger a reconfiguration from one of 16 slots
    - Provides a reset signal which is asserted during reconfiguration
  - 1x CPU_IRQ
    - 4x Interrupt request lines to the CPU
  - 1x OBI_PERIPHERAL
    - Interface to the SoC (Open Bus Interface)
    - Custom peripheral
  - 1x CUSTOM_INSTRUCTION
    - Interface to the CPU
    - Custom instruction extension

The FPGA can configure itself from an SPI Flash from any of 16 different slots, or receive the bitsream via SPI. The CPU can also trigger a reconfiguration or provide the bitstream directly.

Here are the STA results after PnR for the SoC:

| corner              | BSR=None  | BSR=External | BSR=Internal | BSR=All   |
|---------------------|-----------|--------------|--------------|-----------|
| nom_fast_1p32V_m40C | 92 MHz    | 81 MHz       | 82 MHz       | 85 MHz    |
| nom_typ_1p20V_25C   | 64 MHz    | 53 MHz       | 54 MHz       | 57 MHz    |
| nom_slow_1p08V_125C | 40 MHz    | 33 MHz       | 34 MHz       | 36 MHz    |

## FPGA Fabric

This is the tile map of the FPGA fabric:

![fabric_diagram.svg](img/svg/fabric_diagram.svg)

## Memory Map

This is the memory map of the SoC:

| Base Address | Name               | Description                                                                                      |
|--------------|--------------------|--------------------------------------------------------------------------------------------------|
| 0x00000000   | FLASH_BASE         | QSPI XIP Flash controller with 8 lines of 32 bytes direct mapped cache                           |
| 0x10000000   | SRAM_BASE          | 8kB of SRAM                                                                                      |
| 0x20000000   | PSRAM_BASE         | QSPI PSRAM controller                                                                            |
| 0x30000000   | UART0_BASE         | Highly configurable UART with 16-byte TX and RX FIFO, 16-bit prescaler and ten interrupt sources |
| 0x40000000   | FABRIC_CONFIG_BASE | Fabric configuration peripheral                                                                  |
| 0x50000000   | FABRIC_BASE        | Interface to the fabric when it is configured as peripheral                                      |
| 0x60000000   | DEBUG_BASE         | Memory mapping of the [riscv-dbg](https://github.com/pulp-platform/riscv-dbg/) module |

## Fabric Config Peripheral

The `FABRIC_CONFIG` peripheral can be accessed by the CPU to configure the FPGA fabric and get its status.

| Offset | Register               | Description                                                                                                    |
|--------|------------------------|----------------------------------------------------------------------------------------------------------------|
| 0x0    | `REG_XIF_OR_PERIPH`      | [W] Write a 0 or 1. Sets the interface to the fabric as custom instruction interface (0) or as peripheral (1). (Removed for revision 2 since now both interfaces are active at the same time.) |
| 0x4    | `REG_FABRIC_CONFIG_BUSY` | [R] Readonly. Returns 1 if the fabric is under configuration, 0 if not.                                        |
| 0x8    | `REG_BITSTREAM`          | [W] Write bitstream data to this register.                                                                     |
| 0xC    | `REG_TRIGGER_SLOT`       | [W] Trigger a reconfiguration by writing the slot to this register (0-15).                                     |

## Fabric Peripheral

The fabric peripheral can be accessed at address `0x50000000`. It is the responsibility of the user to upload a bitstream that correctly handles bus requests. The `OBI_PERIPHERAL` implements the Open Bus Interface, see: https://github.com/openhwgroup/obi

```Verilog
    OBI_PERIPHERAL_wrapper i_OBI_PERIPHERAL_wrapper (
        .REQ,
        .WE,
        .BE,
        .ADDR,
        .WDATA,
        
        .GNT,
        .RVALID,
        .RDATA,
    );
```

An example design for implementing a custom peripheral in the eFPGA can be found under `ip/fabric/user_designs/peripheral/`.

## Custom Instruction Extension

The fabric can implement a custom instruction via the `CUSTOM_INSTRUCTION` primitive. It implements a simple handshake protocol for the "issue" phase and the "result" phase.
This is a significant improvement over revision one of Greyhound, since now implementing multiple custom instructions, pipelining and stalling is all automatically supported.

The interface is as follows:

```Verilog
    CUSTOM_INSTRUCTION_wrapper xif (
        .ISSUE_READY    (issue_ready_o),
        .ISSUE_ACCEPT   (issue_accept_o),
        .ISSUE_VALID    (issue_valid_i),
        .ISSUE_INSTR    (issue_instr_i),
        .ISSUE_OPA      (issue_op0_i),
        .ISSUE_OPB      (issue_op1_i),
        .ISSUE_ID       (issue_id_i),
        
        .RESULT_VALID   (result_valid_o),
        .RESULT_ID      (result_id_o),
        .RESULT_RD      (result_rd_o),
        .RESULT         (result_o),
    );
```

An example design for implementing a custom instruction in the eFPGA can be found under `ip/fabric/user_designs/custom_instruction/`.

You can easily execute a custom instruction directly from your C code using the `.insn` pseudo directive in GCC:

```C
int a=42; int b=3; int c;

// Read the result after 13 cycles
__asm__ volatile (".insn r 0x5b, 0, 0, %0, %1, %2" : "=r" (c) : "r" (a), "r" (b));
```

Where `a` and `b` are the variables for the operands and `c` is the variable for the result.

## FPGA Configuration

There are several paths for uploading a bitstream into the FPGA fabric. To support the JTAG interface the `fpga_mode` pin has to be pulled low for 5 clk cycles on power up.

![fabric_configuration.svg](img/svg/fabric_configuration.svg)

1. Fabric config acts as controller (`fpga_mode` == 0)

The fabric config acts as a controller and loads a bitstream from an external SPI flash upon startup.

In this mode the `WARMBOOT` tile can trigger a reconfiguration from a different slot of the external SPI flash. In total there are 16 different slots to choose from. One slot is 0x4000 bytes large, where 0x3A88 bytes of those are actual bitstream data that is loaded.

2. Fabric config acts as peripheral (`fpga_mode` == 1)

In this mode the fabric config acts as a peripheral. You'll need to supply the bitstream in big-endian order via an external SPI controller.

3. CPU triggers a reconfiguration

By writing the slot number to the `REG_TRIGGER_SLOT` register of the `FABRIC_CONFIG` peripheral, the CPU triggers a reconfiguration of the FPGA. This means the fabric config loads the bitstream from an external SPI flash (`fpga_mode` must be 0).

4. CPU writes bitstream

The CPU can also write raw bitstream data to the `REG_BITSTREAM` register of the `FABRIC_CONFIG_BASE` peripheral. The advantage of this mode is that only one SPI flash needs to be populated on the PCB.

5. JTAG interface

The JTAG interface provides access to the CPU and fabric tap, they support [OpenOCD](https://github.com/riscv-collab/riscv-openocd/tree/riscv). An example config is provided in the .cfg files of the tb/ directory. The CPU tap supports [riscv-gdb](https://github.com/riscv-collab/riscv-gnu-toolchain) through the [riscv-dbg](https://github.com/pulp-platform/riscv-dbg/) module, while the fabric tap supports IEEE1532 programming and IEEE1149.1 boundary scan if implemented.

Approximate times for configuration from simulation:

- CPU configures FPGA @50MHz: ~13.3ms
- Fabric config controller @50MHz: ~5ms
- Fabric config peripheral @10Mhz: ~22.5ms
- Fabric config jtag @10MHz: ~22.5ms

## JTAG
Greyhound implements two JTAG TAPs, one for the CPU and one for the fabric. As the amount of pins is limited by the packaging the JTAG interface shares its pins with the fabric configuration pins. For this to work the `fpga_mode` pin has to be pulled low for at least 5 clk cycles on power up. Otherwise the internal OBI bus may stall.

The cpu tap supports the riscv-dbg spec as in [riscv-dbg](https://github.com/pulp-platform/riscv-dbg/).

The fabric tap is compatibel with IEEE1149.1 and IEEE1532 for in system configuration. The boundary scan register size may be configured in the soc pkg. It can be 0 bits (None), 64 bits (External), 245 bits(Internal) or 309 bits(All) long. When selecting None for the length the soc is not IEEE1532 conform as there is no boundary scan support. When None is selected the boundary scan operations are redirected to use the bypass register.

The preload and sample instructions behave in the same way and thus have the same address. The usercode instruction is set by uploading the bitstream to the fabric.

The soc needs a special instruction (ejtag) to enable the jtag interface. This works by writing a 1 bit 1 value to this address when the system reset is pulled low. To disable the interface simply write 0 instead of 1. When a BSR is implemented the fabric IOs are in highZ as described in IEEE1532. Without BSR no IO value can be set and thus the wires are routed directly. Only pins where boundary scan registers are present are controlled as in IEEE1532. To remain compatible with the SPI-peripheral/controller highZ and the BSR only control the IOs, when ejtag is written to 1.

To program the fabric one has to cycle through ISC_ENABLE -> ISC_PROGRAMM (write complete bitstream) -> ISC_DISABLE (signals complete programming) -> BYPASS (to activate the design). When the fabric is programmed by the cpu it will be forced into the ISC Accessed state while programming and then back to the operational state, if a jtag clk is present. Without jtag clk this transition will not happen. As a result, when the BSR is present jtag clk can only be disconnected once the fabric is in operational mode.

| Length              | Register configuration |
|---------------------|------------------------|
| None (0 bits)       | No BSR                 |
| External (64 bits)  | Fabric GPIOs from 0 to 31, each GPIO has 2 bits (first bit is for the ex/intest value, second bit is to control the output enable) |
| Internal (245 bits) | cpu irq, cpu xif (fabric_issue_ready, fabric_issue_accept, fabric_result_valid, fabric_result_id, fabric_result_rd, fabric_result, fabric_issue_valid, fabric_issue_instr, fabric_issue_op0, fabric_issue_op1, fabric_issue_id), cpu obi (fabric_obi_req, fabric_obi_we, fabric_obi_be, fabric_obi_addr, fabric_obi_wdata, fabric_obi_gnt, fabric_obi_rvalid, fabric_obi_rdata) |
| All (309 bits)      | Fabric GPIOs, cpu irq, cpu xif (fabric_issue_ready, fabric_issue_accept, fabric_result_valid, fabric_result_id, fabric_result_rd, fabric_result, fabric_issue_valid, fabric_issue_instr, fabric_issue_op0, fabric_issue_op1, fabric_issue_id), cpu obi (fabric_obi_req, fabric_obi_we, fabric_obi_be, fabric_obi_addr, fabric_obi_wdata, fabric_obi_gnt, fabric_obi_rvalid, fabric_obi_rdata) |

| Command        | Address  | Register size |
|----------------|----------|---------------|
| BYPASS         | 0x0/0x1f | 1 bit         |
| IDCODE         | 0x1      | 32 bit        |
| USERCODE       | 0x2      | 32 bit        |
| SAMPLE         | 0x3      | BSR size      |
| PRELOAD        | 0x3      | BSR size      |
| EXTEST         | 0x4      | BSR size      |
| INTEST         | 0x5      | BSR size      |
| EJTAG          | 0x10     | 1 bit         |
| ISC_ENABLE     | 0x14     | 1 bit         |
| ISC_DISABLE    | 0x15     | 1 bit         |
| ISC_PROGRAM    | 0x16     | 32 bit        |
| ISC_NOOP       | 0x17     | 1 bit         |

## Firmware and Bitstream

Example programs are under the `firmware/` directory. These include programs to use the UART, load a bitstream, trigger a bitstream reconfiguration, use a custom instruction of the fabric or access a peripheral of the fabric.

Instructions to compile a bitstream for the eFPGA can be found under `ip/fabric/user_designs/`.

## Simulation and Verification

Testbenches are made with [cocotb](https://github.com/cocotb/cocotb). There are separate testbenches just for simulating the SoC or the full chip. To simulate the SoC, take a look at `tb/greyhound_soc_tb`. For the full chip simulation see `tb/greyhound_ihp_top`.

To run an RTL simulation, first we need to convert the SystemVerilog into something that Icarus Verilog can read.
Enable a Nix shell using `nix-shell` and run `make convert-slang`.
To run the debug testbenches with [OpenOCD](https://github.com/riscv-collab/riscv-openocd/tree/riscv) one has to build the vpi module for Icarus Verilog first with `make sim-jtag-wrapper`.

Currently, Nix is not used for the testbench environment (sorry!), you need to create a virtual environment in Python and install the dependencies via:

```
pip3 install -r requirements.txt
```

To start the full chip simulation simply run:

```
python3 FMD_QNC_greyhound_ihp.py
```

To run a gate level simulation, simply set `GL`:

```
GL=1 python3 FMD_QNC_greyhound_ihp.py
```

To select a different test, open `FMD_QNC_greyhound_ihp.py` and set `enabled` to one of the available tests. This is unfortunately necessary since cocotb cannot restart the simulator between test runs. Maybe there is another way to reload the SPI flash.

## Building the Chip

> [!NOTE]
> Greyhound currently relies on forks of [LibreLane](https://github.com/mole99/librelane/tree/greyhound) and the [IHP Open PDK](https://github.com/mole99/IHP-Open-PDK/tree/leo/padring). I'm planning on upstreaming all changes to the upstream repositories soon.

First enable a Nix shell using:

```
nix-shell
```

Note: You need to export `PDK_ROOT` and `PDK` to the path of the IHP Open PDK and the name of the PDK.

To build the chip with LibreLane:

```console
make librelane
```

After completion you can open Greyhound in OpenROAD GUI:

```console
make librelane-openroad
```

Or you can view Greyhound in KLayout:

```console
make librelane-klayout
```

The final steps:

```
make copy-final
make insert-logo
make create-image
make fill
make drc
make zip
```

And with this, Greyhound is ready for tapeout.

## Acknowledgements

The first revision of Greyhound was created as part of my master's thesis at Graz University of Technology.

I would like to thank my supervisors Tobias Scheipel and Meinhard Kissich.

I would also like to thank the FABulous team for their support in the development of the fabric and NLnet for funding the work of the FABulous team.

|   |   |
|---|---|
| ![NLnet](img/nlnet_banner.svg)  | ![NGI0 Entrust](img/NGI0Entrust_tag.svg)  |

## License

Greyhound is licensed under the Apache 2.0 license. This license may *not* apply to the remainder of the repository.
