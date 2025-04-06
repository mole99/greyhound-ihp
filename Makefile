PACKAGES = src/soc/soc_pkg.sv  \
           src/soc/cf_math_pkg.sv  \
           ip/cv32e40x/rtl/include/cv32e40x_pkg.sv \
           ip/obi/src/obi_pkg.sv

INCLUDES = -I ip/obi/include/ \
           -I ip/common_cells/include/

RTL_OBI = ip/obi/src/obi_intf.sv \
          ip/obi/src/obi_mux.sv \
          ip/obi/src/obi_demux.sv \
          ip/obi/src/obi_err_sbr.sv \
          ip/obi/src/obi_sram_shim.sv

RTL_COMMON = ip/common_cells/src/fifo_v3.sv \
             ip/common_cells/src/rr_arb_tree.sv \
             ip/common_cells/src/delta_counter.sv \
             ip/common_cells/src/lzc.sv

RTL_QSPI_XIP = ip/EF_QSPI_XIP_CTRL/hdl/rtl/EF_QSPI_XIP_CTRL.v \
               ip/EF_QSPI_XIP_CTRL/hdl/rtl/DMC.v \
               ip/EF_QSPI_XIP_CTRL/hdl/rtl/bus_wrappers/EF_QSPI_XIP_CTRL_AHBL.v \

RTL_PSRAM = ip/EF_PSRAM_CTRL_V2/hdl/rtl/EF_PSRAM_CTRL.v \
            ip/EF_PSRAM_CTRL_V2/hdl/rtl/bus_wrapper/EF_PSRAM_CTRL_AHBL.v

RTL_UART = ip/EF_UART/hdl/rtl/EF_UART.v \
           ip/EF_UART/hdl/rtl/bus_wrappers/EF_UART_AHBL.v

EF_RTL_CLKGATE = ip/EF_IP_UTIL/hdl/ef_util_lib.v

RTL_SV2V = $(RTL_OBI) \
           $(RTL_COMMON) \
           $(wildcard ip/cv32e40x/rtl/*.sv) \
           src/soc/greyhound_soc.sv \
           src/soc/dummy_extension.sv \
           src/soc/fabric_extension.sv \
           src/soc/obi2ahbm_adapter.sv

CONVERTED_RTL = src/soc/greyhound_soc.v

RTL = $(RTL_QSPI_XIP) \
      $(RTL_PSRAM) \
      $(RTL_UART) \
      $(EF_RTL_CLKGATE)

RTL_FPGA = fpga/ulx3s_top.sv \
           rtl/cv32e40x_fpga_clock_gate.sv

convert:
	sv2v $(INCLUDES) $(PACKAGES) $(RTL_SV2V)  --top=greyhound_soc --write=$(CONVERTED_RTL) -D COMMON_CELLS_ASSERTS_OFF -D PnR #--verbose --siloed # --exclude always
.PHONY: convert

lint:
	verilator --lint-only $(INCLUDES) $(PACKAGES) $(RTL_SV2V) $(RTL) --top-module greyhound_soc -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC -Wno-UNOPTFLAT -Wno-BLKANDNBLK -Wno-TIMESCALEMOD
.PHONY: lint

lint-after:
	verilator --lint-only $(CONVERTED_RTL) $(RTL) rtl/cv32e40x_sim_clock_gate.sv --top-module greyhound_soc -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC -Wno-UNOPTFLAT -Wno-BLKANDNBLK -Wno-TIMESCALEMOD
.PHONY: lint-after

# ------------------------

RUN_TAG = $(shell ls runs/ -1 | tail -n 1)
TOP = greyhound_ihp_top

$(echo $RUN_TAG)

PDK_ROOT ?= /home/leo/Repositories/IHP-Open-PDK
PDK ?= ihp-sg13g2

copy-final:
	mkdir -p final/pnl/
	mkdir -p final/spice/
	mkdir -p final/nl/
	mkdir -p final/gds/
	mkdir -p final/odb/
	mkdir -p final/def/
	mkdir -p final/spef/nom/

	cp runs/${RUN_TAG}/final/pnl/${TOP}.pnl.v final/pnl/${TOP}.pnl.v
	#cp runs/${RUN_TAG}/final/spice/${TOP}.spice final/spice/${TOP}.spice
	cp runs/${RUN_TAG}/final/nl/${TOP}.nl.v final/nl/${TOP}.nl.v
	cp runs/${RUN_TAG}/final/gds/${TOP}.gds final/gds/${TOP}.gds
	cp runs/${RUN_TAG}/final/odb/${TOP}.odb final/odb/${TOP}.odb
	cp runs/${RUN_TAG}/final/def/${TOP}.def final/def/${TOP}.def
	cp runs/${RUN_TAG}/final/spef/nom/${TOP}.nom.spef final/spef/nom/${TOP}.nom.spef
	
	gzip final/gds/${TOP}.gds
	gzip final/odb/${TOP}.odb
	
.PHONY: copy-final

edit-netlists:
	mkdir -p final/nl_edit/
	mkdir -p final/pnl_edit/
	mkdir -p final/spice_edit/
	
	cp final/nl/${TOP}.nl.v final/nl_edit/${TOP}.nl.v
	cp final/pnl/${TOP}.pnl.v final/pnl_edit/${TOP}.pnl.v
	cp final/spice/${TOP}.spice final/spice_edit/${TOP}.spice
	
	# Make sure iverilog can simulate the nl
	sed -i "s/\\\\sg13g2_IOPadIOVdd_west.iovdd_RING/1'b0/g" final/nl_edit/${TOP}.nl.v
	sed -i "s/\\\\sg13g2_IOPadIOVdd_west.iovss_RING/1'b0/g" final/nl_edit/${TOP}.nl.v
	sed -i "s/\\\\sg13g2_IOPadIOVdd_west.vdd_RING/1'b0/g" final/nl_edit/${TOP}.nl.v
	sed -i "s/\\\\sg13g2_IOPadIOVdd_west.vss_RING/1'b0/g" final/nl_edit/${TOP}.nl.v
	
	# Net going into the power bondpads is the same as in the core
	sed -i 's/\\sg13g2_IOPadIOVdd_west.iovdd_RING/IOVDD/g' final/pnl_edit/${TOP}.pnl.v
	sed -i 's/\\sg13g2_IOPadIOVdd_west.iovss_RING/IOVSS/g' final/pnl_edit/${TOP}.pnl.v
	sed -i 's/\\sg13g2_IOPadIOVdd_west.vdd_RING/VDD/g' final/pnl_edit/${TOP}.pnl.v
	sed -i 's/\\sg13g2_IOPadIOVdd_west.vss_RING/VSS/g' final/pnl_edit/${TOP}.pnl.v
	
	# Rename to better names
	sed -i 's/sg13g2_IOPadIOVdd_west.iovdd_RING_uq0/IOVDD/g' final/spice_edit/${TOP}.spice
	sed -i 's/sg13g2_IOPadIOVdd_west.iovss_RING_uq0/IOVSS/g' final/spice_edit/${TOP}.spice
	sed -i 's/sg13g2_IOPadIOVdd_west.vdd_RING/VDD/g' final/spice_edit/${TOP}.spice
	sed -i 's/sg13g2_IOPadIOVdd_west.vss_RING/VSS/g' final/spice_edit/${TOP}.spice
.PHONY: edit-netlists

insert-logo:
	mkdir -p final/gds_logo/
	python3 scripts/insert_logo.py final/gds/${TOP}.gds.gz logo/smooth/gds/greyhound_logo.gds final/gds_logo/${TOP}.gds.gz
.PHONY: insert-logo

create-image:
	PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) klayout -z -r scripts/klayout_image.py -rd input_gds=final/gds_logo/${TOP}.gds.gz -rd output_image=img/${TOP}.png
	convert img/${TOP}.png -resize 25% img/${TOP}_small.png
.PHONY: create-image

TIM_PDK_ROOT ?= /home/leo/Repositories/IHP-Open-PDK-tim

fill:
	PDK_ROOT=$(TIM_PDK_ROOT) PDK=$(PDK) $(TIM_PDK_ROOT)/$(PDK)/libs.tech/magic/generate_fill.py final/gds_logo/${TOP}.gds.gz -dist
	
	# Move the fill pattern, it's saved under gds/ because of how generate_fill works...
	mkdir -p final/gds_fill/
	mv final/gds/${TOP}_fill_pattern.gds.gz final/gds_fill/${TOP}_fill_pattern.gds.gz
	
	# Merge layout with fill
	python3 scripts/merge_fill.py final/gds_logo/${TOP}.gds.gz final/gds_fill/${TOP}_fill_pattern.gds.gz final/gds_fill/${TOP}.gds.gz
	
	# Run density check
	PDK_ROOT=$(TIM_PDK_ROOT) PDK=$(PDK) $(TIM_PDK_ROOT)/$(PDK)/libs.tech/magic/check_density.py final/gds_fill/${TOP}.gds.gz
.PHONY: fill

extract:
	@echo "\
	# Read LEFs\n\
	lef read $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef\n\
	lef read $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef\n\
	# Read I/Os without obstructions due to bug\n\
	lef read $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_io/lef/sg13g2_io_noobs.lef\n\
	lef read $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_1024x16_c2_bm_bist.lef\n\
	lef read ip/fabulous_fabric/fabric_ihp/macro/ihp-sg13g2/lef/eFPGA.lef\n\
	lef read ip/bondpad/bondpad_70x70.lef\n\
	\n\
	# Read DEF\n\
	def read final/def/${TOP}.def\n\
	\n\
	# Set abstract cells\n\
	load eFPGA\n\
	property LEFview true\n\
	load RM_IHPSG13_1P_1024x16_c2_bm_bist\n\
	property LEFview true\n\
	load bondpad_70x70\n\
	property LEFview true\n\
	load sg13g2_IOPadInOut30mA\n\
	property LEFview true\n\
	load sg13g2_IOPadIn\n\
	property LEFview true\n\
	load sg13g2_IOPadOut30mA\n\
	property LEFview true\n\
	load sg13g2_IOPadIOVdd\n\
	property LEFview true\n\
	load sg13g2_IOPadIOVss\n\
	property LEFview true\n\
	load sg13g2_IOPadVss\n\
	property LEFview true\n\
	load sg13g2_IOPadVdd\n\
	property LEFview true\n\
	\n\
	load ${TOP} -dereference\n\
	\n\
	set extdir extraction/\n\
	set netlist final/spice/${TOP}.spice\n\
	\n\
	file mkdir \$$extdir\n\
	cd \$$extdir\n\
	\n\
	extract do local\n\
	extract no capacitance\n\
	extract no coupling\n\
	extract no resistance\n\
	extract no adjust\n\
	extract unique\n\
	# extract warn all\n\
	extract\n\
	\n\
	ext2spice lvs\n\
	\n\
	ext2spice -o ../\$$netlist ${TOP}.ext\n\
	feedback save feedback.txt\n\
	exit" > extract_script.tcl
	
	magic -dnull -noconsole -rcfile $(PDK_ROOT)/$(PDK)/libs.tech/magic/ihp-sg13g2.magicrc extract_script.tcl
.PHONY: extract

lvs:
	@echo "\
	set circuit1 [readnet spice final/spice_edit/${TOP}.spice]\n\
	set circuit2 [readnet verilog /dev/null]\n\
	readnet spice $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice \$$circuit2\n\
	readnet spice $(PDK_ROOT)/$(PDK)/libs.ref/sg13g2_io/spice/sg13g2_io.spi \$$circuit2\n\
	readnet verilog final/pnl_edit/${TOP}.pnl.v \$$circuit2\n\
	lvs \"\$$circuit1 ${TOP}\" \"\$$circuit2 ${TOP}\" $(PDK_ROOT)/$(PDK)/libs.tech/netgen/ihp-sg13g2_setup.tcl netgen_lvs.rpt -blackbox" > lvs_script.tcl
	
	netgen -batch source lvs_script.tcl
.PHONY: lvs

drc:
	klayout -b -r $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/drc/sg13g2_minimal.lydrc -rd in_gds=final/gds_fill/${TOP}.gds.gz -rd cell=${TOP} -rd report_file=sg13g2_minimal.lyrdb -rd logfile="sg13g2_minimal.log" -rd threads=$(shell nproc)
.PHONY: drc

drc-full:
	klayout -b -r $(PDK_ROOT)/$(PDK)/libs.tech/klayout/tech/drc/sg13g2_maximal.lydrc -rd in_gds=final/gds_fill/${TOP}.gds.gz -rd cell=${TOP} -rd report_file=sg13g2_maximal.lyrdb -rd logfile="sg13g2_maximal.log" -rd threads=$(shell nproc)
.PHONY: drc-full

zip:
	gunzip final/gds_fill/${TOP}.gds.gz
	zip -r -s 50m final/gds_fill/${TOP}.gds.zip final/gds_fill/${TOP}.gds
	gzip final/gds_fill/${TOP}.gds
.PHONY: zip
