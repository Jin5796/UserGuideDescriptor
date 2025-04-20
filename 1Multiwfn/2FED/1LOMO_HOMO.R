library(stringr)
library(plyr)
home='D:/111/msf/Multiwfn/FED/fchk/'
data=dir(path=paste(home,sep=""),pattern="\\.txt")

data=gsub("_LOMO_HOMO.txt","",data)
chemical=gsub("p","",data)

df=data.frame(chemical)
df$LUMOOrbital=NA
df$HOMOOrbital=NA
df$LUMO1=NA
df$LUMO2=NA
df$HOMO1=NA
df$HOMO2=NA


for (i in 1:length(chemical)){
  fp <- paste(home,"/LUMO_HOMO/p", chemical[i], "_LOMO_HOMO.txt", sep="")  
  logfile <- scan(file=fp, what=character(), sep="\n")
  rindx=grep(paste("^",chemical[i],"$",sep=""),df$chemical)
    
  loc.LUMO1=max(grep("LUMO,",logfile))
  LUMOOnum = as.numeric(gsub(x=str_sub(string=logfile[loc.LUMO1], start=15, end=21), pattern=" ", replacement=""))
  df$LUMOOrbital[rindx] = LUMOOnum
  LUMO1=logfile[loc.LUMO1]
  LUMO1=gsub("a\\.u\\.","\\(",LUMO1)
  LUMO1=gsub("eV","\\)",LUMO1)
  LUMO1=gsub("\\(.*\\)","",LUMO1)
  LUMO1=gsub(" ","",LUMO1)
  LUMO1=gsub("Orbital","\\(",LUMO1)
  LUMO1=gsub(":","\\)",LUMO1)
  LUMO1num=gsub("\\(.*\\)","",LUMO1)
  df$LUMO1[rindx]=LUMO1num

  loc.LUMO2=max(grep("LUMO,",logfile))
  LUMO2=logfile[loc.LUMO2]
  LUMO2=gsub(" ","",LUMO2)  
  LUMO2=gsub("a\\.u\\.","\\)",LUMO2)
  LUMO2=gsub("Orbital","\\(",LUMO2)
  LUMO2=gsub("\\(.*\\)","",LUMO2)  
  LUMO2num=gsub("eV","",LUMO2)
  df$LUMO2[rindx]=LUMO2num
  
  loc.HOMO1=max(grep("HOMO,",logfile))
  HOMOOnum = as.numeric(gsub(x=str_sub(string=logfile[loc.HOMO1], start=15, end=21), pattern=" ", replacement=""))
  df$HOMOOrbital[rindx] = HOMOOnum
  HOMO1=logfile[loc.HOMO1]
  HOMO1=gsub("a\\.u\\.","\\(",HOMO1)
  HOMO1=gsub("eV","\\)",HOMO1)
  HOMO1=gsub("\\(.*\\)","",HOMO1)
  HOMO1=gsub(" ","",HOMO1)
  HOMO1=gsub("Note:","\\(",HOMO1)
  HOMO1=gsub(":","\\)",HOMO1)
  HOMO1num=gsub("\\(.*\\)","",HOMO1) 
  df$HOMO1[rindx]=HOMO1num
  
  loc.HOMO2=max(grep("HOMO,",logfile))
  HOMO2=logfile[loc.HOMO2]
  HOMO2=gsub(" ","",HOMO2)  
  HOMO2=gsub("a\\.u\\.","\\)",HOMO2)
  HOMO2=gsub("Note","\\(",HOMO2)
  HOMO2=gsub("\\(.*\\)","",HOMO2)  
  HOMO2num=gsub("eV","",HOMO2)
  df$HOMO2[rindx]=HOMO2num
   
}
write.csv(df, file="LOMO_HOMO_140_orbital.csv", row.names=F)