# FracVAL_cda_helpers
A set of helper functions and scripts written for R in order to first generate a series of aggregates with FracVAL and subsequently analyse them using cda

The R libraries used are: 
library(cda)
library(dielectric)
library(ggplot2)
library(gridExtra)
library(reshape2)
library(plyr)
library(rgl)
library(matrixStats)


The files provides are:

Common_functions.R
	#This defines most of the important functions used in the other scripts

Measure_spacing.R
	#This is an example file of how to measure the spacing generated between primary particles in an aggergate

Manage_FracVAL_runs.R
	#This is a script which helps to manage the creation of input files to FracVal and also run those files to generate the aggregates necessary to run the coupled dipole approximation on

Control_script_general.R
	#This is a script which sets up and calcuates the dispersion spectra in multiple sub-jobs of a series of different aggregates created using Manage_FracVAL_runs.R. 
	 This could for instance be a range of PP sizes or different values of Df. Each set of aggregates should be in a seperate folder just as when generate from Manage_FracVAL

Space_job_control.R
	#This is a script which sets up and calcuates the dispersion spectra from one set of aggregates created with a particular value using Manage_FracVAL but with the spacing between
	 primary particles in each aggregate varied.

In order to run this program a complete installation of the coupled dipole approximation by Baptiste Auguié https://github.com/nano-optics/cda (https://zenodo.org/record/60310#.X-ELmNhKiUk) is required

In order to generate the aggregates FracVAL is used (publication: https://doi.org/10.1016/j.cpc.2019.01.015, code: http://dx.doi.org/10.17632/mgf8wdcsfb.1)

If you find this code useful please cite https://pubs.acs.org/doi/10.1021/acsanm.1c00668

The folders Dfvals_ # contain some test aggregates as examples that were generated with "Manage_FracVAL_runs.R" and can be analysed with both "Control_script_general.R" and "Space_job_control.R"
