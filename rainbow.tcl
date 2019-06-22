# Written by Lazemare.
# This script is used to perform the rainbow color theme when drawing proteins by VMD.
# To use this script, you should change the coloring theme in Graphics-Representations to "index",
# the source rainbow.tcl in the Console. You can change the values of ry, yg, gc and cb to modify 
# proportion of these four colors, but  ry+yg+gc+cb should equals to 1.0.
# NOTE that when using this script, your system should contain the target protein only.
#--------------------------------------------------- 
# Here are the paras:
# red to yellow 
set ry 0.25
# yellow to green
set yg 0.25
# green to cyan
set gc 0.25
# cyan to blue
set cb 0.25
#--------------------------------------------------- 
set nm [ molinfo top get numatoms ]
if { $nm >= 1024 } {
	set nm1 [expr $nm / 1024 ]
	set count1 [ expr 1.0 / (1024 * $ry) ]
	set count2 [ expr 1.0 / (1024 * $yg) ]
	set count3 [ expr 1.0 / (1024 * $gc) ]
	set count4 [ expr 1.0 / (1024 * $cb) ]
	set cue1 [ expr 1024 * $ry ]
	set cue2 [ expr 1024 * $ry + 1024 * $yg]
	set cue3 [ expr 1024 * $ry + 1024 * $yg + 1024 * $gc]
	set color_start [colorinfo num]
	set r 0
	set g 0
	set b 0
	display update off
	for { set i $color_start } { $i < [expr 1024 + $color_start ] } { incr i } {
		if {$i < $cue1} {
			set r 1.0
			set g [ expr ($g + $count1) ]
			for {set k $i} { $k < [expr $nm1 + $i] } {incr k} {
				color change rgb  $k $r $g 0 
			}
		}
		if {$i > $cue1 && $i < $cue2} {
			set g 1.0
			set r [ expr ($r - $count2) ]
			for {set k $i} { $k < [expr $nm1 + $i] } {incr k} {
				color change rgb  $k $r $g 0
			}
		}
		if {$i > $cue2 && $i < $cue3} {
			set g 1.0
			set r 0
			set b [ expr ($b + $count3) ]
			for {set k $i} { $k < [expr $nm1 + $i] } {incr k} {
				color change rgb  $k 0 $g $b 
			}
		}
		if {$i > $cue3} {
			set b 1.0
			set g [ expr ($g - $count4) ]
			for {set k $i} { $k < [expr $nm1 + $i] } {incr k} {
				color change rgb  $i 0 $g $b
			}
		}
	}
	color Display Background white
	display update on
} else {
	set nm1 [ expr 1024/$nm ]
	set count1 [ expr 1.0 / (1024 * $ry) ]
	set count2 [ expr 1.0 / (1024 * $yg) ]
	set count3 [ expr 1.0 / (1024 * $gc) ]
	set count4 [ expr 1.0 / (1024 * $cb) ]
	set cue1 [ expr 1024 * $ry ]
	set cue2 [ expr 1024 * $ry + 1024 * $yg]
	set cue3 [ expr 1024 * $ry + 1024 * $yg + 1024 * $gc]
	set color_start [colorinfo num]
	set r 0
	set g 0
	set b 0
	display update off
	for { set i $color_start } { $i < [expr 1024 + $color_start ] } { incr i } {
		if {$i < $cue1} {
			set r 1.0
			set g [ expr ($g + $count1) ]
			for {set k $i} { $k < [expr $nm1 + $i] } {incr k} {
			color change rgb  $k $r $g 0 
			}
		}
		if {$i > $cue1 && $i < $cue2} {
			set g 1.0
			set r [ expr ($r - $count2) ]
			for {set k $i} { $k < [expr $nm1 + $i] } {incr k} {
				color change rgb  $k $r $g 0
			}
		}
		if {$i > $cue2 && $i < $cue3} {
			set g 1.0
			set r 0
			set b [ expr ($b + $count3) ]
			for {set k $i} { $k < [expr $nm1 + $i] } {incr k} {
				color change rgb  $k 0 $g $b 
			}
		}
		if {$i > $cue3} {
			set b 1.0
			set g [ expr ($g - $count4) ]
			for {set k $i} { $k < [expr $nm1 + $i] } {incr k} {
				color change rgb  $i 0 $g $b
			}
		}
	}
	color Display Background white
	display update on
}
