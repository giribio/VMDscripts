# Written by Lazemare.
# This script is used to renumber the residues in protein, in another word, 
# align the first resid to a specific number. 
# Before using this script, you must load your system in VMD, and make sure 
# it is the top molecular.
#--------------------------------------------------- 
# Here are the paras:
set first_resid 261
set output_name new
#---------------------------------------------------
set all [atomselect top "all"]
set reslist [lsort -decreasing -integer -unique [$all get resid]]
set firstnum [lindex $reslist [expr [llength $reslist] - 1]]
set incrnum [expr $first_resid - $firstnum]
if {$incrnum < 0} {
	unset reslist
	set reslist [lsort -increasing -integer -unique [$all get resid]]
}
foreach res $reslist {
	set tmp [atomselect top "resid $res"]
	$tmp set resid [expr $res + $incrnum]
}
set all [atomselect top "all"]
$all writepdb $output_name.pdb