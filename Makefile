RUN_TAG = $(shell ls runs/ -1 | tail -n 1)
TOP = FMD_QNC_greyhound_ihp

$(echo $RUN_TAG)

#PDK_ROOT ?= IHP-Open-PDK
PDK ?= ihp-sg13g2

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


convert-slang:
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) SLANG_FILES="$(CORE_FILES)" TOP=greyhound_soc OUTFILE=tb/greyhound_soc_tb/greyhound_soc_slang.sv yosys -m slang yosys.tcl
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) SLANG_FILES="$(CHIP_FILES)" TOP=FMD_QNC_greyhound_ihp OUTFILE=tb/FMD_QNC_greyhound_ihp_tb/FMD_QNC_greyhound_ihp_slang.sv yosys -m slang yosys.tcl
.PHONY: convert-slang

librelane:
	librelane config.yaml --pdk ${PDK} # --pdk-root ${PDK_ROOT} --manual-pdk
.PHONY: librelane

librelane-openroad:
	librelane config.yaml --pdk ${PDK} --last-run --flow OpenInOpenROAD
.PHONY: librelane-openroad

librelane-klayout:
	librelane config.yaml --pdk ${PDK} --last-run --flow OpenInKLayout
.PHONY: librelane-klayout

copy-final:
	mkdir -p final/pnl/
	mkdir -p final/spice/
	mkdir -p final/nl/
	mkdir -p final/gds/
	mkdir -p final/odb/
	mkdir -p final/def/
	mkdir -p final/spef/nom/

	cp runs/${RUN_TAG}/final/pnl/${TOP}.pnl.v final/pnl/${TOP}.pnl.v
	cp runs/${RUN_TAG}/final/spice/${TOP}.spice final/spice/${TOP}.spice
	cp runs/${RUN_TAG}/final/nl/${TOP}.nl.v final/nl/${TOP}.nl.v
	cp runs/${RUN_TAG}/final/gds/${TOP}.gds final/gds/${TOP}.gds
	cp runs/${RUN_TAG}/final/odb/${TOP}.odb final/odb/${TOP}.odb
	cp runs/${RUN_TAG}/final/def/${TOP}.def final/def/${TOP}.def
	cp runs/${RUN_TAG}/final/spef/nom/${TOP}.nom.spef final/spef/nom/${TOP}.nom.spef
	
	gzip --force final/gds/${TOP}.gds
	gzip --force final/odb/${TOP}.odb
	
.PHONY: copy-final

insert-logo:
	mkdir -p final/gds_logo/
	python3 scripts/insert_logo.py final/gds/${TOP}.gds.gz logo/smooth/gds/greyhound_logo.gds final/gds_logo/${TOP}.gds.gz
.PHONY: insert-logo

render-image:
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) klayout -z -r scripts/klayout_image.py -rd input_gds=final/gds_logo/${TOP}.gds.gz -rd output_image=img/${TOP}.png
	convert img/${TOP}.png -resize 25% img/${TOP}_small.png
.PHONY: create-render

fill:
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) $(PDK_ROOT)/$(PDK)/libs.tech/magic/generate_fill.py final/gds_logo/${TOP}.gds.gz -dist
	
	# Move the fill pattern, it's saved under gds/ because of how generate_fill works...
	mkdir -p final/gds_fill/
	mv final/gds/${TOP}_fill_pattern.gds.gz final/gds_fill/${TOP}_fill_pattern.gds.gz
	
	# Merge layout with fill
	python3 scripts/merge_fill.py final/gds_logo/${TOP}.gds.gz final/gds_fill/${TOP}_fill_pattern.gds.gz final/gds_fill/${TOP}.gds.gz
.PHONY: fill

density-check:
	# Run density check
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) $(PDK_ROOT)/$(PDK)/libs.tech/magic/check_density.py final/gds_fill/${TOP}.gds.gz
.PHONY: density-check

oasis:
	mkdir -p final/oas/
	klayout -rd input_gds=final/gds_fill/${TOP}.gds.gz -rd output_oasis=final/oas/${TOP}.oas -r scripts/convert_oasis.py -zz
.PHONY: oasis

lvs:
	@echo "\
	set circuit1 [readnet spice final/spice/${TOP}.spice]\n\
	set circuit2 [readnet verilog /dev/null]\n\
	readnet spice $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice \$$circuit2\n\
	readnet spice $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_io/spice/sg13g2_io.spi \$$circuit2\n\
	readnet verilog final/pnl/${TOP}.pnl.v \$$circuit2\n\
	lvs \"\$$circuit1 ${TOP}\" \"\$$circuit2 ${TOP}\" $(PDK_ROOT)/$(PDK)/libs.tech/netgen/ihp-sg13g2_setup.tcl netgen_lvs.rpt -blackbox" > lvs_script.tcl
	
	netgen -batch source lvs_script.tcl
.PHONY: lvs

drc:
	klayout -b -r $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/drc/sg13g2_minimal.lydrc -rd in_gds=final/gds_fill/${TOP}.gds.gz -rd cell=${TOP} -rd report_file=sg13g2_minimal.lyrdb -rd logfile="sg13g2_minimal.log" -rd threads=$(shell nproc)
.PHONY: drc

drc-full:
	klayout -b -r $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/drc/sg13g2_maximal.lydrc -rd in_gds=final/gds_fill/${TOP}.gds.gz -rd cell=${TOP} -rd report_file=sg13g2_maximal.lyrdb -rd logfile="sg13g2_maximal.log" -rd threads=$(shell nproc)
.PHONY: drc-full

drc-density:
	klayout -b -r $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/drc/sg13g2_density.lydrc -rd in_gds=final/gds_fill/${TOP}.gds.gz -rd cell=${TOP} -rd report_file=sg13g2_minimal.lyrdb -rd logfile="sg13g2_minimal.log" -rd threads=$(shell nproc)
.PHONY: drc-density

drc-latest-nodensity:
	python3 ${HOME}/Repositories/IHP-Open-PDK-latest/ihp-sg13g2/libs.tech/klayout/tech/drc/run_drc.py --path final/gds_fill/${TOP}.gds.gz --run_mode=deep --no_density --disable_extra_rules
.PHONY: drc-latest-nodensity

drc-latest:
	python3 ${HOME}/Repositories/IHP-Open-PDK-latest/ihp-sg13g2/libs.tech/klayout/tech/drc/run_drc.py --path final/gds_fill/${TOP}.gds.gz --run_mode=deep --disable_extra_rules
.PHONY: drc-latest

zip:
	mkdir -p final/gds_zipped/
	gunzip final/gds_fill/${TOP}.gds.gz
	#zip -r -s 50m final/gds_zipped/${TOP}.gds.zip final/gds_fill/${TOP}.gds
	cd final/gds_fill/; zip -D -r ../gds_zipped/${TOP}.gds.zip ${TOP}.gds
	gzip final/gds_fill/${TOP}.gds
.PHONY: zip

tapeout: librelane copy-final insert-logo create-image fill oasis
.PHONY: tapeout
