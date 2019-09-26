# Written by Lazemare.
# This script is used to calculate the proportion of secondary structure
# in given structures (e.g. protein) with the DSSP package. NOTE that if 
# you would like to use this script, you must install the DSSP program
# (https://github.com/cmbi/xssp) first.
# select_env is the structure you will analysis. But note that this selection 
# must be a complete structure, but cannot be some parts of a whole protein 
# chain. For example, you can set this variable as "protein" or "protein and chain A". 
# execname is the name of your DSSP executable file.
# select is the residue range of your analysis. For example, if you set select_env 
# as "protein" and select as "protein and resid 10 to 20", the script will calculate 
# the number of selected structure type in resid 10 to 20 only, and gives out the 
# proportion of this number in the number of residues in the whole protein.
# freq is the frequency you would like to perform the calculation.
# structure is the structure type you want to analysis with DSSP.
# The value could be one of these options:
# H                  Alpha Helix
# B                  Beta Bridge
# E                  Strand
# G                  Helix-3
# I                  Helix-5
# T                  Turn
# S                  Bend
# Here are the paras:
#---------------------------------------------------
set outfile [ open alpha_2.dat w ]
set select "protein and resid 10 to 20"
set select_env "protein"
set structure E
set execname mkdssp
set freq 1
#---------------------------------------------------
proc readDSSPoutput {dsspout structure reslist} {

    set fp [open "$dsspout" r]
    fconfigure $fp -buffering line
    gets $fp data
    set helix 0.0
    while {[lindex $data 0] != "AUTHOR"} {
        gets $fp data
    }
    gets $fp data
    set numresidues [lindex $data 0]
    # puts "$numresidues"
    while {[lindex $data 0] != "#"} {
        gets $fp data
    }
    for {set i 1} {$i < $numresidues} {incr i} {
        gets $fp data
        if {[lindex $data 4] == "$structure" && [lsearch $reslist [lindex $data 1]] != -1} {
            set helix [expr $helix + 1.0]
            # puts -nonewline [lindex $data 1]
            # puts [lindex $data 4]
        }
    }
    close $fp

return [expr $helix / $numresidues * 100]
}

set nf [molinfo top get numframes]
set sel [atomselect top "$select"]
set reslist [lsort -unique [$sel get resid]]
set sel_env [atomselect top "$select_env"]
set reslist 
for { set i 1 } { $i < $nf } { incr i $freq } {
    $sel_env frame $i
	$sel_env writepdb temp.pdb
	exec $execname -i temp.pdb -o temp.dssp
	set helix [readDSSPoutput temp.dssp $structure $reslist]
    puts -nonewline $outfile "$i"
    puts -nonewline $outfile " "
    puts $outfile "$helix"
    puts -nonewline "Finished " 
    puts -nonewline [expr int([expr ($i * 1.0) / $nf * 100])]
    puts " %"
}
file delete temp.pdb
file delete temp.dssp
close $outfile
puts "All Done!"
