# Written by Lazemare.
# Used to calculate the Solvent accessible surface area (SASA) of given structures.
# Note that select1 is the structure you want to calclate SASA. If you would like 
# to calclate only one or several parts belong to select1, you could assign select2.
# You can modify extending of each radius by changing srad. The VMD user guide 
# recommends to set it to 1.4. 
#--------------------------------------------------- 
# Here are the paras:
set outfile [open sasa.dat w]
set select1 "protein"
set select2 "protein and resid 2"
set srad 1.4
#---------------------------------------------------
set nf [molinfo top get numframes]
for { set i 1 } { $i <= $nf } { incr i } {  
set sa [measure sasa $srad [atomselect top "$select1" frame $i] -restrict [atomselect top "$select2" frame $i]]
puts $outfile $sa
}
close $outfile
puts "All Done!"
