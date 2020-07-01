# AFM-tapping-util
###### VMD-powered Tcl script for producing simulated scanning probe microscopy images (including tip convolution artifacts) from molecular structures.
**Robert Alberstein, June 2020**

**DESCRIPTION:**\
This utility performs a quite literal approximation to tapping/contact mode imaging by scanning probe microscopy/atomic force microscopy. A user-definable rectangular area is discretized into a 2D point grid, and the height at which the number of probe/atom overlaps is below a defined threshold (default = 0) is determined at each XY coordinate. This is written out to 2D plain text array of height values, producing a topographical map which can be directly visualized and analyzed via standard SPM/AFM software. Tip convolution is emulated by checking for atom overlaps within a volume enclosed by a cone with a hemispherical tip (see [1] for details). The tip radius and half-angle can be specified by the user.

The algorithm assumes that the structure to be "imaged" has already been placed such that it rests atop the plane Z = 0, and contains only atoms which want to be considered (e.g., hydrogens were omitted from protein structures). Recentering of the molecule at X = Y = 0 is recommended, but not strictly required, as the boundaries of the scan area (and thus its center) can be arbitrarily specified by the user. The example structures (located in structure_models/) are protein crystal models constructed from equilibrated RhuA protein coordinates, then recentered at the origin, then moved along +z until the lowest alpha carbon Z-coordinate = 0 (i.e., deposited onto a flat surface).

! Additional NOTES & CAVEATS at end of README !


**INSTALLATION:**\
No installation of this utility is required. This utility is designed to be sourced within the software VMD, which is available for Linux, Windows, and OSX. Source code and precompiled binaries can be obtained from [2]. This version of the utility has been tested on VMD 1.9.3 in Linux Mint 19.3 and Windows 10. However, optional supplementary scripts which enable batch submission of parallel jobs currently require the use of bash scripts, and have only been tested in Linux environments.
   

**USAGE:**\
To run the utility, cd or initialize VMD in the folder containing the script and source the script with the following parameters:\
```source tapping_convolution_sim_util.tcl -args NAME RADIUS THETA RES XMIN XMAX YMIN YMAX (TOL, ITER)```
    (Command-line batch execution is also possible)



**NOTES AND CAVEATS:**\
Note - Only tested only with PDB-format molecular coordinates (so far), but should work with any molecule that VMD can read in. ~!\

Minor caveat - The script uses the last atom of the PDB file as the probe tip. Depending on the initial position of that atom, an extremely minor image artifact could technically arise, though it should be negligible. In case of concern, a dummy atom PDB file has been stored in structure_models/ which can be appended to the end of the user's molecular structure to avoid this possibility. ~!






[1] https://doi.org/10.26434/chemrxiv.12014925.v1  
[2] https://www.ks.uiuc.edu/Research/vmd/  
