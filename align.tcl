# Written by Lazemare.
# This script is used to align frames by selections.
# align_frame is the frame number you want to align to.
# align_ref is the reference alignment.
# align_selection is the items you want to align.
#--------------------------------------------------- 
# Here are the paras:
set align_frame 0
set align_selection "protein"
set align_ref "protein"
#---------------------------------------------------
set nf [molinfo top get numframes]
set f0 [atomselect top "$align_ref" frame $align_frame]
set f [atomselect top "$align_ref"]
set sel [atomselect top "$align_selection"]
for { set i 1 } { $i < $nf } { incr i } {
$f frame $i
$sel frame $i
set mv [measure fit $f $f0]
$sel move $mv
}

