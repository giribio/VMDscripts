# Written by Lazemare.
# This script is used to calculate RMSD of selected structures.
# ref_frame is the frame number you want to compare with.
# sel is the structure you want to calculate RMSD.
#--------------------------------------------------- 
# Here are the paras:
set ref_frame 0
set sel "protein"
set outfile [open rmsd.dat w] 
#---------------------------------------------------
set nf [molinfo top get numframes]   
set f0 [atomselect top "$sel" frame $ref_frame]
set select [atomselect top "$sel"]    
# rmsd calculation loop   
for { set i 1 } { $i <= $nf } { incr i } {    
$select frame $i  
puts $outfile "[measure rmsd $select $f0] " 
}
close $outfile

