#read log files
# Clear all variables and close all figures
graphics.off()
rm(list = ls(all=TRUE))      

library(stringr)
library(plyr)

# List log files from directory, extract chemical name
data=dir(path="D:/111/wuxi/795/log", pattern="\\.log")

# Remove extension, leading j
#data1=gsub("CAS_","",data)
data=gsub(".log","",data)
chemical=gsub("p","",data)

#Build the data frame df
df=data.frame(chemical)
df$error=NA
df$Jobs=NA
df$imag=NA
df$LUMO=NA
df$HOMO=NA
df$HLG=NA
df$NLUMO=NA
df$NHOMO=NA
df$wallt=NA
  df$excSinglet_eV=NA
  df$calcLUMO_eV=NA
  df$TotEnergyTD=NA
  df$Oscillator_strength= NA
df$Re=NA
df$method= NA
# Loop through all log files in directory
for (i in 1:length(chemical)){
  
  #     Scan in each logfile
  fp <- paste("D:/111/wuxi/795/log/p", chemical[i], ".log", sep="")  
  
  logfile <- scan(file=fp, what=character(), sep="\n")
  
  # Index current chemical in data frame
  rindx=grep(paste("^",chemical[i],"$",sep=""),df$chemical)
  
  #check for Normal terminations, jobs
  norm=grep("Normal termination", logfile)
  jobs=grep("Job cpu",logfile)
  df$Jobs[rindx]=length(jobs)
  strtlnk = max(grep("Multiplicity", logfile))
  ljob = max(jobs)
    methocc1 = grep(pattern="#", x=logfile)
	methocc2 = grep(pattern="\\\\#", x=logfile)
  if (length(methocc2) > 0){ 
	methocc = methocc1[methocc1 != methocc2]
	methoccadd= methocc + 1
    ME = gsub(x=str_sub(string=logfile[max(methocc)], start=1), pattern=" ", replacement="")
	MEadd = gsub(x=str_sub(string=logfile[max(methoccadd)], start=1), pattern=" ", replacement="")
	ME = paste(ME,MEadd)
	df$method[rindx]=ME	
	}else{
	df$method[rindx]=gsub(x=str_sub(string=logfile[max(methocc1)], start=1), pattern=" ", replacement="")
	}
  #  check if an Error termination is there
  lerr=grep("Error termination via",logfile)
  ntrerr=grep("Error termination in NtrErr:",logfile)
  if (length(lerr)>0 | length(ntrerr)>0){
    errortype=str_extract(logfile[lerr],"...\\.exe")
    if (length(ntrerr)>0) errortype="NtrErr"
    df$error[rindx]=gsub("\\.exe","",errortype)
    next
  }
  
  lastocc = max(grep(pattern="Alpha  occ. eigenvalues", x=logfile))
  firstun = lastocc + 1
  singlet = min(grep(pattern="Excited State   1", x=logfile))
  energy = grep(pattern="Total Energy", x=logfile)
  RE = grep(pattern="Electronic spatial extent", x=logfile)

  HOMO = gsub(x=str_sub(string=logfile[[lastocc]], start=-8), pattern=" ", replacement="")
  if (nchar(logfile[[lastocc]])>40){
  NHOMO = gsub(x=str_sub(string=logfile[[lastocc]], start=-19, end=-9), pattern=" ", replacement="")
  }else{
  lastocc = lastocc - 1
  NHOMO = gsub(x=str_sub(string=logfile[[lastocc]], start=-8), pattern=" ", replacement="")
  }
  LUMO = gsub(x=str_sub(string=logfile[[firstun]], start=28, end=40), pattern=" ", replacement="")
  NLUMO = gsub(x=str_sub(string=logfile[[firstun]], start=41, end=49), pattern=" ", replacement="")
  HLG = as.numeric(LUMO) - as.numeric(HOMO)
  ExS = gsub(x=str_sub(string=logfile[[singlet]], start=-45, end=-39), pattern=" ", replacement="")
  OS = gsub(x=str_sub(string=logfile[[singlet]], start=-20, end=-15), pattern=" ", replacement="")
  ENG = gsub(x=str_sub(string=logfile[[max(energy)]], start=-18), pattern=" ", replacement="")
  Renum = gsub(x=str_sub(string=logfile[[RE]], start=-20), pattern=" ", replacement="")
  
  df$LUMO[rindx]=as.numeric(LUMO)
  df$HOMO[rindx] = HOMO
  df$HLG[rindx] = HLG
  df$NLUMO[rindx] =as.numeric(NLUMO)
  df$NHOMO[rindx] =as.numeric(NHOMO)
  df$excSinglet_eV[rindx]=ExS
  df$Oscillator_strength[rindx]=OS
  df$calcLUMO_eV[rindx]=as.numeric(ExS) + (as.numeric(HOMO)*27.211)
  df$TotEnergyTD[rindx]=as.numeric(ENG)
  df$Re[rindx] =as.numeric(Renum)
  
  }
#bracket for chemical for-loop

# save to a csv file
write.csv(df, file='D:/111/shi_jqxx/Multiwfn/sp/excited/Log_read_TDDFT_NLUMO_NHOMO_Re_1732.csv', row.names=F)