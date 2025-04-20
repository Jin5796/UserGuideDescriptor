# -2 to -1
# Collect f+ f- f0 △f
# 
# Clear all variables
rm(list = ls(all=TRUE))
# close all figures
graphics.off() 

library(stringr)
library(plyr)

# List txt files from directory, extract chemical name
data=dir(path="F:/2ndALL/0 Gaussian16/HF_N_fchk/WOFukui/", pattern="\\_Weighted_Condensed_FuiKui.txt")

# Remove extension, leading p
data=gsub("_Weighted_Condensed_FuiKui.txt","",data)
chemical=gsub("p","",data)

#Build the data frame df
df=data.frame(chemical)

df$Warning= NA
df$Radialpo= NA
df$Angularpo= NA
  df$FwLUMOmax = NA
  df$FwHOMOmax = NA
  df$FwRadicalmax = NA
  df$FwDualmax = NA
  df$FwLUMOmin = NA
  df$FwHOMOmin = NA
  df$FwRadicalmin = NA
  df$FwDualmin = NA
df$TotalFwLUMO = NA
df$TotalFwHOMO = NA  

# Loop through all txt files in directory
for (i in 1:length(chemical)){
  
  #     Scan in each txt file
  fptxt <- paste("F:/2ndALL/0 Gaussian16/HF_N_fchk/WOFukui/p", chemical[i], "_Weighted_Condensed_FuiKui.txt", sep="")  
  
  txtfile <- scan(file=fptxt, what=character(), sep="\n")
  
  # Index current chemical in data frame
  rindx = grep(paste("^",chemical[i],"$",sep=""),df$chemical)
  
  # collect accuracy of FBO-Calculation
  Warn = grep("Warning", txtfile)
  Radial = grep("Radial points", txtfile)
  Angular = grep("Angular points", txtfile)
  
  Radialponum = as.numeric(gsub(x=str_sub(string=txtfile[Radial], start=16, end=24), pattern=" ", replacement=""))
  Angularponum = as.numeric(gsub(x=str_sub(string=txtfile[Angular], start=40, end=47), pattern=" ", replacement=""))
  
  df$Warning[rindx] = length(Warn)
  df$Radialpo[rindx] = Radialponum
  df$Angularpo[rindx] = Angularponum
    
  # collect Fuzzy Bond order
  FK1 = grep("OW f\\+", txtfile)
  FK1 = FK1+1
  FK3 = grep("Sum of orbital weighted f\\+", txtfile)
  FK4 = FK3+1
  FK2 = FK3-1

  
  FLUMOnum = NULL
  FHOMOnum = NULL
  FRadicalnum = NULL
  FDualnum = NULL
  for (j in FK1:FK2){
    FLUMOnum[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=18, end=26), pattern=" ", replacement=""))
    FHOMOnum[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=33, end=41), pattern=" ", replacement=""))
    FRadicalnum[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=48, end=56), pattern=" ", replacement=""))
    FDualnum[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=-8), pattern=" ", replacement=""))     
	}
  FLUMOmaxnum = max(FLUMOnum[FK1:FK2])
  FHOMOmaxnum = max(FHOMOnum[FK1:FK2])
  FDualmaxnum = max(FDualnum[FK1:FK2])
  FRadicalmaxnum = max(FRadicalnum[FK1:FK2])
  FLUMOminnum = min(FLUMOnum[FK1:FK2])
  FHOMOminnum = min(FHOMOnum[FK1:FK2])
  FDualminnum = min(FDualnum[FK1:FK2])
  FRadicalminnum = min(FRadicalnum[FK1:FK2])
  
  TLUnum = as.numeric(gsub(x=str_sub(string=txtfile[FK3], start=-9), pattern=" ", replacement="")) 
  THOnum = as.numeric(gsub(x=str_sub(string=txtfile[FK4], start=-9), pattern=" ", replacement=""))   
  
  df$FwLUMOmax[rindx] = FLUMOmaxnum
  df$FwHOMOmax[rindx] = FHOMOmaxnum
  df$FwDualmax[rindx] = FDualmaxnum
  df$FwRadicalmax[rindx] = FRadicalmaxnum
  df$FwLUMOmin[rindx] = FLUMOminnum
  df$FwHOMOmin[rindx] = FHOMOminnum
  df$FwDualmin[rindx] = FDualminnum
  df$FwRadicalmin[rindx] = FRadicalminnum 
  
  df$TotalFwLUMO[rindx] = TLUnum
  df$TotalFwHOMO[rindx] = THOnum 
  
}
write.csv(df, file="F:/2ndALL/0 Gaussian16/txt_Weighted_Condensed_FuiKui_173.csv", row.names=F)
