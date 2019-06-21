# Written by Lazemare.
# Used to calculate the distance between two structures (for example, two residues).
#--------------------------------------------------- 
# Here are the paras:
set outfile [open distance.dat w]
set select1 "protein and resid 10"
set select2 "protein and resid 20"
#---------------------------------------------------
set nf [molinfo top get numframes]
set sel1 [atomselect top "$select1"]
set sel2 [atomselect top "$select2"]
for { set i 1 } { $i <= $nf } { incr i } {  
	$sel1 frame $i
	set V1 [measure center "$sel1"]
	$sel2 frame $i
	set V2 [measure center "$sel2"]
	set VA [vecsub $V1 $V2]
	set DISTA [veclength $VA]
	puts $outfile $DISTA
}
close $outfile
puts "All Done!"
