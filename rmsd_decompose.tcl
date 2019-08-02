# Written by Lazemare.
# This script is used to decompose RMSD of protein into 
# contributions of each residue, and give out the ratio.
# But if you would like to, this script can also be used to 
# items expect proteins, for example, nucleic acids.
# ref_frame is the frame number you want to compare with.
# aim_frame is the frame number your want to decompose RMSD.
# cutoff is the number of frames before and after aim_frame
# to be used for RMSD calculation.
# sel is the structure you want to calculate RMSD.
#--------------------------------------------------- 
# Here are the paras:
set ref_frame 0
set aim_frame 200
set cutoff 20
set sel "protein"
set outfile [open rmsd_d.dat w] 
#---------------------------------------------------
set nf [molinfo top get numframes] 
set select [atomselect top "$sel" frame 0]
set select_ref [atomselect top "$sel" frame 0]
set reslist [lsort -integer -unique [$select get resid]]
set startframe 0
set endframe 0
if {$cutoff > $nf} {
    puts "You have set a very big cutoff value, which is larger than the total frame number!!!"
    exit
}
if {$aim_frame == "first"} {
    set aim_frame 0
} elseif {$aim_frame == "last"} {
    set aim_frame $nf
}
if {$nf < [expr ($aim_frame + $cutoff)]} {
    set startframe [expr ($nf - 2 * $cutoff)]
    set endframe $nf
} elseif {[expr ($aim_frame - $cutoff)] < 0} {
    set startframe 0
    set endframe [expr (2 * $cutoff)]
} else {
    set startframe [expr ($aim_frame - $cutoff)]
    set endframe [expr ($aim_frame + $cutoff)]
}
# rmsd calculation loop
set nframes [expr ($endframe - $startframe + 1)]
set atomlist_tot [$select_ref get index]
set natoms_tot [expr [lindex $atomlist_tot [expr [llength $atomlist_tot] - 1]] - [lindex $atomlist_tot 0] + 1]
unset atomlist_tot
foreach res $reslist {
     set rmsd_rat($res) 0.0
}
for { set i $startframe } { $i <= $endframe } { incr i } {     
    $select frame $i
    set rmsd_tot 0.0
    set rmsd_tot [measure rmsd $select $select_ref]
    set rmsd_tmp 0.0
    set rmsd_rat(0) 0.0
    foreach res $reslist {
        set res_ref [atomselect top "$sel and resid $res" frame $ref_frame]
        set tmp_aim [atomselect top "$sel and resid $res" frame $i]
        set atomlist [$res_ref get index]
        set natoms [expr [lindex $atomlist [expr [llength $atomlist] - 1]] - [lindex $atomlist 0] + 1]
        unset atomlist
        set rmsd_tmp [measure rmsd $res_ref $tmp_aim]
        set rmsd_rat($res) [expr ($rmsd_rat($res) + ($rmsd_tmp / $rmsd_tot) * ($rmsd_tmp / $rmsd_tot) * $natoms / $natoms_tot * 100)]
    }
}
foreach res $reslist {
    set rmsd_rat($res) [expr ($rmsd_rat($res) / $nframes)]
    puts -nonewline $outfile "$res "
    puts $outfile "$rmsd_rat($res)"
}
unset rmsd_rat
close $outfile
