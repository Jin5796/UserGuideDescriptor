# Clear Environments
rm(list = ls())
graphics.off()

library(stringr)
library(plyr)
home=getwd() #
data=dir(path='F:/2ndALL/0 Gaussian16计算文件_替换2分子/3ndOPT_log_out/',pattern="\\.log")
data=gsub(".log","",data)
CHEMICAL=gsub("p","",data)

df=data.frame(CHEMICAL)
df$error=NA
df$Jobs=NA
df$imag=NA
df$HF3ndOPT=NA
df$Gibbs=NA
df$Enthalpy=NA
df$Entropy=NA
df$Polarizability=NA

for (i in 1:length(CHEMICAL)){
  fp <- paste('F:/2ndALL/0 Gaussian16计算文件_替换2分子/3ndOPT_log_out/p', CHEMICAL[i], ".log", sep="")  
  logfile <- scan(file=fp, what=character(), sep="\n")
  rindx=grep(paste("^",CHEMICAL[i],"$",sep=""),df$CHEMICAL)
  
  #check for Normal terminations, jobs
  norm=grep("Normal termination", logfile)
  jobs=grep("Job cpu",logfile)
  if(length(norm)==length(jobs)){
  df$Jobs[rindx]=length(jobs)}
  else{df$Jobs[rindx]="Unkown"}
  
  lerr=grep("Error termination via",logfile)
  ntrerr=grep("Error termination in NtrErr:",logfile)
  wtime=grep("Walltime for job",logfile)
  if (length(lerr)>0 | length(ntrerr)>0){
    errortype=str_extract(logfile[lerr],"...\\.exe")
    if (length(ntrerr)>0) errortype="NtrErr"
    df$error[rindx]=gsub("\\.exe","",errortype)
    next
  }
  if (length(wtime)<1){
    df$error[rindx]="DNF"
    #next
  }
  
  # Index start of optimization and frequency archive sections
  opt=grep("\\\\FOpt\\\\",logfile)
  freq=grep("\\\\Freq\\\\",logfile)
  
  # Index start and end of all archive sections
  loc.start=grep("GINC",logfile)
  loc.end=grep("@",logfile)
  
  # Ensure equal # of start and end lines
  if(length(loc.start)!=length(loc.end))  next
  
  ####  Get imaginary frequencies
  
  if (any(grepl(max(freq),loc.start))){
    endindx=grep("TRUE",grepl(max(freq),loc.start))
    df1=NULL
    for (j in max(freq):loc.end[endindx]){
      df1=paste(df1,logfile[j],sep="")      
    }
    df1=gsub(" ","",df1)
    
    imag=str_extract(df1,"NImag=.")
    imnum=as.numeric(gsub("NImag=","",imag))
    df$imag[rindx]=imnum
    if (imnum>0) next    
  }
  
  ####  Get HF energies
  
  if (any(grepl(max(opt),loc.start))){
    endoptindx=grep("TRUE",grepl(max(opt),loc.start))
    df2=NULL
    for (q in max(opt):loc.end[endoptindx]){
      df2=paste(df2,logfile[q],sep="")      
    }
    df2=gsub(" ","",df2)
    
    hf=str_extract(df2,"\\\\HF=[^\\\\]*")
    hfnum=gsub("\\\\HF=","",hf)
    df$HF3ndOPT[rindx]=hfnum
  }
  
  ####  Get Gibbs(Hartree/Particle), Enthalpy(Hartree/Particle), Entropy(Cal/Mol-Kelvin) and polarizability(Bohr**3).
  loc.gibbs=max(grep("Sum of electronic and thermal Free Energies=",logfile))
  gibbs=logfile[loc.gibbs]
  gibbs=gsub("Sum of electronic and thermal Free Energies=","",gibbs)
  gibbs=gsub(" ","",gibbs)
  df$Gibbs[rindx]=gibbs
  
  loc.enth=max(grep("Sum of electronic and thermal Enthalpies=",logfile))
  enth=logfile[loc.enth]
  enth=gsub("Sum of electronic and thermal Enthalpies=","",enth)
  enth=gsub(" ","",enth)
  df$Enthalpy[rindx]=enth
  
  loc.S=max(grep("CV",logfile))
  loc.S=loc.S+2
  Snum=gsub(x=str_sub(string=logfile[[loc.S]], start=-13), pattern=" ", replacement="")
  df$Entropy[rindx]=Snum

  polar_loc = max(grep(pattern="Isotropic", x=logfile))
  if (length(polar_loc)>0) polarizability = gsub(x=str_sub(string=logfile[[polar_loc]], start=-21, end=-9), pattern=" ", replacement="")
  if (length(polarizability)>0) df$Polarizability[rindx]=as.numeric(polarizability)
  
  }
write.csv(df, file="F:/2ndALL/0 Gaussian16计算文件_替换2分子/Log_3ndOPT_Freq.csv", row.names=F)