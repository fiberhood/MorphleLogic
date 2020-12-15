# Power nets
set ::power_nets [list $::env(VDD_PIN) ::env(_VDD_NET_NAME)]
set ::ground_nets [list $::env(GND_PIN) ::env(_GND_NET_NAME)]

set ::macro_blockage_layer_list "li1 met1 met2 met3 met4 met5"

pdngen::specify_grid stdcell {
    name grid
    core_ring {
                met5 {width $::env(_WIDTH) spacing $::env(_SPACING) core_offset $::env(_H_OFFSET)}
                met4 {width $::env(_WIDTH) spacing $::env(_SPACING) core_offset $::env(_V_OFFSET)}
        }
    rails {
    }
    straps {
	    met4 {width 1.6 pitch $::env(FP_PDN_VPITCH) offset $::env(FP_PDN_VOFFSET)}
	    met5 {width 1.6 pitch $::env(FP_PDN_HPITCH) offset $::env(FP_PDN_HOFFSET)}
    }
   connect {{met4 met5}}
}

pdngen::specify_grid macro {
    power_pins "VPWR"
    ground_pins "VGND"
    blockages "li1 met1 met2 met3 met4"
    straps { 
    } 
    connect {{met4_PIN_ver met5}}
}

set ::halo 10

# POWER or GROUND #Std. cell rails starting with power or ground rails at the bottom of the core area
set ::rails_start_with "POWER" ;

# POWER or GROUND #Upper metal stripes starting with power or ground rails at the left/bottom of the core area
set ::stripes_start_with "POWER" ;
