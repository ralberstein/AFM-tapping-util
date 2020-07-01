############################################################
# Generates batch submission file for tapping calculations #
# Robert Alberstein, June 2018                             #
#  Finalized June 2020                                     #
############################################################

### USER VARIABLE INPUT FOR PARALLELIZATION ###
parallel = 24 	#Number of cores (recommend multiple of (ymax-ymin)/res); 24 or 30 works well for example dimensions below

### USER VARIABLE INPUT FOR TAPPING SCRIPT ###
name = "periodic_4x4_uniform_open-noh_rezero"			   #Open Cterm down
#name = "periodic_4x4_uniform_closed-noh_flipped_rezero"    #Closed Nterm down
#name = "periodic_6x6_F88-90A_crystal-noh_rezero"           #F88 lattice orientation 1
#name = "periodic_6x6_F88-90A_crystal-noh_flipped_rezero"	#F88 lattice orientation 2

### USER VARIABLE INPUT FOR PROBE PARAMETERS ###
radius = 10.0	#Tip radius
theta = 20.0	#Tip half-angle
res = 0.50      #Image resolution

ymax =  120.0	#Dims are +/- 120.0 for p4 crystals (slight excess around 3x3 lattice)
ymin = -120.0   #Dims are +/- 90.0 for each 2x2 in F88 lattice (up to +/- 270.0 for entire 6x6 structure)
xmax =  120.0
xmin = -120.0

overlaps = 0	#Atom overlap tolerance (avg 9.35 heavy atoms per residue)
iteration = 0	#Counter for files

### ### ### ### END OF USER VARIABLE INPUT ### ### ###
######################################################

#Batch-mode variables
total_lines = (ymax - ymin)/res				#Total number of linescans to perform
lines_per_core = total_lines/parallel       #Distribution of linescans per VMD instance
increment = (lines_per_core * res)			#Ydim increment between runs
total_jobs = total_lines/lines_per_core		#Total number of jobs to run
curr_y = ymax                               #Initialize y_pos

#Open file for writing
fout = open("batch_submit_sim_tapping_util.sh", "w")

#Header info for script
fout.write("#!/bin/bash\n\n")

fout.write("NAME=%s\n" % name)
fout.write("RADIUS=%.1f\n" % radius)
fout.write("THETA=%.1f\n" % theta)
fout.write("RES=%.2f\n\n" % res)

fout.write("XMIN=%.1f\n" % xmin)
fout.write("XMAX=%.1f\n\n" % xmax)

fout.write("YMIN=%.1f\n" % ymin)
fout.write("YMAX=%.1f\n\n" % ymax)

fout.write("TOL=%i\n" % overlaps)
fout.write("ITER=%i\n\n" % total_jobs)


#Iteratively write out commands
while (curr_y >= ymin):
  fout.write("vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX %.1f %.1f $TOL %i > /dev/null &\n" % ((curr_y - increment + res), curr_y, iteration))
  iteration += 1
  curr_y -= increment

  #Run extra single-line job to reduce total # batch submission rounds by 1
  if (curr_y == ymin):
    fout.write("vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX %.1f %.1f $TOL %i > /dev/null &\n" % (curr_y, curr_y, iteration))
    break

  #Define end of batch submission round
  elif ((iteration % parallel == 0)):
    fout.write("wait\n")
fout.write("wait\n\n\n")	#Separate main util from housekeeping
fout.close()

exit()
