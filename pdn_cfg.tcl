source $::env(SCRIPTS_DIR)/openroad/common/set_global_connections.tcl
set_global_connections

set secondary []
foreach vdd $::env(VDD_NETS) gnd $::env(GND_NETS) {
    if { $vdd != $::env(VDD_NET)} {
        lappend secondary $vdd

        set db_net [[ord::get_db_block] findNet $vdd]
        if {$db_net == "NULL"} {
            set net [odb::dbNet_create [ord::get_db_block] $vdd]
            $net setSpecial
            $net setSigType "POWER"
        }
    }

    if { $gnd != $::env(GND_NET)} {
        lappend secondary $gnd

        set db_net [[ord::get_db_block] findNet $gnd]
        if {$db_net == "NULL"} {
            set net [odb::dbNet_create [ord::get_db_block] $gnd]
            $net setSpecial
            $net setSigType "GROUND"
        }
    }
}

# core voltage domain
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# stdcell grid
define_pdn_grid -name stdcell_grid -voltage_domains {CORE}

add_pdn_ring \
	-grid stdcell_grid \
	-layers "$::env(FP_PDN_VERTICAL_LAYER) $::env(FP_PDN_HORIZONTAL_LAYER)" \
	-widths "$::env(FP_PDN_CORE_RING_VWIDTH) $::env(FP_PDN_CORE_RING_HWIDTH)" \
	-spacings "$::env(FP_PDN_CORE_RING_VSPACING) $::env(FP_PDN_CORE_RING_HSPACING)" \
	-core_offsets "$::env(FP_PDN_CORE_RING_VOFFSET) $::env(FP_PDN_CORE_RING_HOFFSET)" \
	-connect_to_pads

add_pdn_stripe \
	-grid stdcell_grid \
	-layer $::env(FP_PDN_RAIL_LAYER) \
	-width $::env(FP_PDN_RAIL_WIDTH) \
	-followpins \
    -starts_with POWER

add_pdn_stripe \
	-grid stdcell_grid \
	-layer $::env(FP_PDN_VERTICAL_LAYER) \
	-width $::env(FP_PDN_VWIDTH) \
	-pitch $::env(FP_PDN_VPITCH) \
	-offset $::env(FP_PDN_VOFFSET) \
    -spacing $::env(FP_PDN_VSPACING) \
	-starts_with POWER \
	-extend_to_core_ring

add_pdn_stripe \
	-grid stdcell_grid \
	-layer $::env(FP_PDN_HORIZONTAL_LAYER) \
	-width $::env(FP_PDN_HWIDTH) \
	-pitch $::env(FP_PDN_HPITCH) \
	-offset $::env(FP_PDN_HOFFSET) \
    -spacing $::env(FP_PDN_HSPACING) \
	-starts_with POWER \
	-extend_to_core_ring

add_pdn_connect -grid stdcell_grid -layers "$::env(FP_PDN_RAIL_LAYER) $::env(FP_PDN_VERTICAL_LAYER)"
add_pdn_connect -grid stdcell_grid -layers "$::env(FP_PDN_VERTICAL_LAYER) $::env(FP_PDN_HORIZONTAL_LAYER)"

# eFPGA grid
define_pdn_grid \
    -macro \
    -instances "i_greyhound_ihp.fabric_wrapper.eFPGA" \
    -name eFPGA \
    -starts_with POWER

add_pdn_connect \
    -grid eFPGA \
    -layers "$::env(FP_PDN_VERTICAL_LAYER) $::env(FP_PDN_HORIZONTAL_LAYER)"

# fabric sram/bram grid
define_pdn_grid \
    -macro \
    -instances "\
i_greyhound_ihp.fabric_wrapper.sram0 \
i_greyhound_ihp.fabric_wrapper.sram1 \
i_greyhound_ihp.fabric_wrapper.sram2 \
i_greyhound_ihp.fabric_wrapper.sram3 \
i_greyhound_ihp.fabric_wrapper.bram0 \
i_greyhound_ihp.fabric_wrapper.bram1 \
i_greyhound_ihp.fabric_wrapper.bram2 \
i_greyhound_ihp.fabric_wrapper.bram3" \
    -name fabric_sram \
    -starts_with POWER

add_pdn_connect \
    -grid fabric_sram \
    -layers "Metal4 TopMetal1"

# soc sram grid
define_pdn_grid \
    -macro \
    -instances "\
i_greyhound_ihp.i_soc_sram0 \
i_greyhound_ihp.i_soc_sram1" \
    -name soc_sram \
    -starts_with POWER

add_pdn_stripe \
    -grid soc_sram \
    -layer Metal5 \
    -width 2.81 \
    -pitch 11.24 \
    -offset 2.81 \
    -spacing 2.81 \
    -nets "VSS VDD" \
    -starts_with POWER

add_pdn_connect \
    -grid soc_sram \
    -layers "Metal4 Metal5"
add_pdn_connect \
    -grid soc_sram \
    -layers "Metal5 TopMetal1"
