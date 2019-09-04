# Written by Lazemare.
# Used to calculate the dihedral between two planes, which are defined by four points.
# Note that these two two planes are defined separately by the position of select1, 
# select2, select3 and select2, select3, select4.
#--------------------------------------------------- 
# Here are the paras:
set outfile [open dihedral.dat w]
set select1 "protein and resid 1"
set select2 "protein and resid 2"
set select3 "protein and resid 3"
set select4 "protein and resid 4"
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
	set VA1 [vecsub $V2 $V1]
	set VA2 [vecsub $V3 $V1]
	set VB1 [vecsub $V3 $V2]
	set VB2 [vecsub $V4 $V2]
	set norm1 [veccross $VA1 $VA2]
	set norm2 [veccross $VB1 $VB2]
	set COSAB [expr [vecdot $norm1 $norm2]/([veclength $norm1]*[veclength $norm2])]
	set DIHED [expr acos($COSAB)*180/3.1415926] 
	puts $outfile "[expr $DIHED]"
}
close $outfile
puts "All Done!"
