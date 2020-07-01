## AFM-tapping-util
**VMD-powered Tcl script for producing simulated scanning probe microscopy images (including tip convolution artifacts) from molecular structures.
###### Robert Alberstein, June 2020

**DESCRIPTION:**\
This utility performs a quite literal approximation to tapping/contact mode imaging by scanning probe microscopy/atomic force microscopy. A user-definable rectangular area is discretized into a 2D point grid, and the height at which the number of probe/atom overlaps is below a defined threshold (default = 0) is determined at each XY coordinate. This is written out to 2D plain text array of height values, producing a topographical map which can be directly visualized and analyzed via standard SPM/AFM software. Tip convolution is emulated by checking for atom overlaps within a volume enclosed by a cone with a hemispherical tip (see [1] for details). The tip radius and half-angle can be specified by the user.

The algorithm assumes that the structure to be "imaged" has already been placed such that it rests atop the plane Z = 0, and contains only atoms which want to be considered (e.g., hydrogens were omitted from protein structures). Recentering of the molecule at X = Y = 0 is recommended, but not strictly required, as the boundaries of the scan area (and thus its center) can be arbitrarily specified by the user. The example structures (located in structure_models/) are protein crystal models constructed from equilibrated RhuA protein coordinates, then recentered at the origin, then moved along +z until the lowest alpha carbon Z-coordinate = 0 (i.e., deposited onto a flat surface).
> (Additional NOTES & CAVEATS at end of README)


**INSTALLATION:**\
No installation of this utility is required. This utility is designed to be sourced within the software VMD, which is available for Linux, Windows, and OSX. Source code and precompiled binaries can be obtained from [2]. This version of the utility has been tested on VMD 1.9.3 in Linux Mint 19.3 and Windows 10. However, optional supplementary scripts which enable batch submission of parallel jobs currently require the use of bash scripts, and have only been tested in Linux environments.
   

**USAGE:**\
To run the utility, cd or initialize VMD in the folder containing the script and source it with the following cmdline arguments:\
(**NOTE:** structure_models/ is a REQUIRED subfolder for correct function (where the script looks for your molecular structures))

```
source tapping_convolution_sim_util.tcl -args NAME RADIUS THETA RES XMIN XMAX YMIN YMAX (TOL, ITER)
```

```
Variables:
  NAME = filename (prior to '.pdb') of the target structure, which must be located in the subfolder "structure_models"
  RADIUS = radius of tip probe, in angstroms
  THETA = half-angle of tip probe, in degrees
  RES = spatial resolution of output, in angstroms
  XMIN/XMAX = boundaries of X-dimension
  YMIN/YMAX = boundaries of Y-dimension
  TOL = optional parameter, number of allowed tip/protein overlaps at convergence, defaults to 0
  ITER = optional parameter, job number for batch jobs, not used for single runs
```
> (Command-line batch execution is also possible, as seen in `batch_submit_sim_tapping_util.sh`)

The above command will perform a continuous linescan over all points in the 2D space defined by the MIN/MAX dimensions. The arguments used to produce the example output can be found in the `batch_submit_tapping_util.sh` file in EXAMPLE/. Reproducing the example output (240 A x 240 A area at 0.5 A resolution) on a single core takes ~60 hours (230,400 points total, ~4000 points/hour). Since all points can be evaluated independently, multiple VMD instances can be run in batch mode and then concatenated together. This effectively drops the run time inversely to the degree of parallelization.

**BATCH SUBMISSION:**\
Batch submission scripts can be generated by editing parameters in `gen_batch_script_tapping_sim_util.py` to define the desired degree of parallelization and running it. This produces `batch_submit_sim_tapping_util.sh`, which can be run directly from the command line (usually into the background). Upon completion, the batch output can be merged by editing `merge_batch_output.sh` to match those of the desired run, and executing directly from the command line.

**DEMO USAGE:**\
The EXAMPLE folder contains:
```
  tapping_convolution_sim_util.tcl     - primary VMD script for performing tapping simulation
  gen_batch_script_tapping_sim_util.py	- (helper script) generates batch-submission bash script for parallel jobs
  batch_submit_tapping_util.sh		   - example batch submission script as output by gen_batch_script_tapping_sim_util.py
  merge_batch_output.sh			         - (helper script) concatenates batch output to single file
  example_output/                      - folder containing output from tappping simulations (*.dat/log)- information contained within filenames + logfiles
  structure_models/                    - REQUIRED folder for correct function. Where the script looks for your molecular structures.
```

**NOTES AND CAVEATS:**\
Note - Only tested only with PDB-format molecular coordinates (so far), but should work with any molecule that VMD can read in. ~!\

Minor caveat - The script uses the last atom of the PDB file as the probe tip. Depending on the initial position of that atom, an extremely minor image artifact could technically arise, though it should be negligible. In case of concern, a dummy atom PDB file has been stored in structure_models/ which can be appended to the end of the user's molecular structure to avoid this possibility. ~!






[1] https://doi.org/10.26434/chemrxiv.12014925.v1  
[2] https://www.ks.uiuc.edu/Research/vmd/  
