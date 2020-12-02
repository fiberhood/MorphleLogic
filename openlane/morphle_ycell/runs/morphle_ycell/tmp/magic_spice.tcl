
lef read /opt/asic/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/morphle_ycell/runs/morphle_ycell/results/routing/ycell.def
load ycell -dereference
cd /project/openlane/morphle_ycell/runs/morphle_ycell/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice ycell.ext
feedback save /project/openlane/morphle_ycell/runs/morphle_ycell/logs/magic/magic_ext2spice.feedback.txt
# exec cp ycell.spice /project/openlane/morphle_ycell/runs/morphle_ycell/results/magic/ycell.spice

