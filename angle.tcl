# Written by Lazemare.
# Used to calculate the include angle between two structures (for example, two α-helices).
# Note that select1 and select3 are starting points of these two structures, and
# select1 and select3 are end points of these two structures. Thus, select1 and select3  
# could be the same or not.
#--------------------------------------------------- 
# Here are the paras:
set outfile [open angle.dat w]
set select1 "protein and resid 1"
set select2 "protein and resid 2"
set select3 "protein and resid 2"
set select4 "protein and resid 3"
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
	set VA [vecsub $V1 $V2]
	set VB [vecsub $V3 $V4]
	set COSAB [expr [vecdot $VA $VB]/([veclength $VA]*[veclength $VB])]
	set ANGLE [expr acos($COSAB)*180/3.1415926] 
	puts $outfile "[expr $ANGLE]"
}
close $outfile
puts "All Done!"
