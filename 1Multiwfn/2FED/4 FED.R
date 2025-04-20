# -2 to -1
# Collect f+ and f- of FED
#  f0=(f+ + f-)/2 ; △f= f+ - f- 

# Clear all variables
rm(list = ls(all=TRUE))
# close all figures
graphics.off() 

library(stringr)
library(plyr)

# List txt files from directory, extract chemical name
data=dir(path="D:/111/msf/Multiwfn/FED/fchk/", pattern="\\_FED.txt")

# Remove extension, leading p
data=gsub("_FED.txt","",data)
chemical=gsub("p","",data)

#Build the data frame df
df=data.frame(chemical)

df$Warning= NA
df$LUMOOcc=NA
df$HOMOOcc=NA
  df$FEDLUMOmax = NA
  df$FEDHOMOmax = NA
  df$FEDLUMOmin = NA
  df$FEDHOMOmin = NA
df$TotalFEDLUMO = NA
df$TotalFEDHOMO = NA
df$LUMO_delocalization_index= NA
df$HOMO_delocalization_index= NA 

# Loop through all txt files in directory
for (i in 1:length(chemical)){
  
  #     Scan in each txt file
  fptxt <- paste("D:/111/msf/Multiwfn/FED/fchk/p", chemical[i], "_FED.txt", sep="")  
  
  txtfile <- scan(file=fptxt, what=character(), sep="\n")
  
  # Index current chemical in data frame
  rindx = grep(paste("^",chemical[i],"$",sep=""),df$chemical)
  
  Warn = grep("Warning", txtfile)
  df$Warning[rindx] = length(Warn)
  # collect Orbital delocalization index
  DI = grep("Orbital delocalization index", txtfile)
  df$LUMO_delocalization_index[rindx] = as.numeric(gsub(x=str_sub(string=txtfile[max(DI)], start=-8), pattern=" ", replacement=""))
  df$HOMO_delocalization_index[rindx] = as.numeric(gsub(x=str_sub(string=txtfile[min(DI)], start=-8), pattern=" ", replacement=""))
    
  # collect The sum of contributions before normalization
  Contributions = grep("The sum of contributions before normalization", txtfile)
  df$TotalFEDLUMO[rindx] = as.numeric(gsub(x=str_sub(string=txtfile[max(Contributions)], start=-25, end=-2), pattern=" ", replacement=""))
  df$TotalFEDHOMO[rindx] = as.numeric(gsub(x=str_sub(string=txtfile[min(Contributions)], start=-25, end=-2), pattern=" ", replacement=""))

  # 做for循环前，一定要先定义变量
  FEDLUMOnum = NULL
  LUMO_start = max(Contributions)+2
  LUMO_end = max(DI)-1
  for (j in LUMO_start:LUMO_end){
    FEDLUMOnum[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=-13, end=-2), pattern=" ", replacement=""))
  }
  FEDHOMOnum = NULL
  HOMO_start = min(Contributions)+2
  HOMO_end = min(DI)-1
  for (j in HOMO_start:HOMO_end){
    FEDHOMOnum[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=-13, end=-2), pattern=" ", replacement=""))
  }
  df$FEDLUMOmax[rindx] = max(FEDLUMOnum[LUMO_start:LUMO_end])
  df$FEDHOMOmax[rindx] = max(FEDHOMOnum[HOMO_start:HOMO_end])
  df$FEDLUMOmin[rindx] = min(FEDLUMOnum[LUMO_start:LUMO_end])
  df$FEDHOMOmin[rindx] = min(FEDHOMOnum[HOMO_start:HOMO_end])
  
  # Collect Occ to proofing
  LUMOOcc = max(Contributions)-2
  HOMOOcc = min(Contributions)-2
  df$LUMOOcc[rindx] = as.numeric(gsub(x=str_sub(string=txtfile[LUMOOcc], start=50, end=60), pattern=" ", replacement=""))
  df$HOMOOcc[rindx] = as.numeric(gsub(x=str_sub(string=txtfile[HOMOOcc], start=50, end=60), pattern=" ", replacement=""))
}
write.csv(df, file="D:/111/msf/Multiwfn/FED/fchk/txt_FED_140.csv", row.names=F)
