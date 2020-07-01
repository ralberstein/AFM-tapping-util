#!/bin/bash

NAME=periodic_4x4_uniform_open-noh_rezero
RADIUS=10.0
THETA=20.0
RES=0.50

XMIN=-120.0
XMAX=120.0

YMIN=-120.0
YMAX=120.0

TOL=0
ITER=24

vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 110.5 120.0 $TOL 0 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 100.5 110.0 $TOL 1 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 90.5 100.0 $TOL 2 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 80.5 90.0 $TOL 3 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 70.5 80.0 $TOL 4 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 60.5 70.0 $TOL 5 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 50.5 60.0 $TOL 6 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 40.5 50.0 $TOL 7 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 30.5 40.0 $TOL 8 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 20.5 30.0 $TOL 9 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 10.5 20.0 $TOL 10 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX 0.5 10.0 $TOL 11 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -9.5 0.0 $TOL 12 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -19.5 -10.0 $TOL 13 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -29.5 -20.0 $TOL 14 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -39.5 -30.0 $TOL 15 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -49.5 -40.0 $TOL 16 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -59.5 -50.0 $TOL 17 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -69.5 -60.0 $TOL 18 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -79.5 -70.0 $TOL 19 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -89.5 -80.0 $TOL 20 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -99.5 -90.0 $TOL 21 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -109.5 -100.0 $TOL 22 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -119.5 -110.0 $TOL 23 > /dev/null &
vmd -dispdev text -eofexit < tapping_convolution_sim_util.tcl -args $NAME $RADIUS $THETA $RES $XMIN $XMAX -120.0 -120.0 $TOL 24 > /dev/null &
wait


