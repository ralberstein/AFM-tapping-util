;##########################################
;#Simulates tapping mode AFM for a rounded#
;# tip of specified radius of curvature   #
;#Robert Alberstein, June 2018            #
;# Finalized June 2020                    #
;##########################################

### INPUT PARAMETERS ###
;#Takes in parameters from command line:
;# namebase, radius, theta, resolution, xmin, xmax, ymin, ymax, [tolerance = 0, iteration = 0]

;#Exits if not enough parameters
if {[llength $argv] < 8} {
  puts "Not enough parameters specified!\nAt minimum, script requires filename, tip radius, tip half-angle, XY resolution, x_min, x_max, y_min, y_max dimensions + optional overlap tolerance, and iteration number values."
  exit
}

set namebase [lindex $argv 0]   ;#Name of pdb file
set radius [lindex $argv 1]     ;#Tip radius in angstroms
set theta [lindex $argv 2]      ;#Tip half-angle in degrees
set resolution [lindex $argv 3]	;#Sampling density in angstroms

;#Dimension limits (Angstroms)
set xmin [lindex $argv 4]
set xmax [lindex $argv 5]
set ymin [lindex $argv 6]
set ymax [lindex $argv 7]

;#Initialize default values for optional variables
set olaptol 0			  ;#Set tolerance (# of overlapping atoms allowed)
set iter "single"		;#Iteration (job) number for parallel runs (default serial run)
set outname "AFMsim_${namebase}_radius${radius}_angle${theta}_res${resolution}_overlap${olaptol}_convolution.dat"	;#Single job calculation

;#Update optional values as needed
if {[llength $argv] == 9} {
  set olaptol [lindex $argv 8]	;#Update tolerance value
  set outname "AFMsim_${namebase}_radius${radius}_angle${theta}_res${resolution}_overlap${olaptol}_convolution.dat"	;#Single job default
}
if {[llength $argv] == 10} {
  set iter [lindex $argv 9]	    ;#Update iteration (job) number
  set outname "AFMsim_${namebase}_radius${radius}_angle${theta}_res${resolution}_overlap${olaptol}_convolution.iter${iter}.dat"	;#Multiple iterations
}

;#Log run info for verification/bookkeeping (single run or first job only)
  if {$iter == "single" || $iter == 0} {
  set fout [open "AFMsim_${namebase}_radius${radius}_angle${theta}_res${resolution}_overlap${olaptol}_convolution.log" w]
  puts $fout "Using the following parameters for structure $namebase.pdb:"
  puts $fout "Radius = $radius, Half-angle = $theta, Resolution = $resolution A, Xdim min/max = $xmin/$xmax, Ydim min/max = $ymin/$ymax, Overlap tolerance = $olaptol, Job number: $iter"
  close $fout
}

### ### ### ### ###
;#Assumes pdb files are in a defined subfolder
set pdbin structure_models/${namebase}.pdb

mol new $pdbin waitfor all
set sele [atomselect top all]
set dum_id [$sele num]		;#Use last atom in pdb as dummy probe (PDBs can be first merged w/ dummy_probe.pdb if desired)


;#Variables: tip_x, tip_y, probe_radius, tip_halfangle, overlap tolerance
;#Returns: Zheight of probe bottom at convergence
proc check_overlaps_convolve {x y r theta olaptol} {
  set toradian 0.0174533		              ;#Factor to convert degrees -> radians
  set rtheta [expr {$theta * $toradian}]  ;#Convert tip half-angle to radians
  set sintheta [expr {sin($rtheta)}]      ;#Calculate sin(theta)
  set tan2theta [expr {tan($rtheta)**2}]  ;#Calculate tan(theta)^2
  set r2 [expr {$r * $r}]                 ;#Calculate radius squared

  set margin [expr {$r * 2.0}]            ;#Adjust tip Zpos coarsely at first, then continuously reduce
  set TOL 0.01                            ;#Height error tolerance in angstroms
  set target_flag 0                       ;#Flag for completion of while loop
  set direction 1.0                       ;#Direction flag via scaling (-1 to move down, +1 to move up)

  set z $r                                ;#Start at tip_z=radius (aka height=0)
  set dz [expr {$r / $sintheta}]          ;#Distance from sphere center to z0
  set delz [expr {$r * $sintheta}]        ;#Distance from sphere center to zmin
  set zmin [expr {$z - $delz}]            ;#Zheight where tip is tangent to spherical probe
  set z0 [expr {$z - $dz}]                ;#Zheight of conical tip apex (always z0 < z)

  ;#Selection representing a sphere-tipped conical probe using parametric equations
  set overlaps [atomselect top "(((x-$x)**2 + (y-$y)**2 - (((z-$z0)**2)*$tan2theta) <= 0) and (z > $zmin)) or ((x-$x)**2 + (y-$y)**2 + (z-$z)**2 <= $r2)"]

  ;#Automatically return if there are no immediate overlaps (usually where surface atoms would be)
  if {[$overlaps num] == 0} {
    return 0.0				;#Height = 0 (flat background)
  }

  ;#Rapidly increase Zpos out of initial overlap ranges by jumping
  ;# in increments of margin, then finer margin changes on way back.
  ;#First coarsely determines height at which there are no overlaps
  while {[$overlaps num] > 0} {
    set z0 [expr {$z0 + $margin}]
    set zmin [expr {$zmin + $margin}]
    set z [expr {$z + $margin}]
    $overlaps delete
    set overlaps [atomselect top "(((x-$x)**2 + (y-$y)**2 - (((z-$z0)**2)*$tan2theta) <= 0) and (z > $zmin)) or ((x-$x)**2 + (y-$y)**2 + (z-$z)**2 <= $r2)"]
  }
  set direction -1.0                          ;#Switch to moving downwards
  set margin [expr {0.5 * $margin}]           ;#Scale margin for refinement

  ### MAIN LOOP ###
  ;#Keep going until converged (overlaps <= target, and Zpos change < tolerance)
  while {$target_flag == 0} {

    ;#Check for convergence each iteration (from ABOVE mica surface)
    if {[$overlaps num] <= $olaptol && $margin <= $TOL} {
      set target_flag 1			;#Update flag if convergence reached
      $overlaps delete
      return [expr {$z - $r}]		;#Return Zpos at bottom of probe ("true" molecular height)
    }

    ;#We're moving DOWN (getting INTO overlaps)
    while {[$overlaps num] <= $olaptol} {
      set z0 [expr {$z0 + $direction * $margin}]
      set zmin [expr {$zmin + $direction * $margin}]
      set z [expr {$z + $direction * $margin}]
      $overlaps delete
      set overlaps [atomselect top "(((x-$x)**2 + (y-$y)**2 - (((z-$z0)**2)*$tan2theta) <= 0) and (z > $zmin)) or ((x-$x)**2 + (y-$y)**2 + (z-$z)**2 <= $r2)"]
    }
    set direction 1.0                         ;#Switch to moving upwards
    set margin [expr {0.5 * $margin}]         ;#Finer margin going back up

    ;#We're moving UP (getting AWAY from overlaps)
    while {[$overlaps num] > $olaptol} {
      set z0 [expr {$z0 + $direction * $margin}]
      set zmin [expr {$zmin + $direction * $margin}]
      set z [expr {$z + $direction * $margin}]
      $overlaps delete
      set overlaps [atomselect top "(((x-$x)**2 + (y-$y)**2 - (((z-$z0)**2)*$tan2theta) <= 0) and (z > $zmin)) or ((x-$x)**2 + (y-$y)**2 + (z-$z)**2 <= $r2)"]
    }
    set direction -1.0                        ;#Switch to moving downwards
    set margin [expr {0.5 * $margin}]         ;#Finer margin going back down
  }
}

### FINAL OUTPUT ###
;#Open file for writing
set fout [open $outname w]

;#Loop over all positions
set curr_x $xmin
set curr_y $ymax

;#Loop through each y-coordinate, generating rows of height values
while {$curr_y >= $ymin} {
  set curr_x $xmin
  set row {}

  ;#Loop through each x-coordinate
  while {$curr_x <= $xmax} {
    lappend row [check_overlaps_convolve $curr_x $curr_y $radius $theta $olaptol] ;#Calculate height for current XY position
    set curr_x [expr {$curr_x + $resolution}]                                     ;#Update current X position
  }
  puts $fout $row                                                                 ;#Write out row of heights
  set curr_y [expr {$curr_y - $resolution}]                                       ;#Update current Y position
}

close $fout

exit
