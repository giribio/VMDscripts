# Written by Lazemare.
# This script is used to decompose RMSD of protein into 
# contributions of each residue, and gives out average
# RMSD of these residues in given range of frames.
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
set aim_frame last
set cutoff 10
set sel "protein"
set outfile [open rmsd_d.dat w] 
#---------------------------------------------------
set nf [molinfo top get numframes] 
set select [atomselect top "$sel" frame 0]
set reslist [lsort -integer -unique [$select get resid]]
# rmsd calculation loop
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
set nframes [expr ($endframe - $startframe)]
foreach res $reslist {
	set res_ref [atomselect top "$sel and resid $res" frame $ref_frame]
    set tmp_aim [atomselect top "$sel and resid $res" frame 0]
    puts -nonewline $outfile "$res "
    set rmsd_tmp 0.0
    for { set i $startframe } { $i <= $endframe } { incr i } {     
        $tmp_aim frame $i
        set rmsd_tmp [expr ($rmsd_tmp + [measure rmsd $res_ref $tmp_aim])]
    }
    set avg_rmsd_tmp [expr ($rmsd_tmp / $nframes)]
	puts $outfile "$avg_rmsd_tmp" 
}
close $outfile
