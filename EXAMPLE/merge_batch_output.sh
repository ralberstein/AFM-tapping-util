#!/bin/bash

#Define variables used for data output
NAME=periodic_4x4_uniform_open-noh_rezero
#NAME=periodic_4x4_uniform_closed-noh_flipped_rezero
#NAME=periodic_6x6_F88-90A_crystal-noh_rezero
#NAME=periodic_6x6_F88-90A_crystal-noh_flipped_rezero

RADIUS=10.0
THETA=20.0
RES=0.50
TOL=0

#LAST iteration number
MAXITER=24

### ### ###

#Remove old merged data file (if exists) & create empty file for storing combined data
fname="AFMsim_${NAME}_radius${RADIUS}_angle${THETA}_res${RES}_overlap${TOL}_convolution"
if [ -f $fname.dat ] ; then
  rm ${fname}.dat
fi
touch ${fname}.dat

#Make folders if don't exist
mkdir -p temp_batch_job_storage

#Iteratively concatenate results into complete file
for (( iter=0; iter<=$MAXITER; iter++ )); do
  cat ${fname}.iter${iter}.dat >> ${fname}.dat &
  wait

  mv ${fname}.iter${iter}.dat temp_batch_job_storage/

done
