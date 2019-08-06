# Written by Lazemare.
# This script is used to calculate RMSF of residues in 
# selected structures.
# start_frame and end_frame are the starting and ending 
# frames of RMSF calculation. 
# sel is the structure you want to calculate RMSF.
#--------------------------------------------------- 
# Here are the paras:
set start_frame first
set end_frame last
set sel "protein"
set outfile [open rmsf.dat w] 
#---------------------------------------------------  
set select [atomselect top "$sel"]    
set nf [molinfo top get numframes] 
set reslist [lsort -integer -unique [$select get resid]]
if {$start_frame == "first"} {
        set start_frame 1
}
if {$end_frame == "last"} {
        set end_frame [expr $nf - 1]
}
# rmsf calculation loop   
foreach res $reslist {
    set sel_tmp [atomselect top "$sel and resid $res"]
    set atomlist [$sel_tmp get index]
    set natoms [expr [lindex $atomlist [expr [llength $atomlist] - 1]] - [lindex $atomlist 0] + 1]
    set rmsf_list [measure rmsf $sel_tmp first $start_frame last $end_frame]
    set rmsf_tmp 0
    for { set j 0 } { $j <= [expr $natoms - 1] } { incr j } { 
        set rmsf_tmp [expr $rmsf_tmp + [expr [lindex $rmsf_list $j]]]
    }
    set rmsf_tmp [expr $rmsf_tmp / $natoms]
    puts -nonewline $outfile "$res "
    puts $outfile "$rmsf_tmp"
}
close $outfile
puts "All Done!"