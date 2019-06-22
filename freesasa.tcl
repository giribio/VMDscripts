# Written by Lazemare.
# NOTE that this script could only be used under the bash shell, since it uses the grep command.
# I recommend you to used the sasa.tcl script in most cases, but not this script.
# This script was written to calculate the SASA of structures in MD trajectories using 
# the freeSASA software. Before using this script, you MUST BE SURE that one version of freeSASA package
# has been installed on your computer, which can be obtained freely from
# http://freesasa.github.io/ . When writting this script, I was using version 2.0.3 .
# freeSASA using the PyMol selection algebra (https://pymolwiki.org/index.php/Selection_Algebra),
# but doesn't support segname, pepseq or atom index. This means when you are using freeSASA,
# you can only select atoms by chain, resname and resid.
# select1 is the structure you want to calclate SASA. If you would like 
# to calculate only one or several parts belong to select1, you could assign select2.
# freq is the frequency you would like to perform the calculation.
# algo is the algorithm you want to use. S stands for Shrake & Rupley and L stands for Lee & Richards.
# prob is the probe radius to use.
# reso is the resolution to apply for the calculation. For S&R, this number represents the
# number of test points/atom (default is 100); for L&R, this number means slices/atom (default is 40).
# If you want to use the default value, set it to auto.
# npro is the number of processors you want to use. 
# NOTE THAT IT CAN NOT BE LARGER THAN 16!
#--------------------------------------------------- 
# Here are the paras:
set outfile [ open freesasa.dat w ]
set select1 "protein"
set select2 "protein and resid 10 to 20"
set freq 1
set algo L
set prob 1.4
set reso auto
set npro 4
#---------------------------------------------------

if { $reso == "auto" && $algo == "S" } { set reso 100 }
if { $reso == "auto" && $algo == "L" } { set reso 40 }
set sel_temp [atomselect top "$select2"]
set chainlist [ $sel_temp get chain ]
set residlist [ $sel_temp get resid ]
set conf_file [ open command.conf w+ ] 
puts -nonewline $conf_file "chain 00000000 "
foreach chain $chainlist resid $residlist {
	puts -nonewline $conf_file "or chain $chain and resi $resid "
}
close $conf_file
set conf_file [ open command.conf r ] 
set sel_pymol [ gets $conf_file ]
close $conf_file
set nf [ molinfo top get numframes ]
set flag 1
for { set i 1 } { $i < $nf } { incr $flag } {
	[atomselect top "$select1" frame $i] writepdb temp.pdb
	set temp_sasa [exec freesasa -w -$algo -p $prob -n $reso -t $npro --select "sel, $sel_pymol" temp.pdb | grep sel | tr -cd "0-9."]
	puts $outfile "$temp_sasa"
	set i [expr $i + $freq]
}
close $outfile
file delete temp.pdb
file delete command.conf
puts "All Done !"
