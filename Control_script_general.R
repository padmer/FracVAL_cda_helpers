#Main control script to create run and manage the numpart, Df, Kf and PPsize jobs and pull all the results together at the end
running<-TRUE

#In order to use the job functions in R
library("rstudioapi")

#point to Common_functions.R
common_func="C:/Users/padmer/OneDrive - KI.SE/R_CDA/FracVAL/PROGRAM_source_codes/test/Common_functions.R"

#Select Directory to run in
wd_fold="C:/Users/padmer/OneDrive - KI.SE/R_CDA/FracVAL/PROGRAM_source_codes/test"

#Change depending on what this should run on
seq_str="seq(1.2,2.4,0.2)"
fold_name="Dfvals_"

print("Check that I'm not running with reduced num")

#Define some functions to help manage runs

#run all the cda analysis job scripts in one go
run_cda_single<-function(line,numvals_start,numvals_stop){
  #line and ini_line make up most of the script content numvals_start is the value Dfvals_# to start from
  #numvals_stop is the Dfvals# to stop at
  
  for (i in numvals_start:numvals_stop){
    #Create filename for job
    nfile=paste("Job_temp",i,".R",sep="")
    
    #create unique content loading in the desired folder with aggregates
    indicom=paste("meanvals",i,"<-get_mean_from_fold_oa(folders[",i,"])",sep="")
    
    #Combine all into one text to write to the file
    lineall=paste(ini_line,line,indicom,sep="")
    
    #write to the file and run the job script and copy the results to the global environment
    write(lineall,file=nfile,append=TRUE)
    jobRunScript(nfile,exportEnv = "R_GlobalEnv")
  }
  
  #Define what variable names to expect from the job script
  variable2check<-list()
  for (i in numvals_start:numvals_stop){
    variable2check[[length(variable2check)+1]]<-paste("meanvals",i,sep="")
  }
  
  #remove files if they already exist
  rm(list=unlist(variable2check))
  
  
  #wait until all the variables have been created (wait for all jobs to have finished)
  alltrue<-TRUE
  while (alltrue) {
    for (i in variable2check){
      alltrue<-FALSE
      if (!exists(i)){
        alltrue<-TRUE
        break
      }
    }
    Sys.sleep(2)
  }
}

#run the cda anlyses in two seperate batches (if number of jobs is too high for number of processors)
run_cda_many<-function(line,numvals){
  half=floor(numvals/2)
  run_cda_single(line,1,half)
  run_cda_single(line,half+1,numvals)
}

setwd(wd_fold)

#define the bulk of the job file to run. This loads all of the agglomerates for every script.
#ini_line to set folder and load functions
ini_line=paste("setwd(","\"",wd_fold,"\")\n","source(","\"",common_func,"\")\n",sep="")

#run_functions
line=paste("Dfvals=",seq_str,"
folders=replicate(length(Dfvals),\"a\")
count=1

for (i in Dfvals){
  folders[[count]]=paste(\"",wd_fold,"/",fold_name,"\",i)
  count=count+1
}

",sep="")

#Choose whether to seperate the jobs into two batches or not and run them
numvals=length(eval(parse(text=seq_str)))
if (numvals>15){
  run_cda_many(line,numvals)
}else{
  run_cda_single(line,1,numvals)
}


#clean up the created job scripts
for (i in 1:numvals){
  nfile=paste("Job_temp",i,".R",sep="")
  unlink(nfile)
}

#generate list of variable names
variable2check<-list()
for (i in 1:numvals){
  variable2check[[length(variable2check)+1]]<-paste("meanvals",i,sep="")
}

#merge all the results from the job scripts into a single list
meanvalsabs<-list()
meanvalsext<-list()
for (i in variable2check){
  meanvalsabs[[length(meanvalsabs)+1]]<-eval(as.name(i))[[1]]
  meanvalsext[[length(meanvalsext)+1]]<-eval(as.name(i))[[2]]
}

#save the results to R datastructures
saveRDS(meanvalsabs,paste(fold_name,"abs",".RDS",sep=""))
saveRDS(meanvalsext,paste(fold_name,"ext",".RDS",sep=""))

running<-FALSE