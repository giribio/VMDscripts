# Written by Lazemare.
# Used to calculate the distribution alone the simulation trajectory of
# the distance between two structures (for example, two residues), and 
# give out the distribution percentage.
#--------------------------------------------------- 
# Here are the paras:
set outfile [open distance_distribution.dat w]
set select1 "index 0"
set select2 "index 1"
#---------------------------------------------------
set nf [molinfo top get numframes]
set sel1 [atomselect top "$select1"]
set sel2 [atomselect top "$select2"]
set maxdis 0.0
set mindis 1E100
for { set i 1 } { $i <= $nf } { incr i } {  
	$sel1 frame $i
	set V1 [measure center "$sel1"]
	$sel2 frame $i
	set V2 [measure center "$sel2"]
	set VA [vecsub $V1 $V2]
	set DISTA [veclength $VA]
    if {$DISTA > $maxdis} {
        set maxdis $DISTA
    }
    if {$DISTA < $mindis} {
        set mindis $DISTA
    }
}
set npoints [expr int(floor([expr $maxdis * 500] - [expr $mindis * 500]))]
for { set i 0 } { $i < $npoints } { incr i } {    
	set density($i) 0.0
}
for { set i 1 } { $i <= $nf } { incr i } {  
	$sel1 frame $i
	set V1 [measure center "$sel1"]
	$sel2 frame $i
	set V2 [measure center "$sel2"]
	set VA [vecsub $V1 $V2]
	set DISTA [veclength $VA]
    set index [expr int(floor([expr ($DISTA - $mindis) * 500]))]
	set density($index) [expr $density($index) + 1.0]
}
for { set i 0 } { $i < $npoints } { incr i } {    
	set density($i) [expr $density($i) / $nf * 100]
	puts -nonewline $outfile "[expr $mindis + $i / 500.0]"
	puts -nonewline $outfile " "
	puts $outfile "[expr $density($i)]"
}
close $outfile
puts "All Done!"
