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
    - Cache: 16 lines of 32 bytes, direct mapped
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

| corner              | frequency |
|---------------------|-----------|
| nom_fast_1p32V_m40C | 69 MHz    |
| nom_typ_1p20V_25C   | 51 MHz    |
| nom_slow_1p08V_125C | 32 MHz    |

## FPGA Fabric

This is the tile map of the FPGA fabric:

![fabric_diagram.svg](img/svg/fabric_diagram.svg)

## Memory Map

This is the memory map of the SoC:

| Base Address | Name               | Description                                                                                      |
|--------------|--------------------|--------------------------------------------------------------------------------------------------|
| 0x00000000   | FLASH_BASE         | QSPI XIP Flash controller with 16 lines of 32 bytes direct mapped cache                           |
| 0x10000000   | SRAM_BASE          | 8kB of SRAM                                                                                      |
| 0x20000000   | PSRAM_BASE         | QSPI PSRAM controller                                                                            |
| 0x30000000   | UART0_BASE         | Highly configurable UART with 16-byte TX and RX FIFO, 16-bit prescaler and ten interrupt sources |
| 0x40000000   | FABRIC_CONFIG_BASE | Fabric configuration peripheral                                                                  |
| 0x50000000   | FABRIC_BASE        | Interface to the fabric when it is configured as peripheral                                      |

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

There are several paths for uploading a bitstream into the FPGA fabric.

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

Approximate times for configuration from simulation:

- CPU configures FPGA @50MHz: ~13.3ms
- Fabric config controller @50MHz: ~5ms
- Fabric config peripheral @10Mhz: ~22.5ms

## Firmware and Bitstream

Example programs are under the `firmware/` directory. These include programs to use the UART, load a bitstream, trigger a bitstream reconfiguration, use a custom instruction of the fabric or access a peripheral of the fabric.

Instructions to compile a bitstream for the eFPGA can be found under `ip/fabric/user_designs/`.

in the [`ip/fabulous_fabric`](https://github.com/mole99/fabulous_fabric) submodule.

## Simulation and Verification

Testbenches are made with [cocotb](https://github.com/cocotb/cocotb). There are separate testbenches just for simulating the SoC or the full chip. To simulate the SoC, take a look at `tb/greyhound_soc_tb`. For the full chip simulation see `tb/greyhound_ihp_top`.

To run an RTL simulation, first we need to convert the SystemVerilog into something that Icarus Verilog can read.
Enable a Nix shell using `nix-shell` and run `make convert-slang`.

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
