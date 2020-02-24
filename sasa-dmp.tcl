#---------------------------------------------------
# sasa-dmp.tcl: VMD Tcl Script to perform SASA 
# calculation with multiprocessor support.
#---------------------------------------------------

#---------------------------------------------------
# params
#---------------------------------------------------
# IOs
set vmdexec vmd
set dcdfile ubq_wb_eq.dcd
set psffile ubq_wb.psf
set nproc   4
# SASA
set outfile "sasa.dat"
set select1 "all and protein"
set select2 "all and protein"
set srad    1.4
set freq    1
#---------------------------------------------------

#---------------------------------------------------
# split DCD File
#---------------------------------------------------
proc splitDCD {psffile dcdfile nproc} {
    mol load psf $psffile dcd $dcdfile
    set nf [molinfo top get numframes]
    set id [molinfo top get id]
    set step [expr $nf / $nproc]
    puts "spliting DCD file into $nproc parts ..."
    for { set i 0 } { $i < $nproc } { incr i 1 } {
        set nb [expr $i * $step]
        set ne [expr ($i + 1) * $step - 1]
        puts "$i.dcd: from frame $nb to frame $ne"
        animate write dcd "$i.dcd" beg $nb end $ne $id
    }
    puts "Note: above files will be deleted later."
    mol delete all
    return $step
}
#---------------------------------------------------

#---------------------------------------------------
# dump scripts
#---------------------------------------------------
proc dumpscripts {psffile step nproc select1 select2 srad freq} {
    puts "writing scripts for each trajectory ..."
    for { set i 0 } { $i < $nproc } { incr i 1 } {
        set initframe [expr $i * $step]
        set script [open $i.tcl w]
        puts $script "mol load psf $psffile dcd $i.dcd"
        puts $script "set outfile \[open sasa$i.dat w\]"
        puts $script "set select1 \"$select1\""
        puts $script "set select2 \"$select2\""
        puts $script "set srad $srad"
        puts $script "set freq $freq"
        puts $script "set nf \[molinfo top get numframes\]"
        puts $script "set flag 1"
        puts $script "for \{ set i 0 \} \{ \$i < \$nf \} \{ incr \$flag \} \{"
        puts -nonewline $script "set sasa \[measure sasa \$srad "
        puts -nonewline $script "\[atomselect top \"\$select1\" frame \$i\] "
        puts $script "-restrict \[atomselect top \"\$select2\" frame \$i\]\]"
        puts $script "set frame_now \[expr $initframe + \$i + 1\]"
        puts $script "puts \$outfile \"\$frame_now \$sasa\""
        puts $script "set i \[expr \$i + \$freq\] \}"
        puts $script "close \$outfile"
        puts $script "mol delete all"
        puts $script "exit"
        puts $script "   "
        close $script
        puts "script $i.tcl has been written."
    }
}
#---------------------------------------------------

#---------------------------------------------------
# parallel run
#---------------------------------------------------
proc parallelrun {nproc vmdexec step} {
    puts "Runing tasks ..."
    # First (nproc - 1) tasks will be run in background.
    for { set i 0 } { $i < [expr $nproc - 1] } { incr i 1 } {
        exec vmd -dispdev none -e $i.tcl > /dev/null 2>> /dev/null &
    }
    # The last task will be run in foreground. When this task
    # terminaled, all tasks should have been terminaled.
    set lasttask [expr $nproc - 1]
    exec $vmdexec -dispdev none -e $lasttask.tcl > /dev/null 2>> /dev/null
    # Wait
    sleep [expr $nproc * 1.5]
    puts "#--------------------------------------"
}
#---------------------------------------------------

#---------------------------------------------------
# make some checks
#---------------------------------------------------
proc check {nproc} {
    set flag 0
    for { set i 0 } { $i < $nproc } { incr i 1 } {
        if {[file exist sasa$i.dat]} {
            set flag [expr $flag + 1]
        }
    }
    if {$flag == $nproc} {
        puts "All tasks finished."
    } else {
        error "Tasks unfinished!!!"
    }
}
#---------------------------------------------------

#---------------------------------------------------
# collect results and do some clean
#---------------------------------------------------
proc collect {nproc filename} {
    set outfp [open $filename w]
    set files {}
    for { set i 0 } { $i < $nproc } { incr i 1 } {
        lappend files "sasa$i.dat"
    }
    foreach tmp $files {
        set fp [open $tmp r]
        set data [read $fp [file size $tmp]]
        puts $outfp $data
        close $fp
    }
    close $outfp
    puts "output file $filename has been written."
    # delete sasa$i.dat
    foreach tmp $files {
        file delete $tmp 
    }
    # delete $i.dcd
    set files {}
    for { set i 0 } { $i < $nproc } { incr i 1 } {
        lappend files "$i.dcd"
    }
    foreach tmp $files {
        file delete $tmp 
    }
    # delete $i.tcl
    set files {}
    for { set i 0 } { $i < $nproc } { incr i 1 } {
        lappend files "$i.tcl"
    }
    foreach tmp $files {
        file delete $tmp 
    }
    puts "finished cleaning."
}
#---------------------------------------------------

#---------------------------------------------------
# main loop
#---------------------------------------------------
set step [splitDCD $psffile $dcdfile $nproc]
dumpscripts $psffile $step $nproc $select1 $select2 $srad $freq
parallelrun $nproc $vmdexec $step
check $nproc
collect $nproc $outfile
puts "All Done!"
#---------------------------------------------------
