# Written by Lazemare.
# Used to calculate the distribution alone the simulation trajectory of the include
# angle between two structures (for example, two α-helices), and give out the distribution 
# percentage. Note that select1 and select3 are starting points of these two structures, 
# while select2 and select4 are end points of these two structures. Thus, select1 and 
# select3 could be the same or not.
#--------------------------------------------------- 
# Here are the paras:
set outfile [open angle_distribution.dat w]
set select1 "index 189"
set select2 "index 188"
set select3 "index 190"
set select4 "index 188"
#---------------------------------------------------
set nf [molinfo top get numframes]
set sel1 [atomselect top "$select1"]
set sel2 [atomselect top "$select2"]
set sel3 [atomselect top "$select3"]
set sel4 [atomselect top "$select4"]
for { set i 0 } { $i < 180 } { incr i } {    
	set density($i) 0.0
}
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
    set index [expr int(floor([expr ($ANGLE + 180) / 2]))]
	set density($index) [expr $density($index) + 1.0]
}
for { set i 1 } { $i < 180 } { incr i } {    
	set density($i) [expr $density($i) / $nf * 100]
	puts -nonewline $outfile "[expr $i * 2 - 1 - 180 ]"
	puts -nonewline $outfile " "
	puts $outfile "[expr $density($i)]"
}
close $outfile
puts "All Done!"
