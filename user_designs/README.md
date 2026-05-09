# User Designs

User designs are Verilog designs that run on the FPGA fabric.
The intention for these example designs is to be as generic as possible, so they can be reused for various fabrics.

## Requirements

Currently, forks of Yosys and nextpnr are required in order to implement the user designs. The changes to these forks are being upstreamed.

Enable a Nix shell with the forks of Yosys and nextpnr:

```
nix-shell
```

**Note:** To generate the bitstreams you need to `pip3 install fasm`.

## Implement the Designs

The user designs for both fabric families can be found under `user_designs/designs/`.
Before you build the user designs, you need to select for which tile library and fabric you want to implement the design.

The default is:

```
export FABRIC=classic_fabric_10x10
export TILE_LIBRARY=classic
```

You can change it for example to:

```
export FABRIC=tiny_fabric_5x5
export TILE_LIBRARY=tiny
```

To build all user designs, run:

```
make all
```

To build individual user designs, use their name:

```
make counter
```

The following Make targets are available:

```
make counter-clean
make counter-synth
make counter-pnr
make counter-bit
make counter-hex
```

You can also enter the individual design directories and run make from there:

```
Commands:
 synth           ... Synthesize the user design
 pnr             ... Run Place and Route
 bitstream       ... Generate the bitstream
 clean           ... Delete all generated files
 help            ... Show this help message
```
