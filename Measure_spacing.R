source("C:/Users/padmer/OneDrive - KI.SE/R_CDA/FracVAL/PROGRAM_source_codes/test/Common_functions.R")

#Select Directory to run in
wd_fold="C:/Users/padmer/OneDrive - KI.SE/R_CDA/FracVAL/PROGRAM_source_codes/test"

#Move to that directory
setwd(wd_fold)

#Define the range of "Multiplication factors" to measure the spacing of
spac=seq(0.8,1.45,0.05)

#Calculate the mean and standard deviation of the interparticle spacings
Inter_1p8=get_mean_std_interpart("Dfvals_ 1.8",spac)