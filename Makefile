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

# Fabric

# Get the fabric names
FABRICS :=  $(patsubst fabrics/%,%,$(wildcard fabrics/*)) 

FABRICS_OPENROAD := $(addsuffix -openroad,$(FABRICS))
FABRICS_KLAYOUT := $(addsuffix -klayout,$(FABRICS))
FABRICS_COPY := $(addsuffix -copy,$(FABRICS))

all: $(FABRICS)
.PHONY: all

$(FABRICS):
	librelane --pdk ${PDK} fabrics/$@/config.yaml --save-views-to fabrics/$@/macro/${PDK}/
.PHONY: $(FABRICS)

$(FABRICS_OPENROAD):
	librelane --pdk ${PDK} fabrics/$(subst -openroad,,$@)/config.yaml --last-run --flow OpenInOpenROAD
.PHONY: $(FABRICS_OPENROAD)

$(FABRICS_KLAYOUT):
	librelane --pdk ${PDK} fabrics/$(subst -klayout,,$@)/config.yaml --last-run --flow OpenInKLayout
.PHONY: $(FABRICS_KLAYOUT)

$(FABRICS_COPY):
	# Copy fabric database
	mkdir -p user_designs/fabrics/$(subst -copy,,$@)/macro/${PDK}/
	cp -R fabrics/$(subst -copy,,$@)/macro/${PDK}/fabulous/ user_designs/fabrics/$(subst -copy,,$@)/macro/${PDK}/
	cp fabrics/$(subst -copy,,$@)/constraints.pcf user_designs/fabrics/$(subst -copy,,$@)/constraints.pcf
.PHONY: $(FABRICS_COPY)

# Implementation

all: librelane ## Build the project (runs LibreLane)
.PHONY: all

librelane: $(PDK_ROOT)/$(PDK) ## Run LibreLane to implement Greyhound
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/
.PHONY: librelane

librelane-nodrc: $(PDK_ROOT)/$(PDK) ## Run LibreLane without DRC
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/ --skip KLayout.DRC --skip Magic.DRC
.PHONY: librelane-nodrc

librelane-ci: $(PDK_ROOT)/$(PDK) ## Run LibreLane without DRC
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/ --skip KLayout.DRC --skip Magic.DRC --skip KLayout.Density --condensed
.PHONY: librelane-ci

librelane-klayoutdrc: $(PDK_ROOT)/$(PDK) ## Run LibreLane without magic DRC
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/ --skip Magic.DRC
.PHONY: librelane-klayoutdrc

librelane-magicdrc: $(PDK_ROOT)/$(PDK) ## Run LibreLane without KLayout DRC
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/ --skip KLayout.DRC
.PHONY: librelane-magicdrc

librelane-openroad: $(PDK_ROOT)/$(PDK) ## Open the last run in OpenROAD
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --last-run --flow OpenInOpenROAD
.PHONY: librelane-openroad

librelane-klayout: $(PDK_ROOT)/$(PDK) ## Open the last run in KLayout
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --last-run --flow OpenInKLayout
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

oasis:
	mkdir -p final/oas/
	klayout -rd input_gds=final/gds_fill/${TOP}.gds.gz -rd output_oasis=final/oas/${TOP}.oas -r scripts/convert_oasis.py -zz
.PHONY: oasis

tapeout: librelane oasis
.PHONY: tapeout
