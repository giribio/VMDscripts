# Written by Lazemare.
# Used to calculate the Solvent accessible surface area (SASA) of given structures.
# Note that select1 is the structure you want to calclate SASA. If you would like 
# to calculate only one or several parts belong to select1, you could assign select2.
# You can modify extending of each radius by changing srad. The VMD user guide 
# recommends to set it to 1.4. 
# freq is the frequency you would like to perform the calculation.
#--------------------------------------------------- 
# Here are the paras:
set outfile [open sasa.dat w]
set select1 "protein"
set select2 "protein and resid 10 to 20"
set srad 1.4
set freq 1
#---------------------------------------------------
set nf [molinfo top get numframes]
set flag 1
for { set i 1 } { $i < $nf } { incr $flag } {
	set sasa [measure sasa $srad [atomselect top "$select1" frame $i] -restrict [atomselect top "$select2" frame $i]]
	puts $outfile $sasa
	set i [expr $i + $freq]
}
close $outfile
puts "All Done!"
