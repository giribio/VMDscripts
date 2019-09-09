# Written by Lazemare.
# Used to calculate the dihedral between two planes, which are defined by four points.
# Note that these two two planes are defined separately by the position of select1, 
# select2, select3 and select2, select3, select4.
#--------------------------------------------------- 
# Here are the paras:
set outfile [open dihedral.dat w]
set select1 "index 0"
set select2 "index 4"
set select3 "index 7"
set select4 "index 10"
#---------------------------------------------------
set nf [molinfo top get numframes]
set sel1 [atomselect top "$select1"]
set sel2 [atomselect top "$select2"]
set sel3 [atomselect top "$select3"]
set sel4 [atomselect top "$select4"]
for { set i 1 } { $i <= $nf } { incr i } {    
	$sel1 frame $i
	set V1 [measure center "$sel1"]
	$sel2 frame $i
	set V2 [measure center "$sel2"]
	$sel3 frame $i
	set V3 [measure center "$sel3"]
	$sel4 frame $i
	set V4 [measure center "$sel4"]
	set V1 [vecsub $V1 $V2]
	set V2 [vecsub $V3 $V2]
	set V3 [vecsub $V4 $V3]
	set norm1 [veccross $V1 $V2] 
	set norm2 [veccross $V2 $V3]
	set norm1 [vecscale [expr 1 / [veclength $norm1]] $norm1]
	set norm2 [vecscale [expr 1 / [veclength $norm2]] $norm2]
	set m [veccross $norm1 [vecscale [expr 1 / [veclength $V2]] $V2]]
	set x [vecdot $norm1 $norm2]
	set y [vecdot $m $norm2]
	set DIHED [expr atan2($y,$x)*180/3.1415926] 
	if {$DIHED > 0} {
		set DIHED [expr 180.0 - $DIHED]
	} else {
		set DIHED [expr -180.0 - $DIHED]
	}
	puts $outfile "[expr $DIHED]"
}
close $outfile
puts "All Done!"
