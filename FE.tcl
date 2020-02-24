#---------------------------------------------------
# Here are the paras:
set infile [open dihedral_distribution.dat r]
set outfile [open FE.dat w]
set temp 300
set unit kj
#---------------------------------------------------
set cue 0
set minfe Inf
set linenumber 0
fconfigure $infile -buffering line
if {$unit == "kj"} {

	while {$cue != -1} {
		set cue [gets $infile data]
		if {$cue != 0 && $cue != -1} {
			set p [lindex $data 1]
			set fe($linenumber) [expr log([expr $p / 100])*-1*1.380649E-23*6.02E23/1000*$temp]
			if {$fe($linenumber) < $minfe} {
				set minfe $fe($linenumber)
			}
			set idx($linenumber) [lindex $data 0]
			set linenumber [expr $linenumber + 1]
		}
	}

} elseif {$unit == "kcal"} {

	while {$cue != -1} {
		set cue [gets $infile data]
		if {$cue != 0 && $cue != -1} {
			set p [lindex $data 1]
			set fe($linenumber) [expr log([expr $p / 100])*-1*3.297623E-24*6.02E23/1000*$temp]
			if {$fe($linenumber) < $minfe} {
				set minfe $fe($linenumber)
			}
			set idx($linenumber) [lindex $data 0]
			set linenumber [expr $linenumber + 1]
		}

	}
}
for { set i 0 } { $i < [expr $linenumber] } { incr i } {
	set fe($i) [expr $fe($i) - $minfe]
}
for { set i 0 } { $i < [expr $linenumber] } { incr i } {
	puts -nonewline $outfile $idx($i)
	puts -nonewline $outfile "    "
	puts -nonewline $outfile $fe($i)
	puts -nonewline $outfile "\n"
}
close $infile
close $outfile
puts "All Done!"