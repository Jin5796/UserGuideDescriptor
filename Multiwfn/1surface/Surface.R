rm(list = ls())

library(stringr)
library(plyr)
home=getwd()
data=dir(path="D:/111/msf/fchk/",pattern="\\.txt")
data=gsub("_Surface.txt","",data)
CHEMICAL=gsub("p","",data)

df=data.frame(CHEMICAL)
df$Volume=NA
df$Density=NA
df$ESPI=NA
df$ESPA=NA
df$TA=NA
df$PA=NA
df$N_A=NA
df$ESPTA=NA
df$ESPPA=NA
df$ESPNA=NA
df$Tvariance=NA
df$Pvariance=NA
df$Nvariance=NA
df$BOC=NA
df$POS=NA
df$Pi=NA
df$MPI=NA
df$NSA=NA
df$PSA=NA

for (i in 1:length(CHEMICAL)){
  fp <- paste("D:/111/msf/fchk/p", CHEMICAL[i], "_Surface.txt", sep="")  
  logfile <- scan(file=fp, what=character(), sep="\n")
  rindx=grep(paste("^",CHEMICAL[i],"$",sep=""),df$CHEMICAL)
  
  loc.Volume=max(grep("Volume:",logfile))
  Volume=logfile[loc.Volume]
  Volume=gsub("Volume:","",Volume)
  Volume=gsub(" ","",Volume)
  Volume=gsub("\\(.*\\)","",Volume)
  Volumenum=gsub("Bohr\\^3","",Volume)
  df$Volume[rindx]=Volumenum
 
  loc.Density=max(grep("Estimated density according to mass and volume \\(.*\\):",logfile))
  Density=logfile[loc.Density]
  Density=gsub("Estimated density according to mass and volume \\(.*\\):","",Density)
  Density=gsub(" ","",Density)
  Densitynum=gsub("g\\/cm\\^3","",Density)
  df$Density[rindx]=Densitynum 
  
  loc.ESPI=max(grep("Minimal value:",logfile))
  ESPI=logfile[loc.ESPI]
  ESPI=gsub("Minimal value:","",ESPI)
  ESPI=gsub(" ","",ESPI)
  ESPI=gsub("kcal\\/molMaximalvalue:","\\(",ESPI)
  ESPI=gsub("kcal\\/mol","\\)",ESPI)
  ESPInum=gsub("\\(.*\\)","",ESPI)
  df$ESPI[rindx]=ESPInum
  
  loc.ESPA=max(grep("Maximal value:",logfile))
  ESPA=logfile[loc.ESPA]
  ESPA=gsub("Minimal value:","\\(",ESPA)
  ESPA=gsub(" ","",ESPA)
  ESPA=gsub("kcal\\/molMaximalvalue:","\\)",ESPA)
  ESPA=gsub("\\(.*\\)","",ESPA)
  ESPAnum=gsub("kcal\\/mol","",ESPA)
  df$ESPA[rindx]=ESPAnum
      
  loc.TA=max(grep("Overall surface area:",logfile))
  TA=logfile[loc.TA]
  TA=gsub("Overall surface area:","",TA)
  TA=gsub(" ","",TA)
  TA=gsub("\\(.*\\)","",TA)
  TAnum=gsub("Bohr\\^2","",TA)
  df$TA[rindx]=TAnum
  
  loc.PA=max(grep("Positive surface area:",logfile))
  PA=logfile[loc.PA]
  PA=gsub("Positive surface area:","",PA)
  PA=gsub(" ","",PA)
  PA=gsub("\\(.*\\)","",PA)
  PAnum=gsub("Bohr\\^2","",PA)
  df$PA[rindx]=PAnum
  
  loc.N_A=max(grep("Negative surface area:",logfile))
  N_A=logfile[loc.N_A]
  N_A=gsub("Negative surface area:","",N_A)
  N_A=gsub(" ","",N_A)
  N_A=gsub("\\(.*\\)","",N_A)
  N_Anum=gsub("Bohr\\^2","",N_A)
  df$N_A[rindx]=N_Anum
  
  loc.ESPTA=max(grep("Overall average value:",logfile))
  ESPTA=logfile[loc.ESPTA]
  ESPTA=gsub("Overall average value:","",ESPTA)
  ESPTA=gsub(" ","",ESPTA)
  ESPTA=gsub("\\(.*\\)","",ESPTA)
  ESPTAnum=gsub("a\\.u\\.","",ESPTA)
  df$ESPTA[rindx]=ESPTAnum

  loc.ESPPA=max(grep("Positive average value:",logfile))
  ESPPA=logfile[loc.ESPPA]
  ESPPA=gsub("Positive average value:","",ESPPA)
  ESPPA=gsub(" ","",ESPPA)
  ESPPA=gsub("\\(.*\\)","",ESPPA)
  ESPPAnum=gsub("a\\.u\\.","",ESPPA)
  df$ESPPA[rindx]=ESPPAnum

  loc.ESPNA=max(grep("Negative average value:",logfile))
  ESPNA=logfile[loc.ESPNA]
  ESPNA=gsub("Negative average value:","",ESPNA)
  ESPNA=gsub(" ","",ESPNA)
  ESPNA=gsub("\\(.*\\)","",ESPNA)
  ESPNAnum=gsub("a\\.u\\.","",ESPNA)
  df$ESPNA[rindx]=ESPNAnum
  
  loc.Tvariance=max(grep("Overall variance \\(sigma\\^2\\_tot):",logfile))
  Tvariance=logfile[loc.Tvariance]
  Tvariance=gsub("Overall variance \\(sigma\\^2\\_tot):","",Tvariance)
  Tvariance=gsub(" ","",Tvariance)
  Tvariance=gsub("\\(.*\\)","",Tvariance)
  Tvariancenum=gsub("a\\.u\\.\\^2","",Tvariance)
  df$Tvariance[rindx]=Tvariancenum
  
  loc.Pvariance=max(grep("Positive variance:",logfile))
  Pvariance=logfile[loc.Pvariance]
  Pvariance=gsub("Positive variance:","",Pvariance)
  Pvariance=gsub(" ","",Pvariance)
  Pvariance=gsub("\\(.*\\)","",Pvariance)
  Pvariancenum=gsub("a\\.u\\.\\^2","",Pvariance)
  df$Pvariance[rindx]=Pvariancenum
  
  loc.Nvariance=max(grep("Negative variance:",logfile))
  Nvariance=logfile[loc.Nvariance]
  Nvariance=gsub("Negative variance:","",Nvariance)
  Nvariance=gsub(" ","",Nvariance)
  Nvariance=gsub("\\(.*\\)","",Nvariance)
  Nvariancenum=gsub("a\\.u\\.\\^2","",Nvariance)
  df$Nvariance[rindx]=Nvariancenum
  
  loc.BOC=max(grep("Balance of charges \\(nu\\):",logfile))
  BOC=logfile[loc.BOC]
  BOC=gsub("Balance of charges \\(nu\\):","",BOC)
  BOCnum=gsub(" ","",BOC)
  df$BOC[rindx]=BOCnum
  
  loc.POS=max(grep("Product of sigma\\^2\\_tot and nu:",logfile))
  POS=logfile[loc.POS]
  POS=gsub("Product of sigma\\^2\\_tot and nu:","",POS)
  POS=gsub(" ","",POS)
  POS=gsub("\\(.*\\)","",POS)
  POSnum=gsub("a\\.u\\.\\^2","",POS)
  df$POS[rindx]=POSnum

  loc.Pi=max(grep("Internal charge separation \\(Pi\\):",logfile))
  Pi=logfile[loc.Pi]
  Pi=gsub("Internal charge separation \\(Pi\\):","",Pi)
  Pi=gsub(" ","",Pi)
  Pi=gsub("\\(.*\\)","",Pi)
  Pinum=gsub("a\\.u\\.","",Pi)
  df$Pi[rindx]=Pinum

  loc.MPI=max(grep("Molecular polarity index \\(MPI\\):",logfile))
  MPI=logfile[loc.MPI]
  MPI=gsub("Molecular polarity index \\(MPI\\):","",MPI)
  MPI=gsub(" ","",MPI)
  MPI=gsub("\\(.*\\)","",MPI)
  MPInum=gsub("eV","",MPI)
  df$MPI[rindx]=MPInum

  loc.NSA=max(grep("Nonpolar surface area \\(.*\\):",logfile))
  NSA=logfile[loc.NSA]
  NSA=gsub("Nonpolar surface area \\(.*\\):","",NSA)
  NSA=gsub(" ","",NSA)
  NSA=gsub("\\(.*\\)","",NSA)
  NSAnum=gsub("Angstrom\\^2","",NSA)
  df$NSA[rindx]=NSAnum
  
  loc.PSA=max(grep("Polar surface area \\(.*\\):",logfile))
  PSA=logfile[loc.PSA]
  PSA=gsub("Polar surface area \\(.*\\):","",PSA)
  PSA=gsub(" ","",PSA)
  PSA=gsub("\\(.*\\)","",PSA)
  PSAnum=gsub("Angstrom\\^2","",PSA)
  df$PSA[rindx]=PSAnum
  
  }
write.csv(df, file="D:/111/msf/fchk/Txt_Surface_173.csv", row.names=F)
