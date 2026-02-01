MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

RUN_TAG = $(shell ls runs/ -1 | tail -n 1)
TOP = FMD_QNC_greyhound_ihp

PDK_ROOT ?= $(MAKEFILE_DIR)/IHP-Open-PDK
PDK ?= ihp-sg13g2
PDK_COMMIT ?= c4b8b4e5e7a05f375cca3815d51b3a37721fbf5c

CORE_FILES =
# PACKAGES
CORE_FILES += src/soc/soc_pkg.sv
CORE_FILES += src/soc/cf_math_pkg.sv
CORE_FILES += ip/cv32e40x/rtl/include/cv32e40x_pkg.sv
CORE_FILES += ip/obi/src/obi_pkg.sv
CORE_FILES += ip/riscv-dbg/src/dm_pkg.sv
CORE_FILES += ip/common_cells/src/cdc_reset_ctrlr_pkg.sv
# RTL_OBI
CORE_FILES += ip/obi/src/obi_intf.sv
CORE_FILES += ip/obi/src/obi_mux.sv
CORE_FILES += ip/obi/src/obi_demux.sv
CORE_FILES += ip/obi/src/obi_err_sbr.sv
CORE_FILES += ip/obi/src/obi_sram_shim.sv
# RTL_COMMON
CORE_FILES += ip/common_cells/src/fifo_v3.sv
CORE_FILES += ip/common_cells/src/rr_arb_tree.sv
CORE_FILES += ip/common_cells/src/delta_counter.sv
CORE_FILES += ip/common_cells/src/lzc.sv
CORE_FILES += ip/common_cells/src/cdc_2phase_clearable.sv
CORE_FILES += ip/common_cells/src/deprecated/fifo_v2.sv
CORE_FILES += ip/common_cells/src/fifo_v3.sv
CORE_FILES += ip/common_cells/src/cdc_reset_ctrlr.sv
CORE_FILES += ip/common_cells/src/sync.sv
CORE_FILES += ip/common_cells/src/cdc_4phase.sv
# Core and SoC
CORE_FILES += ip/cv32e40x/rtl/*.sv
CORE_FILES += src/soc/greyhound_soc.sv
CORE_FILES += src/soc/dummy_extension.sv
CORE_FILES += src/soc/fabric_extension.sv
CORE_FILES += src/soc/obi2ahbm_adapter.sv
CORE_FILES += src/soc/cv32e40x_clock_gate.sv
# QSPI XiP
CORE_FILES += ip/EF_QSPI_XIP_CTRL/hdl/rtl/EF_QSPI_XIP_CTRL.v
CORE_FILES += ip/EF_QSPI_XIP_CTRL/hdl/rtl/DMC.v
CORE_FILES += ip/EF_QSPI_XIP_CTRL/hdl/rtl/bus_wrappers/EF_QSPI_XIP_CTRL_AHBL.v
# QSPI PSRAM
CORE_FILES += ip/EF_PSRAM_CTRL/hdl/rtl/EF_PSRAM_CTRL.v
CORE_FILES += ip/EF_PSRAM_CTRL/hdl/rtl/bus_wrapper/EF_PSRAM_CTRL_AHBL.v
# UART
CORE_FILES += ip/EF_UART/hdl/rtl/EF_UART.v
CORE_FILES += ip/EF_UART/hdl/rtl/bus_wrappers/EF_UART_AHBL.v
# Util
CORE_FILES += ip/EF_IP_UTIL/hdl/ef_util_lib.v
# Debug
CORE_FILES += ip/riscv-dbg/src/dmi_jtag.sv
CORE_FILES += ip/riscv-dbg/src/dmi_jtag_tap.sv
CORE_FILES += ip/riscv-dbg/src/dmi_cdc.sv
CORE_FILES += ip/riscv-dbg/src/dm_obi_top.sv
CORE_FILES += ip/riscv-dbg/src/dm_top.sv
CORE_FILES += ip/riscv-dbg/src/dm_csrs.sv
CORE_FILES += ip/riscv-dbg/src/dm_sba.sv
CORE_FILES += ip/riscv-dbg/src/dm_mem.sv
CORE_FILES += ip/riscv-dbg/debug_rom/debug_rom.sv
CORE_FILES += ip/riscv-dbg/debug_rom/debug_rom_one_scratch.sv
CORE_FILES += src/debug/tc_clk_wrapper.sv
CORE_FILES += src/debug/fpga_dm_jtag_tap.sv
CORE_FILES += src/debug/fpga_dm.sv
CORE_FILES += src/debug/fpga_boundary_cell.sv

CHIP_FILES = $(CORE_FILES)
# Chip
CHIP_FILES += src/FMD_QNC_greyhound_ihp.v
CHIP_FILES += src/greyhound_ihp.sv
# Fabric Wrapper
CHIP_FILES += ip/fabric/rtl/fabric_wrapper.sv
# Fabric Config
CHIP_FILES += ip/fabric_config/fabric_config.sv
CHIP_FILES += ip/fabric_config/fabric_spi_controller.sv
CHIP_FILES += ip/fabric_config/fabric_spi_receiver.sv

.DEFAULT_GOAL := help

$(PDK_ROOT)/$(PDK):
	ciel enable $(PDK_COMMIT) --pdk-root $(PDK_ROOT) --pdk-family $(PDK)

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
.PHONY: help

clone-pdk: $(PDK_ROOT)/$(PDK) ## Clone the ihp-sg13g2 PDK variant via ciel
.PHONY: clone-pdk

convert-slang:
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) SLANG_FILES="$(CORE_FILES)" TOP=greyhound_soc OUTFILE=tb/greyhound_soc_tb/greyhound_soc_slang.sv yosys -m slang yosys.tcl
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) SLANG_FILES="$(CHIP_FILES)" TOP=FMD_QNC_greyhound_ihp OUTFILE=tb/FMD_QNC_greyhound_ihp_tb/FMD_QNC_greyhound_ihp_slang.sv yosys -m slang yosys.tcl
.PHONY: convert-slang

sim-jtag-wrapper:
	mkdir -p tb/greyhound_soc_dbg_tb/sim_build
	cd tb/greyhound_soc_dbg_tb/sim_build && iverilog-vpi ../../../ip/riscv-dbg/tb/remote_bitbang/remote_bitbang.c  ../sim_jtag_wrapper.c --name=remote_bitbang
.PHONY: sim-jtag-wrapper

# Implementation

all: librelane ## Build the project (runs LibreLane)
.PHONY: all

librelane: $(PDK_ROOT)/$(PDK) ## Run LibreLane to implement Greyhound
	librelane config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/
.PHONY: librelane

librelane-nodrc: $(PDK_ROOT)/$(PDK) ## Run LibreLane without DRC
	librelane config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/ --skip KLayout.DRC --skip Magic.DRC
.PHONY: librelane

librelane-klayoutdrc: $(PDK_ROOT)/$(PDK) ## Run LibreLane without magic DRC
	librelane config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/ --skip Magic.DRC
.PHONY: librelane-klayoutdrc

librelane-magicdrc: $(PDK_ROOT)/$(PDK) ## Run LibreLane without KLayout DRC
	librelane config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/ --skip KLayout.DRC
.PHONY: librelane-magicdrc

librelane-openroad: $(PDK_ROOT)/$(PDK) ## Open the last run in OpenROAD
	librelane config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --last-run --flow OpenInOpenROAD
.PHONY: librelane-openroad

librelane-klayout: $(PDK_ROOT)/$(PDK) ## Open the last run in KLayout
	librelane config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --last-run --flow OpenInKLayout
.PHONY: librelane-klayout

# Simulation

sim: ## Run RTL simulation with cocotb
	cd cocotb; PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 chip_top_tb.py
.PHONY: sim

sim-gl: $(PDK_ROOT)/$(PDK) ## Run gate-level simulation with cocotb
	cd cocotb; GL=1 PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 chip_top_tb.py
.PHONY: sim-gl

sim-view: ## View simulation waveforms in GTKWave
	gtkwave cocotb/sim_build/chip_top.fst
.PHONY: sim-view

# Finishing

insert-logo:
	mkdir -p final/gds_logo/
	python3 scripts/insert_logo.py final/gds/${TOP}.gds logo/smooth/gds/greyhound_logo.gds final/gds_logo/${TOP}.gds
.PHONY: insert-logo

render-image: $(PDK_ROOT)/$(PDK) ## Render an image of Greyhound
	PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 scripts/lay2img.py final/gds_logo/${TOP}.gds img/${TOP}.png --width 2048 --oversampling 4
	magick img/${TOP}_white.png -resize 25% img/${TOP}_white_small.png
	magick img/${TOP}_black.png -resize 25% img/${TOP}_black_small.png
.PHONY: render-image

fill:
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) $(PDK_ROOT)/$(PDK)/libs.tech/magic/generate_fill.py final/gds_logo/${TOP}.gds.gz -dist
	
	# Move the fill pattern, it's saved under gds/ because of how generate_fill works...
	mkdir -p final/gds_fill/
	mv final/gds/${TOP}_fill_pattern.gds.gz final/gds_fill/${TOP}_fill_pattern.gds.gz
	
	# Merge layout with fill
	python3 scripts/merge_fill.py final/gds_logo/${TOP}.gds.gz final/gds_fill/${TOP}_fill_pattern.gds.gz final/gds_fill/${TOP}.gds.gz
.PHONY: fill

magic-density-check:
	# Run density check
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) $(PDK_ROOT)/$(PDK)/libs.tech/magic/check_density.py final/gds_fill/${TOP}.gds.gz
.PHONY: density-check

oasis:
	mkdir -p final/oas/
	klayout -rd input_gds=final/gds_fill/${TOP}.gds.gz -rd output_oasis=final/oas/${TOP}.oas -r scripts/convert_oasis.py -zz
.PHONY: oasis

klayout-drc-nodensity:
	python3 ${HOME}/Repositories/IHP-Open-PDK-latest/ihp-sg13g2/libs.tech/klayout/tech/drc/run_drc.py --path final/gds_fill/${TOP}.gds.gz --run_mode=deep --no_density --disable_extra_rules
.PHONY: drc-latest-nodensity

klayout-drc:
	python3 ${HOME}/Repositories/IHP-Open-PDK-latest/ihp-sg13g2/libs.tech/klayout/tech/drc/run_drc.py --path final/gds_fill/${TOP}.gds.gz --run_mode=deep --disable_extra_rules
.PHONY: drc-latest

zip:
	mkdir -p final/gds_zipped/
	gunzip final/gds_fill/${TOP}.gds.gz
	#zip -r -s 50m final/gds_zipped/${TOP}.gds.zip final/gds_fill/${TOP}.gds
	cd final/gds_fill/; zip -D -r ../gds_zipped/${TOP}.gds.zip ${TOP}.gds
	gzip final/gds_fill/${TOP}.gds
.PHONY: zip

tapeout: librelane insert-logo render-image fill oasis
.PHONY: tapeout
