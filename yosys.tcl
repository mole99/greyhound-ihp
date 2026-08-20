yosys read_verilog -D FUNCTIONAL -D PnR -sv -setattr keep_hierarchy -lib fabrics/classic_fabric_greyhound/macro/ihp-sg13g2/nl/classic_fabric_greyhound.nl.v
yosys read_verilog -D FUNCTIONAL -D PnR -sv -setattr keep_hierarchy -lib $::env(PDK_ROOT)/$::env(PDK)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_1024x32_c2_bm_bist.v
yosys read_verilog -D FUNCTIONAL -D PnR -sv -setattr keep_hierarchy -lib $::env(PDK_ROOT)/$::env(PDK)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_2P_1024x16_c2_bm_bist.v
yosys read_verilog -D FUNCTIONAL -D PnR -sv -setattr keep_hierarchy -lib $::env(PDK_ROOT)/$::env(PDK)/libs.ref/sg13g2_io/verilog/sg13g2_io.v
#yosys read_verilog -D FUNCTIONAL -D PnR -sv -setattr keep_hierarchy -lib $::env(PDK_ROOT)/$::env(PDK)/libs.ref/sg13g2_stdcell/verilog/sg13g2_stdcell.v
#yosys read_verilog -D FUNCTIONAL -D PnR -sv -setattr keep_hierarchy -lib $::env(PDK_ROOT)/$::env(PDK)/libs.ref/sg13g2_stdcell/verilog/sg13g2_udp.v

# Because of yosys bug: https://github.com/YosysHQ/yosys/pull/5121
yosys read_verilog -sv -setattr keep_hierarchy -lib tb/sg13g2_stdcell.bb.v

yosys read_slang --ignore-assertions --keep-hierarchy -I ip/obi/include/ -I ip/common_cells/include/ -D FUNCTIONAL -D PnR -D DEBUG {*}$::env(SLANG_FILES) --top $::env(TOP)

yosys prep -top $::env(TOP)
#yosys synth -top $::env(TOP)

yosys write_verilog -sv -defparam $::env(OUTFILE)
